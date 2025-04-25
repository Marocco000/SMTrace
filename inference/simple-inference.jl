using Gen 


ppfile = "simple-model.jl"
include(ppfile) # the ppmodel TODO pass the name of the ppmodel function instead of always naming it ppmodel


path = joinpath("..", "teste.jl")
include(path) 


function inference_over_simple_model()
    print("\033c") # clean terminal log
    # Warm start: Get SMT trace as initial state 
    observations = Gen.choicemap()
    init_trace = ransac_smt(observations, ppfile, false) #TODO (observations are not done here, for now they are hacked in as constants in the ppmodel)
    
    #Random start
    # (init_trace, _) = generate(ppmodel, (),  observations)

    println("Initial score: $(get_score(init_trace))")


    tr = init_trace #TODO abs trash as it is not considering modifying the outlier/outlier prob
end


inference_over_simple_model()