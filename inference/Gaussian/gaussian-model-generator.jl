

# Linear regression with outliers unrolled for loop
n = 100
function generate_unrolled_loops(n)
    #generates the unroleed loops assignmentnt for the ppmodel until loops are dealt with in parsing
    # for i = 1:length(ys)
    #     println("y$i = $(ys[i])")
    # end

    for i = 1:n
        println("\ty$i ~ normal(mu, sigma)")
    end
end

generate_unrolled_loops(n)