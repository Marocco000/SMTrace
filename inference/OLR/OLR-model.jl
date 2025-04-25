@gen function ppmodel()

        noise ~ uniform(0.1, 1)
        # noise ~ normal(5, 1) # TODO probllem with getting  ^0 = [else -> 0]] in model !!
        # noise ~ gamma(1, 1) #TODO 0^
        # noise ~ gamma(1, 4)
        # noise ~ beta(1, 1)
        # noise ~ poisson(3)
        intercept ~ normal(0,2)
        slope ~ normal(0,2)
        proboutlier ~ uniform(0, 1)

        # noise = 5

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

        outlier1 ~ bernoulli(proboutlier)
        if outlier1 == 0
                mean1 = x1 * slope + intercept
                y1 ~ normal(mean1, noise)
        else
                y1 ~ normal(0, 10)
        end
        outlier2 ~ bernoulli(proboutlier)
        if outlier2 == 0
                mean2 = x2 * slope + intercept
                y2 ~ normal(mean2, noise)
        else
                y2 ~ normal(0, 10)
        end
        outlier3 ~ bernoulli(proboutlier)
        if outlier3 == 0
                mean3 = x3 * slope + intercept
                y3 ~ normal(mean3, noise)
        else
                y3 ~ normal(0, 10)
        end
        outlier4 ~ bernoulli(proboutlier)
        if outlier4 == 0
                mean4 = x4 * slope + intercept
                y4 ~ normal(mean4, noise)
        else
                y4 ~ normal(0, 10)
        end
        outlier5 ~ bernoulli(proboutlier)
        if outlier5 == 0
                mean5 = x5 * slope + intercept
                y5 ~ normal(mean5, noise)
        else
                y5 ~ normal(0, 10)
        end
        outlier6 ~ bernoulli(proboutlier)
        if outlier6 == 0
                mean6 = x6 * slope + intercept
                y6 ~ normal(mean6, noise)
        else
                y6 ~ normal(0, 10)
        end
        outlier7 ~ bernoulli(proboutlier)
        if outlier7 == 0
                mean7 = x7 * slope + intercept
                y7 ~ normal(mean7, noise)
        else
                y7 ~ normal(0, 10)
        end
        outlier8 ~ bernoulli(proboutlier)
        if outlier8 == 0
                mean8 = x8 * slope + intercept
                y8 ~ normal(mean8, noise)
        else
                y8 ~ normal(0, 10)
        end
        outlier9 ~ bernoulli(proboutlier)
        if outlier9 == 0
                mean9 = x9 * slope + intercept
                y9 ~ normal(mean9, noise)
        else
                y9 ~ normal(0, 10)
        end
        outlier10 ~ bernoulli(proboutlier)
        if outlier10 == 0
                mean10 = x10 * slope + intercept
                y10 ~ normal(mean10, noise)
        else
                y10 ~ normal(0, 10)
        end
        outlier11 ~ bernoulli(proboutlier)
        if outlier11 == 0
                mean11 = x11 * slope + intercept
                y11 ~ normal(mean11, noise)
        else
                y11 ~ normal(0, 10)
        end
        outlier12 ~ bernoulli(proboutlier)
        if outlier12 == 0
                mean12 = x12 * slope + intercept
                y12 ~ normal(mean12, noise)
        else
                y12 ~ normal(0, 10)
        end
        outlier13 ~ bernoulli(proboutlier)
        if outlier13 == 0
                mean13 = x13 * slope + intercept
                y13 ~ normal(mean13, noise)
        else
                y13 ~ normal(0, 10)
        end
        outlier14 ~ bernoulli(proboutlier)
        if outlier14 == 0
                mean14 = x14 * slope + intercept
                y14 ~ normal(mean14, noise)
        else
                y14 ~ normal(0, 10)
        end
        outlier15 ~ bernoulli(proboutlier)
        if outlier15 == 0
                mean15 = x15 * slope + intercept
                y15 ~ normal(mean15, noise)
        else
                y15 ~ normal(0, 10)
        end
        outlier16 ~ bernoulli(proboutlier)
        if outlier16 == 0
                mean16 = x16 * slope + intercept
                y16 ~ normal(mean16, noise)
        else
                y16 ~ normal(0, 10)
        end
        outlier17 ~ bernoulli(proboutlier)
        if outlier17 == 0
                mean17 = x17 * slope + intercept
                y17 ~ normal(mean17, noise)
        else
                y17 ~ normal(0, 10)
        end
        outlier18 ~ bernoulli(proboutlier)
        if outlier18 == 0
                mean18 = x18 * slope + intercept
                y18 ~ normal(mean18, noise)
        else
                y18 ~ normal(0, 10)
        end
        outlier19 ~ bernoulli(proboutlier)
        if outlier19 == 0
                mean19 = x19 * slope + intercept
                y19 ~ normal(mean19, noise)
        else
                y19 ~ normal(0, 10)
        end
        outlier20 ~ bernoulli(proboutlier)
        if outlier20 == 0
                mean20 = x20 * slope + intercept
                y20 ~ normal(mean20, noise)
        else
                y20 ~ normal(0, 10)
        end
    end

