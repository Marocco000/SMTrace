include("LR-inference.jl")

# println("noise ~ normal(0,1)")
println("intercept ~ normal(0,2)")
println("slope ~ normal(0,2)")
println()

n = 100
(xs, ys) = make_synthetic_dataset(n);
# # Plots.scatter(xs, ys, color="black", xlabel="X", ylabel="Y",
# #               label=nothing, title="Observations - regular data and outliers")
# for i = 1:20
#     println("x$i = $(xs[i])")
# end
#
# for i = 1:20
#     println("y$i = $(ys[i])")
# end

for i = 1:n
    println("x$i = $(xs[i])")
end

println()
println()


# Linear regression unrolled for loop
for i = 1:n
    println("mean$i = x$i * slope + intercept")
    # println("y$i ~ normal(mean$i, noise)")
    println("y$i ~ normal(mean$i, 0.5)")
    println()
    # (mu, std) = (xs[i] * slope + intercept, noise)
    # push!(ys, {:data => i => :y} ~ normal(mu, std))
end

# Linear regression with outliers unrolled for loop