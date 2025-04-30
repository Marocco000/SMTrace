import Random, Logging
# include(joinpath(@__DIR__, "julie", "config.jl"))

# Disable logging, because @animate is verbose otherwise
Logging.disable_logging(Logging.Info);


# Incorporate observation into choice_map
#USER DEFINED
function add_observation_to_smt_model(obs)
    # Dump observations in a file to be picked up python script
    open(RESULTS_DIR[] * "parsing_results/obs.txt", "w") do file
        for (key, value) in get_values_shallow(obs)
            println(file, "$key = $value")
        end
    end

end

function ransac_smt(observations, ppfile, with_block = true)
    
    # Clear terminal and set correct directory
    # print("\033c") # clean terminal log
    print("STARTING SMT RANSAC")

    cd(@__DIR__)

    # Saves SMT trace in new RUN_XX directory
    if !with_block #REFACTOR #otherwise folder was created in block_smt
        set_current_run() 
    end

    # Run the julia parser
    # println("Running julia parser:")
    run(`julia context-parsing-gen-func-own.jl $ppfile $(RESULTS_DIR[])`)
    # println("Julia parser complete!")

    # Incorporate observations
    add_observation_to_smt_model(observations) #TODO heree?

    if !with_block
        open(RUN_DIR[] * "parsing_results/block.txt", "w") do file

            println(file, "")
               
        end
    end

    # Create & run python model
    println("Running py modeling:")
    run(`/home/mars/Documents/Documents/Study/Master/thesis/pipe/venv/bin/python main.py $(RESULTS_DIR[]) $(RUN_DIR[])`)
    println("Py modeling complete!")

    #TODO(prio: late) print full model in smt file with comments on variable and their distr for human checking purposes and model reuse 

    #TODO separate model creation from running :)
    #TODO improve current trace option. 

    # Run python model
    #TODO hyper strategies (obj function, block resim, fixing certain choices)


    # Receive trace back from SMT solver
    choices = smt_choices()

    # Create trace from smt choices 
    if !isempty(choices) 
        trace, weight = generate(ppmodel, (), choices)
    
        return trace
    else 
        return nothing
    end
    # Use this trace as initial starting point for MH

    # println("Trace: $trace with weight $weight")
    # Plots.plot(visualize_trace(trace, title="SMT (init) trace"))

    # Plots.plot([visualize_trace(tr, title="SMT (init) trace") for t in traces]...)

    #Ransac proposal (gaussian shift)
    # generate_ransac_proposal() 

    
end

function smt_choices()
    # Populate a choice map object with the values returned by the SMT solver for the RC variables
    choices = Gen.choicemap()  # Initialize empty choice map

    # Open and read file containing latent variables and their values 
    open(RUN_DIR[] * "solver_results/model_solution.txt", "r") do file
        for line in eachline(file)
            line = strip(line)  # Remove spaces/newlines
            if occursin("=", line)  # Ensure it's a valid key-value pair
                key, value = split(line, "=", limit=2)  # Split at first '='
                choices[Symbol(strip(key))] = eval(Meta.parse(strip(value)))  # Convert value and store
            end
        end
    end

    return choices
end

function reuse_warm_start()
    """Little hack for easier benchmark. Take car ethat model is not taking random choices like for variance. Model has to be put at base of RESULTS_DIR """
    # Populate a choice map object with the values returned by the SMT solver for the RC variables
    choices = Gen.choicemap()  # Initialize empty choice map

    # Open and read file containing latent variables and their values 
    open(RESULTS_DIR[] * "solver_results/model_solution.txt", "r") do file
        for line in eachline(file)
            line = strip(line)  # Remove spaces/newlines
            if occursin("=", line)  # Ensure it's a valid key-value pair
                key, value = split(line, "=", limit=2)  # Split at first '='
                choices[Symbol(strip(key))] = eval(Meta.parse(strip(value)))  # Convert value and store
            end
        end
    end

    if !isempty(choices) 
        trace, weight = generate(ppmodel, (), choices)
    
        return trace
    else 
        return nothing
    end
end


# """Generates the generative proposal to be used in the MH step. It takes a list of values and samples the RCs around those values"""
# function generate_ransac_proposal()

#     choices = smt_choices()
#     open("ppmodelproposal.jl", "w") do file
#         println(file, "@gen function smt_proposal()")
        
#         #TODO(hard) deal with ControlFlow changing variables, then new values for the new Rcs have to be provided
#         # Sample RCs from SMT value + random noise 
#         # end
#         #TODO will SMT solution RC order pose a problem here? the proposal distribution shoiuld mimic the original 
#         #TODO what is get_values_shallow, is it missing elems (subtraces) 

#         tab = "\t"
#         for (key, value) in get_values_shallow(choices)
#             println(file, "$tab$key ~ normal($value, epsilon)")    
#         end
#         println(file, "end")
#     end
# end



# @gen function smt_proposal(tr)
#     epsilon = 0.01
#     #Bernoulli makes no sense to get gaussian drift
# 	# A ~ normal(tr[:A], epsilon)
# 	# B ~ normal(tr[:B], epsilon)

# 	C ~ normal(tr[:C], epsilon)
# end


# function smt_update(tr)
#     #block resim 
#     #gaussian drift on non control-flow-changing Rcs
    
#     # Gaussian drift over past trace values #TODO problematic with control flow 
#     #Makes llittle sense
#     # (tr, _) = mh(tr, smt_proposal)


#     #TODO do this with no seelction? subject all (requires model, can we do auto)
#     #OR leave to programmer 
#     # params = select(:A, :B, :C)
#     # (tr, _) = mh(tr, params)


#     cfc_vars = select(:A)
#     cfc_invars = select(:B, :C)

#     #refine vars that dont change control flow
#     for j = 1:10
#     # (tr, _) = mh(tr, cfc_vars)
#         (tr, _) = mh(tr, cfc_invars)

#     end
#     tr

#     # User defined block resimulation
#     block_selection = select(:A)
#     (tr, _) = mh(tr, block_selection) # generate trace with new values for block vars
#     block_constraints_smt(block_selection, tr) # dumps fixed adr constraints
#     # TODO call make model with extra consrtaints and run (reuse previous model)

#     tr

# end

function block_smt_with_fixed_selection(fixed_selection, tr, observations, ppfile)
    return block_smt(fixed_selection, tr, observations, ppfile, true)
end

"""Runs the solver for the partial trace optimizing just for selection. The other variables will remain fixed in the current trace.
In case reverse=true. Than the varibales in selection will remain fixed and the optimization will include all other variables."""
function block_smt(selection, tr, observations, ppfile, reverse = false)
    
    set_current_run() #creats a new RUN_XX results folder
    
    # Get SMT trace that optimizes only on the addresses in selection 
    block_constraints_smt(selection, tr, observations, reverse) # save values form trace for the addresses not in selection to be used as constraints.
    println(selection)
    
    block_tr = ransac_smt(observations, ppfile) # run smt with the obs + selection constriants
    block_tr
end

# """Takes a selection of variables that should be resampled(optimized) together while assuming all others are fixed. 
# This method takes the values of the respective not-selected addresses and prints the adr = value pairs in a file.
# The respective file is going to be taken as constraints for finding optimal assignment of the selected addresses."""
function block_constraints_smt(selection, tr, observations, reverse)

    open(RUN_DIR[] * "parsing_results/block.txt", "w") do file

        # Iterate over the selected choices and fix all other ones that are not already observations
        for choice in get_values_shallow(get_choices(tr))
            key = choice[1]    
            if !Gen.has_value(observations, key)     
                if (!reverse && !(key in selection)) || (reverse && key in selection) 
                    value = choice[2]
                    value = Float64(value) # in case its a bool result from Bernoulli  
                    println(file, "$key = $value")
                end
            end
        end
    end
end

# function smt_inference()

#     #initialize first strace as smt model_solutio
#     choices = smt_choices()
#     tr, weight = generate(pmodel, (), choices)

#     for iter=1:5
#         tr = smt_update(tr)
#     end
#     println("final trace: $tr")
#     tr
# end

# # @gen function ransac_proposal(prev_trace, xs, ys)
# #     # (slope_guess, intercept_guess) = ransac(xs, ys, RANSACParams(10, 3, 1.))
# #     # slope ~ normal(slope_guess, 0.1)
# #     # intercept ~ normal(intercept_guess, 1.0)
# # end


# # function ransac_update(tr)
# #     # Use RANSAC to (potentially) jump to a better line
# #     # from wherever we are
# #     (tr, _) = mh(tr, ransac_proposal, (xs, ys))
# #     #...
# # end
# # function logmeanexp(scores)
# #     logsumexp(scores) - log(length(scores))
# # end;

# # scores = Vector{Float64}(undef, 10)
# # for i=1:10
# #     # @time tr = ransac_inference(xs, ys, observations)
# #     @time tr = smt_inference()
# #     scores[i] = get_score(tr)
# # end

# # println("scores: $scores")
# # println("Log probability: ", logmeanexp(scores))


