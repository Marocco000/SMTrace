#Plotting
using Plots
using Statistics

include("template-inference.jl")

include(joinpath("..", "..", "julie", "benchmarking.jl"))



# Data and observations
(data, observations) = get_data_and_observations()

# benchmarks
# compare_warm_start_to_random_start(inference, data)