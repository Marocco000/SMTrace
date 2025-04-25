@gen function ppmodel()
    # source: https://github.com/StatisticalRethinkingJulia/MCMCBenchmarkSuite.jl/tree/master
    
    # Original
    # mu ~ normal(0, 1)
    # sigma ~ cauchy(0,5)
    # y ~ normal(mu,sigma)

    # Modified since Cauchy distribution is not yet supported 
    mu ~ normal(0, 1)
    sigma ~ normal(10,1) # TODO redo to something more similar to cauchy 
    
    # for i= 1:N
    #     y ~ normal(mu,sigma)
    # end
    y1 ~ normal(mu, sigma)
    y2 ~ normal(mu, sigma)
    y3 ~ normal(mu, sigma)
    y4 ~ normal(mu, sigma)
    y5 ~ normal(mu, sigma)
    y6 ~ normal(mu, sigma)
    y7 ~ normal(mu, sigma)
    y8 ~ normal(mu, sigma)
    y9 ~ normal(mu, sigma)
    y10 ~ normal(mu, sigma)
    # y11 ~ normal(mu, sigma)
    # y12 ~ normal(mu, sigma)
    # y13 ~ normal(mu, sigma)
    # y14 ~ normal(mu, sigma)
    # y15 ~ normal(mu, sigma)
    # y16 ~ normal(mu, sigma)
    # y17 ~ normal(mu, sigma)
    # y18 ~ normal(mu, sigma)
    # y19 ~ normal(mu, sigma)
    # y20 ~ normal(mu, sigma)
end