using Gen
include("LR-model.jl") # the ppmodel TODO pass the name of the ppmodel function instead of always naming it ppmodel

path = joinpath("..","..", "teste.jl")
include(path) 
ppfile = "LR/LR-model.jl"

#Plotting

using Plots
path = joinpath( "LR-regression_viz.jl")
include(path)

bench = joinpath("..", "..", "julie", "benchmarking.jl")
include(bench)

include(joinpath("..", "..", "julie", "mh_tracker.jl"))

"""Generate data under model"""
function make_synthetic_dataset(n)
    Random.seed!(1)
    noise = 0.5
    true_slope = -1
    true_intercept = 2
    xs = collect(range(-5, stop=5, length=n))
    ys = Float64[]
    for (i, x) in enumerate(xs)
        
        y = true_slope * x + true_intercept + randn() * noise
        
        push!(ys, y)
    end
    Random.seed!()

    (xs, ys)
end

function make_constraints(ys::Vector{Float64})
    constraints = Gen.choicemap()

    for i=1:length(ys) 
        yi = QuoteNode(Symbol(:y, i))
        constraints[eval(yi)] = ys[i]
    end

    constraints
end

"""Creates data and observations"""
function get_data_and_observations()

    #Generate synthetic data
    (xs, ys) = make_synthetic_dataset(20) #TODO change to 100
    
    #Pack data (parameter for the inference procedure)
    data = [xs]

    #Create observations
    observations = make_constraints(ys)
    return (data, observations)
end

"""Inference method for the LR model"""
function inference(data, infer_flavor::Inference_flavor)
    # Unpack data
    xs = data[1]

    # Call inference function
    inference_over_simple_LR(xs, infer_flavor)
end

function inference_over_simple_LR(xs, infer_flavor::Inference_flavor)
    tracker = new_tracker()
    current_gaussian_resources = 0

    #Init trace
    if infer_flavor.warm_start
        # Warm start using the SMT trace
        # init_trace = smt_and_gaussian_drift()
        init_trace = ransac_smt(observations, ppfile, false)
        # init_trace = reuse_warm_start()

        update!(tracker, get_score(init_trace), false, true)
        current_gaussian_resources = infer_flavor.gaussian_drift_res

    else 
        #Random start
        (init_trace, _) = generate(ppmodel, (),  observations)
        update!(tracker, get_score(init_trace), false, false)
    end

    println("Initial score: $(get_score(init_trace))")

    tr = deepcopy(init_trace)
 

    # Run MH for a couple of steps for asympt guarantees ("couple of steps != asymptotic") TODO
    mh_steps_cap = 2000

    # Jumps 
    rejects = 0
    jump_count = 2
    conseq_rejects = 0

    # Sample iterations
    while tracker.mh_steps <= mh_steps_cap
        # TODO add jumps
        line_params = select( :slope, :intercept) #reintroduce noise here TODO

        # conseq_rejects = rejects == 1 ? conseq_rejects + 1 : 0 
        jump_condition = rejects >= 1
        # print("JUMP COND: $jump_condition")
       
        if infer_flavor.warm_jump && jump_condition && jump_count > 0
            # perform warm_jump if possible

            # Block jump
            fixed_selection = select(:slope)
            if jump_count == 1
                fixed_selection = select(:intercept)
            end
            optional_tr = block_smt_with_fixed_selection(fixed_selection, tr, observations, ppfile)
            
            #Score improve jump  
            # optional_tr = score_improve_smt(tr, observations, ppfile)

            if optional_tr === nothing
                println("UNSAT")
                jumpsucc!(tracker, "unsat")

            else 
                score_before = get_score(tr)
                score_smt = get_score(optional_tr)
                # small_prob = 1/10
                # accept_SMT_jump_prob = score_smt > score_before ? 1 : small_prob
                # accept_SMT_jump = rand() < accept_SMT_jump_prob
                accept_SMT_jump = score_smt > score_before
                if accept_SMT_jump
                    tr = optional_tr
                    println("Pre-Jump score: $(get_score(tr))")

                    println("PostJump score: $(get_score(tr))")
                
                    jumpsucc!(tracker, "accepted")
                    update!(tracker, get_score(tr), false, true)        
                    gaussian_drift_resources = infer_flavor.gaussian_drift_res # reset resources after smt jump
                    
                else
                    jumpsucc!(tracker, "unsat")
                end

            end
            jump_count -= 1

        end
        rejects = 0
        if  current_gaussian_resources  > 0 && (infer_flavor.warm_start || infer_flavor.warm_jump)
            (tr, a) = mh(tr, line_drift_proposal, (); observations=observations)
            update!(tracker, get_score(tr), true, false)
            accepted!(tracker, a)
            rejects += (!a ? 1 : 0)

            current_gaussian_resources -= 1
        else
            (tr, a) = mh(tr, select(:intercept, :slope); observations= observations)
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)
            rejects += (!a ? 1 : 0)
        end

    end

    # Plot intial trace, last and best
    # p = Plots.plot([visualize_trace(init_trace, title="SMT (init) trace")
    # , 
    #             visualize_trace(tr, title="last trace"), 
    #             visualize_trace(besttr, title="best trace")
                # ]...)
    # savefig(p, RESULTS_DIR[] *  "LR-SMT-init.png")
    # p

    trim!(tracker, mh_steps_cap)
    print(tracker.jump_successes)
    return tracker
end



# Gaussian drift proposals
@gen function line_drift_proposal(current_trace)
    slope ~ normal(current_trace[:slope], 0.1)
    intercept ~ normal(current_trace[:intercept],0.1)
end

