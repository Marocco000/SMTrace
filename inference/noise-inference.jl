# Linear regression model with outliers 


path = joinpath("..", "teste.jl")
include(path) 

#Plotting
using Plots
path = joinpath("..", "regression_viz.jl")
include(path)

## DATA

function make_constraints(ys::Vector{Float64})
    constraints = Gen.choicemap()
 
    constraints
end;



function inference_normal_with_noise(xs)
    print("\033c") # clean terminal log
    # Warm start: Get SMT trace as initial state 
    init_trace = ransac_smt(observations, false) #TODO (observations are not done here, for now they are hacked in as constants in the ppmodel)
    
    println("Initial score: $(get_score(init_trace))")
    
end


observations = make_constraints(ys)

inference_over_LR_with_outliers(xs)

