using Gen

#Replace template with the model name
include("template-model.jl")
ppfile = "template/template-model.jl"



function make_synthetic_data()
    #to implement
end

function make_constraints()::Gen.ChoiceMap
    constraints = Gen.choicemap()
    
    #to implement

    constraints
end



function get_data_and_observations()

    # data = make_synthetic_data()
    # observations = make_constraints()

    # return (data, observations)
end

function inference(data, infer_flavor::Inference_flavor, iter=10)
    # to implement
    scores = []# trace scores for plot 
    jumps = []# true if the sample used an SMT trace

    # Initial guess
    if infer_flavor.warm_start
        init_trace = ransac_smt(observations, ppfile, false)
        
        gaussian_drift_resources = infer_flavor.gaussian_drift_res # set resources after smt start
        log_jump(jumps, true)
    else
        (init_trace, _) = generate(ppmodel, (),  observations)

        gaussian_drift_resources = 0
        log_jump(jumps, false)
    end

    tr = deepcopy(init_trace)
    log_score(scores, tr)
    
    # Sample iterations
    for j = 1:iter
        if infer_flavor.warm_jump
            # perform warm_jump if possible

            log_jump(jumps, true)
            gaussian_drift_resources = infer_flavor.gaussian_drift_res # reset resources after smt jump
        elseif infer_flavor.warm_jump && gaussian_drift_resources > 0
            # perform gaussian drifts post smt trace
            gaussian_drift_resources -= 1
        else
            # perform standard inference (mh, block resim mh, etc)
        end
    end

    return (scores, jumps)

end


"""Does gaussian drift over a block of the latent variables"""
@gen function gaussian_drift_proposal_block1(current_trace)

    #to implement for latent variables in block, adjust gaussian noise
    # latent_var_1 ~ normal(current_trace[:latent_var_1], 0.01)

end


