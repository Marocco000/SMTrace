

println()
# Linear regression unrolled for loop
for i = 1:20
    println("outlier$i ~ bernoulli(proboutlier)")
    println("if outlier$i == 0")
    println("\tmean$i = x$i * slope + intercept")
    println("\ty$i ~ normal(mean$i, 1)")

    println("else")
    println("\ty$i ~ normal(0, 10)")
    println("end")
    
    # (mu, std) = (xs[i] * slope + intercept, noise)
    # push!(ys, {:data => i => :y} ~ normal(mu, std))
end

# Linear regression with outliers unrolled for loop
