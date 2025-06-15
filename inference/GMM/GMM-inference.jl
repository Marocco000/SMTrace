using Gen

include("GMM-model.jl")
ppfile = "GMM/GMM-model.jl"

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
    #to implement
    K = 3 # number of cluster centers

    Random.seed!(1)
    
    #Cluster means
    means = []
    # for i=1:K
    #     push!(means, ) # sample from uniform
    # end
    means = [5, 7, 18]

    zs = []
    ys = []
    for i = 1:n
        z = rand(1:K)
        push!(zs, z)
        y = means[z] + randn() * 0.1
        push!(ys, y) 
    end

    ys
end

function make_constraints(ys)::Gen.ChoiceMap
    constraints = Gen.choicemap()
    
    #to implement
    for i=1:length(ys)
        yi = QuoteNode(Symbol(:y, i))
        constraints[eval(yi)] = ys[i]
    end

    constraints
end



function get_data_and_observations(n)

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
        #init_trace = ransac_smt(observations, ppfile, false)
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
    
    mh_steps_cap = 2000

    # Sample iterations
    while tracker.mh_steps <= mh_steps_cap
        if infer_flavor.warm_jump
            # perform warm_jump if possible
            fixed_selection_options = [select(:mean1, :mean2), select(:mean3, :mean2), select(:mean1, :mean3)]
            fixed_selection = fixed_selection_options[Int(j/2)]
            try_tr = block_smt_with_fixed_selection(fixed_selection, tr, observations, ppfile)
            if try_tr === nothing
                iter += 1
            else 
                tr = try_tr
                println("Pre-jump score $(get_score(tr))")
                println("JUMP SCORE: $(get_score(tr))")


                update!(tracker, get_score(tr), false, true)        
                gaussian_drift_resources = infer_flavor.gaussian_drift_res # reset resources after smt jump
            end
            # Options: try to improve only on e of the means and the allocations, add less resources

        elseif (infer_flavor.warm_jump || infer_flavor.warm_start) && gaussian_drift_resources > 0
            # perform gaussian drifts post smt trace

            #Gaussian drift over each means #TODO can i de-duplicate?
            (tr, a) = mh(tr, mean1_drift_proposal, ())
            update!(tracker, get_score(tr), true, false)
            accepted!(tracker, a)

            (tr, a) = mh(tr, mean2_drift_proposal, ())
            update!(tracker, get_score(tr), true, false)
            accepted!(tracker, a)

            (tr, a) = mh(tr, mean3_drift_proposal, ())
            update!(tracker, get_score(tr), true, false)
            accepted!(tracker, a)

            # TODO: option Throw zi -> zi-1 or zi+1? assume u could put point in neighbouring piles

            gaussian_drift_resources -= 3

        else 
            # perform standard inference (mh, block resim mh, etc)

            #block1: update means
            (tr, a) = mh(tr, select(:mean1))
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)
            
            (tr, a) = mh(tr, select(:mean2))
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)

            (tr, a) = mh(tr, select(:mean3))
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)


            # block2: update cluster assignments
            for i=1:data["n"]
                zi = QuoteNode(Symbol(:z, i))
                selection = select(eval(zi))
                (tr, a) = mh(tr, selection)
                update!(tracker, get_score(tr), false, false)
                accepted!(tracker, a)
            end
            
        end
    end


    #Cap scores at 2000 mh steps
    trim!(tracker, 2000)

    return tracker

end

# Gaussian drifts:
@gen function mean1_drift_proposal(current_trace)
    mean1 ~ normal(current_trace[:mean1], 0.01)
end
@gen function mean2_drift_proposal(current_trace)
    mean2 ~ normal(current_trace[:mean2], 0.01)
end
@gen function mean3_drift_proposal(current_trace)
    mean3 ~ normal(current_trace[:mean3], 0.01)
end



