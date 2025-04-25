# @gen function ppmodel()

#     noise ~ poisson(3)
#     a ~ uniform(1, noise)

# end
@gen function ppmodel()

    # TODO HAS PROBLEM WITH DIVISION TO ZERO 
    noise ~ uniform(0, 1)
    # noise = 3.99999999
    x ~ uniform(noise, 4)

end