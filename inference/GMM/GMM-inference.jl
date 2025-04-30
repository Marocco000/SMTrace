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



function get_data_and_observations()

    data = make_synthetic_data(100)
    observations = make_constraints(data)
    
    data = []

    return (data, observations)
end

function inference(data, infer_flavor::Inference_flavor, iter=50)
    # to implement

    scores = []# trace scores for plot 
    jumps = []# true if the sample used an SMT trace
    drifts = []

    # Initial guess
    if infer_flavor.warm_start
        # init_trace = ransac_smt(observations, ppfile, false)
        init_trace = reuse_warm_start()
        
        gaussian_drift_resources = infer_flavor.gaussian_drift_res # set resources after smt start
        log_jump(jumps, true)
    else
        (init_trace, _) = generate(ppmodel, (),  observations)

        gaussian_drift_resources = 0
        log_jump(jumps, false)
    end

    tr = deepcopy(init_trace)
    log_score(scores, tr)
    log_drift(drifts, false)
    
    # Sample iterations
    for j = 1:iter
        if infer_flavor.warm_jump && j % 2 == 0 && j<=6
            # perform warm_jump if possible
            fixed_selection_options = [select(:mean1, :mean2), select(:mean3, :mean2), select(:mean1, :mean3)]
            fixed_selection = fixed_selection_options[Int(j/2)]
            try_tr = block_smt_with_fixed_selection(fixed_selection, tr, observations, ppfile)
            if try_tr === nothing
                iter += 1
            else 
                log_score(scores, tr)
                log_jump(jumps, true)
                log_drift(drifts, false)
                gaussian_drift_resources = infer_flavor.gaussian_drift_res # reset resources after smt jump
            end
            # Options: try to improve only on e of the means and the allocations, add less resources

        elseif (infer_flavor.warm_jump || infer_flavor.warm_start) && gaussian_drift_resources > 0
            # perform gaussian drifts post smt trace

            #Gaussian drift over each means #TODO can i de-duplicate?
            (tr, _) = mh(tr, mean1_drift_proposal, ())
            log_score(scores, tr)
            log_jump(jumps, false)
            log_drift(drifts, true)

            (tr, _) = mh(tr, mean2_drift_proposal, ())
            log_score(scores, tr)
            log_jump(jumps, false)
            log_drift(drifts, true)

            (tr, _) = mh(tr, mean3_drift_proposal, ())
            log_score(scores, tr)
            log_jump(jumps, false)
            log_drift(drifts, true)
            # TODO: option Throw zi -> zi-1 or zi+1? assume u could put point in neighbouring piles

            gaussian_drift_resources -= 1

        else 
            # perform standard inference (mh, block resim mh, etc)

            #block1: update means
            # (tr, ) = mh(tr, select(:mean1, :mean2, :mean3))
            (tr, ) = mh(tr, select(:mean1))
            (tr, ) = mh(tr, select(:mean2))
            (tr, ) = mh(tr, select(:mean3))
            
            log_score(scores, tr)
            log_jump(jumps, false)
            log_drift(drifts, false)

            #block2: update cluster assignments
            for i=1:100
                zi = QuoteNode(Symbol(:z, i))
                selection = select(eval(zi))
                (tr, _) = mh(tr, selection)

                log_score(scores, tr)
                log_jump(jumps, false)
                log_drift(drifts, false)
            end
            
        end
    end

    return (scores, jumps, drifts)

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



