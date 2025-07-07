using Gen

include("gaussian-model.jl")
ppfile = "Gaussian/gaussian-model.jl"

path = joinpath("..","..", "teste.jl")
include(path) 

smt_infrnc_path = joinpath("..", "..", "julie", "inference-smt.jl")
include(smt_infrnc_path)

logg = joinpath("..", "..", "julie", "logging.jl")
include(logg)

bench = joinpath("..", "..", "julie", "benchmarking.jl")
include(bench)

include(joinpath("..", "..", "julie", "mh_tracker.jl"))


function make_synthetic_data(n)
    Random.seed!(1)

    true_mu = 10
    true_sigma = 10

    ys = Float64[]
    for i = 1:n
        y = true_mu + randn() * true_sigma
        push!(ys, y)
    end
    # print(ys)

    ys
end

function make_constraints(ys::Vector{Float64})
    constraints = Gen.choicemap()

    for i=1:length(ys)
        yi = QuoteNode(Symbol(:y, i))
        constraints[eval(yi)] = ys[i]
    end

    constraints
end

function get_data_and_observations()

    n = 20
    data = make_synthetic_data(n)
    observations = make_constraints(data)
    
    data = Dict("n"=>n)

    return (data, observations)
end

function inference(data, infer_flavor::Inference_flavor)
    # Track score progression and mh steps (drifts, smt-driven)
    tracker = new_tracker()

    # Initial guess
    if infer_flavor.warm_start
        # init_trace = ransac_smt(observations, ppfile, false)
        init_trace = reuse_warm_start()
        
        gaussian_drift_resources = infer_flavor.gaussian_drift_res # set resources after smt start
        update!(tracker, get_score(init_trace), false, true)
    else
        (init_trace, _) = generate(ppmodel, (),  observations)

        gaussian_drift_resources = 0
        update!(tracker, get_score(init_trace), false, false)
    end

    tr = deepcopy(init_trace)


    println("INIT SCORE: $(get_score(tr))")
    
    # Jumps    
    rejects = 0
    jump_count = 2

    mh_steps_cap = 2000

    # Sample iterations
    while tracker.mh_steps <= mh_steps_cap
        jump_condition = rejects > 1
        # println("Jump condition: #rejects: $rejects")
        if infer_flavor.warm_jump && jump_condition && jump_count > 0
            # perform warm_jump if possible
            
            fixed_selection = select(:sigma)
            optional_tr = block_smt_with_fixed_selection(fixed_selection, tr, observations, ppfile)
            # optional_tr = score_improve_smt(tr, observations, ppfile)

            # optional_tr = reuse_warm_start()
            if optional_tr === nothing
                println("UNSAT")
                jumpsucc!(tracker, "unsat")

            else 
                score_before = get_score(tr)
                score_smt = get_score(optional_tr)

                if score_before<score_smt
                    tr = optional_tr
                    # println("Pre-Jump score: $(get_score(tr))")
                    # println("PostJump score: $(get_score(tr))")

                    jumpsucc!(tracker, "accepted")
                    update!(tracker, get_score(tr), false, true)
                    gaussian_drift_resources = infer_flavor.gaussian_drift_res # reset resources after smt jump
                else
                  jumpsucc!(tracker, "rejected")
                end

            end
            jump_count -= 1

        end

        rejects = 0
        if (infer_flavor.warm_jump || infer_flavor.warm_start) && gaussian_drift_resources > 0
            # perform gaussian drifts post smt trace

            (tr, a) = mh(tr, mean_drift_proposal, (); observations=observations)
            update!(tracker, get_score(tr), true, false)
            accepted!(tracker, a)
            rejects += (!a ? 1 : 0)

            # (tr, a) = mh(tr, sigma_drift_proposal, ())
            # update!(tracker, get_score(tr), true, false)
            # accepted!(tracker, a)

            (tr, a) = mh(tr, select(:sigma); observations=observations)
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)
            rejects += (!a ? 1 : 0)

            gaussian_drift_resources -= 1

        else 
            # perform standard inference (mh, block resim mh, etc)

            #update normal params
            (tr, a) = mh(tr, select(:mu); observations=observations)
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)
            rejects += (!a ? 1 : 0)
 
            
            (tr, a) = mh(tr, select(:sigma); observations=observations)
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)
            rejects += (!a ? 1 : 0)
        end
    end

  

    #Cap scores at 2000 mh steps
    trim!(tracker, mh_steps_cap)

    return tracker
end


# n = 10
# generate_unrolled_loops(make_synth_data(n))

# ys = make_synth_data(n)
# observations = make_constraints(ys)

# print("\033c") # clean terminal log
# Random.seed!()

# # Compare 

# scoring_warm = inference(Inference_type(true, false, 50))
# scoring_rand = inference(Inference_type(false, false, 50))

# plot(scoring_warm; label = "Warm start", marker = :circle, linewidth = 2)
# plot!(scoring_rand; label = "Rand start", marker = :diamond, linewidth = 2)

# savefig(results_dir * "score_comparison.png")

@gen function mean_drift_proposal(current_trace)
    mu ~ normal(current_trace[:mu], 1)
end

# @gen function sigma_drift_proposal(current_trace)
#     sigma ~ normal(current_trace[:sigma], 0.1)
# end

