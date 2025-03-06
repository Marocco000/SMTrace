println("noise ~ normal(0,1)")
println("intercept ~ normal(0,2)")
println("slope ~ normal(0,2)")
println()
xs = collect(range(-5, stop=5, length=10))
for i = 1:10
    println("x$i = $(xs[i])")
end

println()
# Linear regression unrolled for loop
for i = 1:10
    println("mean$i = x$i * slope + intercept")
    println("y$i ~ normal(mean$i, noise)")
    
    # (mu, std) = (xs[i] * slope + intercept, noise)
    # push!(ys, {:data => i => :y} ~ normal(mu, std))
end

# Linear regression with outliers unrolled for loop