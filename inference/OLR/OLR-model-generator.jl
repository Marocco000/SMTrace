function make_synthetic_dataset1(n)
    Random.seed!(1)
    prob_outlier = 0.2
    true_inlier_noise = 0.5
    true_outlier_noise = 5.0
    true_slope = -1
    true_intercept = 2
    xs = collect(range(-5, stop=5, length=n))
    ys = Float64[]
    for (i, x) in enumerate(xs)
        if rand() < prob_outlier
            y = randn() * true_outlier_noise
        else
            y = true_slope * x + true_intercept + randn() * true_inlier_noise
        end
        push!(ys, y)
    end
    (xs, ys)
end
n = 100 # 20
(xs, ys) = make_synthetic_dataset1(n);
# Plots.scatter(xs, ys, color="black", xlabel="X", ylabel="Y",
#               label=nothing, title="Observations - regular data and outliers")
for i = 1:n
    println("x$i = $(xs[i])")
end

for i in 1:100
    println("outlier$i ~ bernoulli(proboutlier)")
    println("if outlier$i == 0")
    println("    mean$i = x$i * slope + intercept")
    println("    y$i ~ normal(mean$i, noise)")
    println("else")
    println("    y$i ~ normal(0, 10)")
    println("end\n")
end