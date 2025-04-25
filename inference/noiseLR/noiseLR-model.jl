@gen function pmodel()
    noise ~ gamma(1, 1)
    intercept ~ normal(0,2)
    slope ~ normal(0,2)

    x1 = -5.0
    x2 = -3.888888888888889
    x3 = -2.7777777777777777
    x4 = -1.6666666666666667
    x5 = -0.5555555555555556
    x6 = 0.5555555555555556
    x7 = 1.6666666666666667
    x8 = 2.7777777777777777
    x9 = 3.888888888888889
    x10 = 5.0

    #Obs #TODO when the (y=> i relation is solved for naming this should go in a make_constraint function)
    y1 = 2.6573837689159814
    y2 = 7.117384555880536
    y3 = 4.91155998709222
    y4 = 3.253656270707018
    y5 = 2.3909886326273533
    y6 = 2.0355657961445237
    y7 = 0.3320542430561795
    y8 = -0.5117555604683294
    y9 = 0.10122966946595927
    y10 = -2.9538548030256058

    mean1 = x1 * slope + intercept
    y1 ~ normal(mean1, noise)
    mean2 = x2 * slope + intercept
    y2 ~ normal(mean2, noise)
    mean3 = x3 * slope + intercept
    y3 ~ normal(mean3, noise)
    mean4 = x4 * slope + intercept
    y4 ~ normal(mean4, noise)
    mean5 = x5 * slope + intercept
    y5 ~ normal(mean5, noise)
    mean6 = x6 * slope + intercept
    y6 ~ normal(mean6, noise)
    mean7 = x7 * slope + intercept
    y7 ~ normal(mean7, noise)
    mean8 = x8 * slope + intercept
    y8 ~ normal(mean8, noise)
    mean9 = x9 * slope + intercept
    y9 ~ normal(mean9, noise)
    mean10 = x10 * slope + intercept
    y10 ~ normal(mean10, noise)
end
