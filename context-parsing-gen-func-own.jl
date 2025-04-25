# include("julia-to-z3.jl")
include("julia-to-smt.jl")


mutable struct RandomChoiceScope
    variable
    distribution
    scope
end

mutable struct VariableAssignmentContext
    variable
    expr
    scope
end


"""
Example:
For the following code: 
if A
    blah
elseif earthquake
    blah
the condition is parsed as follows
quote
    #= none:9 =#
    earthquake
end

This function simplifies to :earthquake

"""
function remove_blocks_from_condition(condition)
    if condition isa Expr
        if condition.head == :block
            # println("BOO $(condition.args[2])")
            return condition.args[2] #TODO is the assumption generally valid or do I need to loop though.
        end
    end
    # otherwise its a symbol
    return condition
end

vari_map = Dict()
rcs_with_scopes = []
variables_with_context = []
smt_var_map = Dict() #for smt consdtraints


# println("HERE")
# println(RESULTS_DIR[])
# println("HERE")

# Function to analyze the AST and variable scopes
#SCOPE repreents a list of condition that need to be true such that the variable is sampled from a certain distribution
function analyze_scope(expr, current_scope=[], log = false)#, log = false)
    if (!(expr isa LineNumberNode))
        if log
            println("----")
            print("Current HEAD: ")
            println(expr.head)
        end
        
        if expr isa Expr
            if expr.head == :toplevel
                return analyze_scope(expr.args[1], current_scope) # TODO: if a set of blocks is given, this should go in all expr.args
            elseif expr.head == :macrocall
                return analyze_scope(expr.args[3], current_scope)
            elseif expr.head == :function
                # Function entry
                function_name = expr.args[1]
                if log 
                    println("Entering function: $function_name")
                end
                    return analyze_scope(expr.args[2], current_scope)
            elseif expr.head == :block
                # Block entry
                rcwc = []
                for subexpr in expr.args
                    line_scope  = analyze_scope(subexpr, current_scope)
                    append!(rcwc, line_scope)
                end
                return rcwc
            elseif expr.head == :if 
                condition = remove_blocks_from_condition(expr.args[1])
              
                if log
                    println("Condition: $condition introduces new scope")
                end
                scopeif = deepcopy(current_scope)
                push!(scopeif, condition)
                scopeelse = deepcopy(current_scope)
                push!(scopeelse, Expr(:call, :!, condition)) #todo change to !cond
               
                A = analyze_scope(expr.args[2], scopeif)  # Then branch
                if length(expr.args) == 3
                    B = analyze_scope(expr.args[3], scopeelse)  # Else branch (negated condition)
                    
                    return [A..., B...]
                else 
                    return A
                end

            elseif expr.head == :elseif 
                condition = remove_blocks_from_condition(expr.args[1])
                if log
                    println("Condition: $condition introduces new scope")
                end
                
                scopeif = deepcopy(current_scope)
                push!(scopeif, condition)
                scopeelse = deepcopy(current_scope)
                push!(scopeelse, Expr(:call, :!, condition)) #todo change to !cond
                
                A = analyze_scope(expr.args[2], scopeif)  # Then branch                
                if length(expr.args) == 3
                    B = analyze_scope(expr.args[3], scopeelse)  # Else branch (negated condition)
                    return [A..., B...]
                else 
                    return A
                end
                
                return[A..., B...]
                
            elseif expr.head == :(=) # ASSIGNMENTS
                var = expr.args[1]
                assig = expr.args[2] #(~ distrib(p,))
                if assig isa Expr
                    if assig.head == :call 
                        if assig.args[1] == :~
                            adr = assig.args[2]
                            distro = assig.args[3] #(~ distrib(p,))
                            
                            if log
                                println("Var assginment detected $var ~ $distro in context: $current_scope")
                            end
                            rcs = RandomChoiceScope(var, distro, current_scope) #TODO use unique address or var name

                            push!(rcs_with_scopes, rcs) 
                            return [rcs]
                        else 
                            # Normal assignment x = a op b
                            push!(variables_with_context, VariableAssignmentContext(string(var), expr.args[2], current_scope))

                            return []
                        end
                    else 
                        # var = expr
                        # WE are treating normal variable assignments that should be translated dirrectly into current_scope
                        push!(variables_with_context, VariableAssignmentContext(string(var), expr.args[2], current_scope))

                        return []
                    end
                else 
                    #VAR = simpleType (Int64, )
                    push!(variables_with_context, VariableAssignmentContext(string(var), expr.args[2], current_scope))
                    return []
                end
                
                return []
            elseif expr.head == :call
                if expr.args[1] == :~
                    var = expr.args[2]
                    distro = expr.args[3] # :(bernoulli(0.9))
                    
                    var_name = string(expr.args[2])
                    name = get_new_unique_name(var_name).first
                    #TODO actually we need to create B,B1,B2 when we encounter the second B
                    typeFromDistro = type_from_distribution(distro) 

                    if log
                        println("Var assginment detected $var ~ $distro in context: $current_scope")
                    end

                    if (get_new_unique_name(var_name).second != 1)
                    
                        vari_map[name] = create_new_decision_var(name, typeFromDistro)
                        
                        rcs = RandomChoiceScope(name, distro, current_scope)
                        push!(rcs_with_scopes, rcs)
                        return [rcs]
                    else                      

                        #Special case, means first encountered B should actually be B1
                        B1_distr = B1_scope = nothing
                        for s in rcs_with_scopes
                            if s.variable == var_name
                                B1_distr = s.distribution
                                B1_scope = s.scope
                            end
                        end
                 
                        #Remove old B variable
                        filter!(x -> x.variable != var_name, rcs_with_scopes)
                        
                        # # Add B, with unknown distribution
                        # #We assume that the type of values (:int, :bool) doesnt change accros branch variables 
                        # # TODO maybe scope = Any[] is not good
                        vari_map[var_name] = create_new_decision_var(var_name, typeFromDistro)
                        rcs = RandomChoiceScope(var_name, :(unknown()), Any[]) 
                        push!(rcs_with_scopes, rcs)
                        
                        # # Re-add previous B as B1
                        vari_map[name] = create_new_decision_var(name, typeFromDistro)
                        rcs = RandomChoiceScope(name, B1_distr, B1_scope)
                        push!(rcs_with_scopes, rcs)
                        

                        # #Add curetn RC as B2
                        name = get_new_unique_name(var_name).first
                        vari_map[name] = create_new_decision_var(name, typeFromDistro)
                        rcs = RandomChoiceScope(name, distro, current_scope)
                        push!(rcs_with_scopes, rcs) 
     
                       
                        return [rcs]
                    end
                end
            
            elseif expr.head == :for
                println("FOR")
                #Current assumption: simple if with defined valued uper bound for i = 1:n, no nested loops
                iter = expr.args[1] # :(i = 1:10)
                i_var = iter.args[1]# iterator variable
                interval_lb, interval_up = iter.args[2].args[2], iter.args[2].args[3]
                
                #TODO: to do properly i is probably going to be added to a context such that we can call this function recursively
                for i = eval(interval_lb):eval(interval_up)
                    # run_context += ("i" => i) # add running context so addresses can be defined 
                    # analyze_scope()
                    println("Assign new $i")
                end
            end

        end
    end
    return [] # for linenumbers and possibly others
end

"""Take a expression representing the parsed distribution (eg. :(bernoulli(0.9))). 
returns the type of value the random choice takes depending on the deistributions"""
function type_from_distribution(distr_expr)
    distribution_name = string(distr_expr.args[1])
    
    if distribution_name == "bernoulli"
        return :Int
    elseif distribution_name == "uniform"
        return :Real
    elseif distribution_name == "uniform_discrete"
        return :Int
    elseif distribution_name == "normal"
        return :Real
    elseif distribution_name == "gamma"
        return :Real
    elseif distribution_name == "poisson"
        return :Int
    elseif distribution_name == "beta"
        return :Real
    elseif distribution_name == "exponential"
        return :Real
    #TODO exhaustive
    else
        error("Unrecognized distribution: $distribution_name")
    end
end


function get_new_unique_name(name)
    if (get!(vari_map, name, nothing) == nothing)
        return name => 0

    else
        i = 1
        while(get!(vari_map, "$(name)_$i", nothing) != nothing)
            i+=1
        end
        return "$(name)_$i" => i 
    end 
end


# cd(@__DIR__)
ppfile = get(ARGS, 1, "ppmodel.jl")
ppfile = "inference/" * ppfile

RESULTS__DIR = get(ARGS, 2, "")

# ppfile = "ppmodel.jl"
model_code = read(ppfile, String) #Read probabilistic model from julia file

parsed_model = Meta.parse(model_code) #parses code snippet into AST
dump(parsed_model)
println("-----------------------------------------")
# Analyze the parsed model to get random choices and thebranches they are in, other variable assignments

rcs = analyze_scope(parsed_model)

# println("scopes non lin: $rcs_with_scopes")
# println("HERE NEW MAP $vari_map")
# Create alive constraints for the random choices (Alive constraints are conditions for their stochastic existance)
alive_constraints = Vector{AbstractExpr}()
for elem in rcs_with_scopes
    if elem isa RandomChoiceScope
        name = elem.variable
        # println(!("$(name)_1" in keys(vari_map)))
        if !("$(name)_1" in keys(vari_map)) #For Branch variables (B) dont print alive constraint as it will be calculated later in Py
            alive_name = "alive$name"
            # println(alive_name)
            alive = create_new_decision_var(alive_name, :Bool)

            conds = elem.scope
            rec = true
            for cond in conds
                subcond = expr_to_smt(cond, vari_map)
                rec = and([subcond, rec])
            end
            # println("full condition: $(smt(rec))")
            push!(alive_constraints, alive == rec) 
            # print("\n")
        end
    end
end


# Construct evaluator context 
#TODO RC vars should apear in the context with their associated types
M = Module()

# add RC variables to evaluator with some placeholder values so the evaluator can check the type
for elem in rcs_with_scopes
    if elem isa RandomChoiceScope
        # TODO: Should Bernoulli be a true/false instead?
        value = 1.0 #float for most distributions
        if string(elem.distribution) == "uniform" #other discrete distributions TODO categorical, etc
            value = 1 # int
        end
           
        name = elem.variable
        expr = :($(Symbol(name)) = 1.0) #RC will be evaluated as a float/int because of the assignment

        Base.eval(M, expr) 
    end
end

#For each variable assignment create an equivalent equality constraint in the smt model
var_constraints = Vector{AbstractExpr}()
for elem in variables_with_context
    name = elem.variable
    
    #Book-keeping for evaluator
    assignment_expr = :($(Symbol(name)) = $(elem.expr))
    Base.eval(M, assignment_expr )# eval assignment expresion to build context for future evals
    # println(( names(M, all=true))) # current context

    # Determine expression type for the decision variable declaration
    julia_type = typeof(Base.eval(M, elem.expr))
    type = julia_type_to_smt_type(julia_type)

    # Transform expr to smt expr 
    expr = expr_to_smt(elem.expr, vari_map)

    # Create new decision variable for the assignment
    var = create_new_decision_var(name, type)
    vari_map[name] = var

    # Add the variable  assignment as a cosntraint to the smt model
    push!(var_constraints, var == expr) 
end

# Alive conditions for normal variable assignments
# for elem in variables_with_context
#     name = elem.variable
#     alive_name = "alive$name"
#     alive = create_new_decision_var(alive_name, :Bool)

#     conds = elem.scope
#     rec = true
#     for cond in conds
#         subcond = expr_to_smt(cond, vari_map)
#         rec = and([subcond, rec])
#     end
#     # println("full condition: $(smt(rec))")
#     push!(alive_constraints, alive == rec) 
#     print("\n")
# end


for elem in rcs
    if elem isa RandomChoiceScope
        elem.scope = (x -> string(x)).(elem.scope)
    end
end

open(RESULTS__DIR * "parsing_results/vardump.txt", "w")  do file
    for elem in rcs_with_scopes
        if elem isa RandomChoiceScope
            println(file, "$(elem.variable) ~ $(string(elem.distribution)) in $(elem.scope)")
        else
            println(file, "$(elem.variable) = $(string(elem.expr)) in $(elem.scope)")
        end
    end
end

open(RESULTS__DIR * "parsing_results/smtdump.txt", "w")  do file
    print(file, smt(alive_constraints))

    print(file, smt(var_constraints))
end

# open("smt-var-dump.txt", "w")  do file
#     print(file, smt(var_constraints))
# end





