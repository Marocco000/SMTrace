import Random, Logging
using Gen, Plots

# Disable logging, because @animate is verbose otherwise
Logging.disable_logging(Logging.Info);


@gen function regression_with_outliers(xs::Vector{<:Real})
    # First, generate some parameters of the model. We make these
    # random choices, because later, we will want to infer them
    # from data. The distributions we use here express our assumptions
    # about the parameters: we think the slope and intercept won't be
    # too far from 0; that the noise is relatively small; and that
    # the proportion of the dataset that don't fit a linear relationship
    # (outliers) could be anything between 0 and 1.
    slope ~ normal(0, 2)
    intercept ~ normal(0, 2)
    noise ~ gamma(1, 1)
    prob_outlier ~ uniform(0, 1)
    
    # Next, we generate the actual y coordinates.
    n = length(xs)
    ys = Float64[]
    
    for i = 1:n
        # Decide whether this point is an outlier, and set
        # mean and standard deviation accordingly
        if ({:data => i => :is_outlier} ~ bernoulli(prob_outlier))
            (mu, std) = (0., 10.)
        else
            (mu, std) = (xs[i] * slope + intercept, noise)
        end
        # Sample a y value for this point
        push!(ys, {:data => i => :y} ~ normal(mu, std))
    end
    ys
end;


include("regression_viz.jl")
xs     = collect(range(-5, stop=5, length=10))
traces = [Gen.simulate(regression_with_outliers, (xs,)) for i in 1:9];
# Plots.plot([visualize_trace(t) for t in traces]...)
Plots.plot(visualize_trace(traces[1]))

# function make_synthetic_dataset(n)
#     Random.seed!(1)
#     prob_outlier = 0.2
#     true_inlier_noise = 0.5
#     true_outlier_noise = 5.0
#     true_slope = -1
#     true_intercept = 2
#     xs = collect(range(-5, stop=5, length=n))
#     ys = Float64[]
#     for (i, x) in enumerate(xs)
#         if rand() < prob_outlier
#             y = randn() * true_outlier_noise
#         else
#             y = true_slope * x + true_intercept + randn() * true_inlier_noise
#         end
#         push!(ys, y)
#     end
#     (xs, ys)
# end
    
# # println("hihihihihi")
# (xs, ys) = make_synthetic_dataset(10);
# println(xs)
# println(ys)