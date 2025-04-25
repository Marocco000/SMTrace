using Gen

include("template-model.jl")
ppfile = "template/template-model.jl"



function make_synthetic_data()
    #to implement
end

function make_constraints()::Gen.ChoiceMap
    constraints = Gen.choicemap()
    
    #to implement

    constriants
end



function get_data_and_observations()

    # data = make_synthetic_data()
    # observations = make_constraints()

    # return (data, observation)
end

function inference(data, infer_flavor::Inference_flavor, iter=10)
# to implement

end


"""Does gaussian drift over a block of the latent variables"""
@gen function gaussian_drift_porposal_block1(current_trace)

    #to implement for latent variables in block, adjust gaussian noise
    # latent_var_1 ~ normal(current_trace[:latent_var_1], 0.01)

end


