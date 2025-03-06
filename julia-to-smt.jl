using Satisfiability
# print("\033c") # clean terminal log


function julia_type_to_smt_type(type)
    if type == Int64 || type == IntExpr
        return :Int
    elseif type == Float64
        return :Real
    elseif type == Bool || type == BoolExpr
        return :Bool
    else 
        error("unknown type: $type")
    end
end

"""
type should be :Bool, :Int or :Real
"""
function create_new_decision_var(name, type)
    var = Symbol("$name")

    #creates the sat variable
    # Symbol("$type")
    expr = Expr(:macrocall, Symbol("@satvariable"), 0, var, type)  # Construct macro call
    eval(expr) 

    #returns the model var
    return eval(var)
end

# function create_smt_vars()
#     #TODO create auto 
#     #TODO problematic with recreating the vars in python :)
#     #TODO problem with branch vars, which name to use
#     @satvariable(truey, Bool)

#     @satvariable(A, Int)
#     @satvariable(B, Int)
#     @satvariable(C, Real)

#     var_map = Dict()
#     var_map["A"] = A
#     var_map["B"] = B
#     var_map["C"] = C
#     return var_map
# end

# create_smt_vars()
# exprs = [var]

# status = sat!(exprs, solver=Z3())

# cd(@__DIR__)
# open("smt-dump.txt", "w")  do file
#     print(file, smt(exprs))
# end

    """Transforms a julia/gen expression into z3 expression"""
#TODO exhaustive, probably tb divided into subfunc
function expr_to_smt( expr, var_map)
    # println("$expr")
    if expr isa Symbol
        var_ref = get!(var_map, string(expr), nothing)
        if isnothing(var_ref)
            error("Undefined symbol: $expr")
        end
        return var_ref
        #TODO check if it was defined before in RCs or simple Assignments
        # return get!(var_map, string(expr), 0.1)  #TODO probably still need 
    elseif expr isa Int64
        return eval(expr)
    elseif expr isa Bool
        return eval(expr)
    elseif expr isa Float64
        return eval(expr)

    elseif expr isa Expr
        head = expr.head
        args = expr.args
        if head == :call
            if expr.args[1] == :!
                sub = expr_to_smt( args[2], var_map)
                return not(sub)
            elseif expr.args[1] == :(==)
                left = expr_to_smt(args[2], var_map)
                right = expr_to_smt(args[3], var_map)

                return left == right 
            elseif expr.args[1] == :+
                left = expr_to_smt(args[2], var_map)
                right = expr_to_smt(args[3], var_map)
                return left + right
            elseif expr.args[1] == :-
                left = expr_to_smt(args[2], var_map)
                right = expr_to_smt(args[3], var_map)
                return left - right
            elseif expr.args[1] == :*
                left = expr_to_smt(args[2], var_map)
                right = expr_to_smt(args[3], var_map)
                return left * right
            elseif expr.args[1] == :/
                left = expr_to_smt(args[2], var_map)
                right = expr_to_smt(args[3], var_map)
                return left / right
            end

        end
        if head == :&& 
            println("bau")
            l = expr_to_smt(args[1], var_map)
            r = expr_to_smt(args[2], var_map)
            return and([l,r])
            # return and([true, true])
        elseif head == :|| 
            return or([expr_to_smt( args[1], var_map) , expr_to_smt( args[2], var_map)])
  
        else
            error("Unsupported expression: $expr")
        end
    else
        error("Unexpected type in expression: $expr")
    end
end