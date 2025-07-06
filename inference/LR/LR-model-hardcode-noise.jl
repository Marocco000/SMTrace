@gen function ppmodel()
    # 0.5 = 0.5 # TODO fix python to accept normal variance to be a const variable
    #TODO i rememebr SMT breaks for variance not fixed, check if its still the case. Maybe fix randomly and solve for the rest of variables
    intercept ~ normal(0,2)
    slope ~ normal(0,2)

    x1 = -5.0
    x2 = -4.473684210526316
    x3 = -3.9473684210526314
    x4 = -3.4210526315789473
    x5 = -2.8947368421052633
    x6 = -2.3684210526315788
    x7 = -1.8421052631578947
    x8 = -1.3157894736842106
    x9 = -0.7894736842105263
    x10 = -0.2631578947368421
    x11 = 0.2631578947368421
    x12 = 0.7894736842105263
    x13 = 1.3157894736842106
    x14 = 1.8421052631578947
    x15 = 2.3684210526315788
    x16 = 2.8947368421052633
    x17 = 3.4210526315789473
    x18 = 3.9473684210526314
    x19 = 4.473684210526316
    x20 = 5.0
    
    
    mean1 = x1 * slope + intercept
    y1 ~ normal(mean1, 0.5)
    
    mean2 = x2 * slope + intercept
    y2 ~ normal(mean2, 0.5)
    
    mean3 = x3 * slope + intercept
    y3 ~ normal(mean3, 0.5)
    
    mean4 = x4 * slope + intercept
    y4 ~ normal(mean4, 0.5)
    
    mean5 = x5 * slope + intercept
    y5 ~ normal(mean5, 0.5)
    
    mean6 = x6 * slope + intercept
    y6 ~ normal(mean6, 0.5)
    
    mean7 = x7 * slope + intercept
    y7 ~ normal(mean7, 0.5)
    
    mean8 = x8 * slope + intercept
    y8 ~ normal(mean8, 0.5)
    
    mean9 = x9 * slope + intercept
    y9 ~ normal(mean9, 0.5)
    
    mean10 = x10 * slope + intercept
    y10 ~ normal(mean10, 0.5)
    
    mean11 = x11 * slope + intercept
    y11 ~ normal(mean11, 0.5)
    
    mean12 = x12 * slope + intercept
    y12 ~ normal(mean12, 0.5)
    
    mean13 = x13 * slope + intercept
    y13 ~ normal(mean13, 0.5)
    
    mean14 = x14 * slope + intercept
    y14 ~ normal(mean14, 0.5)
    
    mean15 = x15 * slope + intercept
    y15 ~ normal(mean15, 0.5)
    
    mean16 = x16 * slope + intercept
    y16 ~ normal(mean16, 0.5)
    
    mean17 = x17 * slope + intercept
    y17 ~ normal(mean17, 0.5)
    
    mean18 = x18 * slope + intercept
    y18 ~ normal(mean18, 0.5)
    
    mean19 = x19 * slope + intercept
    y19 ~ normal(mean19, 0.5)
    
    mean20 = x20 * slope + intercept
    y20 ~ normal(mean20, 0.5)
end
