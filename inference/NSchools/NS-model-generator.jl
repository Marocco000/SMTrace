import Random
n = 100 # num of scools 
numxstates = 4#8
numxdistrictsxperxstate = 2#5
numxtypes = 5

scalexstate = 1.0
scalexdistrict = 1.0
scalextype = 1.0

Random.seed!(1)

state = Vector{Int64}(undef, n)
district = Vector{Int64}(undef, n)
type = Vector{Int64}(undef, n)
for i =1:n
    # Assume we are given state[i], district[i], type[i]
    state[i] = rand(1:numxstates)
    district[i] = rand(1:numxdistrictsxperxstate)
    type[i] =  rand(1:numxtypes)
end



function generatexppmodexcode(n, 
    numxstates, numxdistrictsxperxstate, numxtypes, 
    state, district, type,
    scalexstate, scalexdistrict, scalextype)

    # println("scalexstate = $scalexstate")
    # println("scalexdistrict = $scalexdistrict")
    # println("scalextype = $scalextype")
    # println()

    println("sigmaxstate ~ uniform(0.1, $(scalexstate))")
    println("sigmaxdistrict ~ uniform(0.1, $(scalexdistrict))")
    println("sigmaxtype ~ uniform(0.1, $(scalextype))")
    println()

    println("beta_baseline = Normal(1, 50)")
    println()


    for s = 1:numxstates
        println("betaxstate$s ~ normal(0, sigmaxstate)")    
    end

    println()
    println()

    for s = 1:numxstates
        for d = 1:numxdistrictsxperxstate
            println("betaxdistrict$(s)To$d ~ normal(0, sigmaxdistrict)")
        end
    end

    println()
    println()

    for t = 1:numxtypes
        println("betaxtype$t ~ normal(0, sigmaxtype)")
    end

    println()
    println()


    for i = 1:n
        println("yhat$i = betaxbaseline + betaxstate$(state[i]) 
        + betaxdistrict$(state[i])To$(district[i])
        + betaxtype$(type[i])")
        println("sigma$i ~ uniform(0.5, 1.5)")
        println("y$i ~ normal(yhat$i, sigma$i)")
        println()
   
    end
end

generatexppmodexcode(n, 
    numxstates, numxdistrictsxperxstate, numxtypes, 
    state, district, type,
    scalexstate, scalexdistrict, scalextype)

Random.seed!()
