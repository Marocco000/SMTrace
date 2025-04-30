n = 100

for i = 1:n
    println("z$i ~ categorical([1/3, 1/3, 1/3])")
    # println("z$i ~ categorical(v)")
end

println()

for i in 1:n
    println("    if z$i == 1")
    println("        y$i ~ normal(mean1, 0.1)")
    println("    elseif z$i == 2")
    println("        y$i ~ normal(mean2, 0.1)")
    println("    else")
    println("        y$i ~ normal(mean3, 0.1)")
    println("    end")
    println()
end