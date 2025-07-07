#Include working dir config file first
include(joinpath("..", "..", "julie", "config.jl"))
set_working_dir(@__DIR__)

#Plotting
using Plots
using Statistics

include("gaussian-inference.jl")

include(joinpath("..", "..", "julie", "benchmarking.jl"))


# Data and observations
(data, observations) = get_data_and_observations()

# warmstart = Inference_flavor(warm_start=true)
# tracker = inference(data, warmstart)
# println("initi: $(trackers[1])")
# INIT SC5RE: -53.76211833783415

# BENCHMARKS
#Compare warm-start to warm-jump 
#  compare_warm_start_to_random_start(inference, data)

#Compare warm start with and without gaussian drifts 
# compare_warm_start_with_drifts(inference, data)

#Visualise warm-jumps
compare_jumps_to_no_jumps(inference, data)