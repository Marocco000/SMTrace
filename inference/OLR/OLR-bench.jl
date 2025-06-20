#Include working dir config file first
include(joinpath("..", "..", "julie", "config.jl"))
set_working_dir(@__DIR__)

#create results structure: results/parsing_results and res/figures
#TODO for each RUN 

include("OLR-inference.jl")

include(joinpath("..", "..", "julie", "benchmarking.jl"))#
# include(joinpath("..", "..", "julie", "inference-smt.jl"))

# using .FlavorConfig

#Plotting
using Plots
using Statistics




(data, observations) = get_data_and_observations()
xs = data[1] # TODO unpack this properly

# print("\033c") # clean terminal log

# Perform benchmarks
warm_start = Inference_flavor(warm_start = true)
inference(data, warm_start)


#Compare warm-start to warm-jump 
# compare_warm_start_to_random_start(inference, data)

#Gaussian drift window post warm start
compare_warm_start_with_drifts(inference, data)


#Visualise warm-jumps
# compare_jumps_to_no_jumps(inference, data)

#Test block jump ios working because getting no model 
# with_jumps = Inference_flavor(warm_jump=true)
# inference(data, with_jumps, 10)

# TODO: compare inferences that have the closest start
# scoring_warm = inference_over_LR_with_outliers(xs,  Inference_type(warm_start=true))
# scoring_rand = inference_over_LR_with_outliers(xs,  Inference_type())

# plot(scoring_warm; label = "Warm start", marker = :circle, linewidth = 2)
# plot!(scoring_rand; label = "Rand start", marker = :diamond, linewidth = 2)

# savefig(results_dir * "score_comparison.png")