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


        # 100 PTS
        # x1 = -5.0
        # x2 = -4.898989898989899
        # x3 = -4.797979797979798
        # x4 = -4.696969696969697
        # x5 = -4.595959595959596
        # x6 = -4.494949494949495
        # x7 = -4.393939393939394
        # x8 = -4.292929292929293
        # x9 = -4.191919191919192
        # x10 = -4.090909090909091
        # x11 = -3.98989898989899
        # x12 = -3.888888888888889
        # x13 = -3.787878787878788
        # x14 = -3.686868686868687
        # x15 = -3.585858585858586
        # x16 = -3.484848484848485
        # x17 = -3.3838383838383836
        # x18 = -3.282828282828283
        # x19 = -3.1818181818181817
        # x20 = -3.080808080808081
        # x21 = -2.9797979797979797
        # x22 = -2.878787878787879
        # x23 = -2.7777777777777777
        # x24 = -2.676767676767677
        # x25 = -2.5757575757575757
        # x26 = -2.474747474747475
        # x27 = -2.3737373737373737
        # x28 = -2.272727272727273
        # x29 = -2.1717171717171717
        # x30 = -2.0707070707070705
        # x31 = -1.9696969696969697
        # x32 = -1.8686868686868687
        # x33 = -1.7676767676767677
        # x34 = -1.6666666666666667
        # x35 = -1.5656565656565657
        # x36 = -1.4646464646464648
        # x37 = -1.3636363636363635
        # x38 = -1.2626262626262625
        # x39 = -1.1616161616161615
        # x40 = -1.0606060606060606
        # x41 = -0.9595959595959596
        # x42 = -0.8585858585858586
        # x43 = -0.7575757575757576
        # x44 = -0.6565656565656566
        # x45 = -0.5555555555555556
        # x46 = -0.45454545454545453
        # x47 = -0.35353535353535354
        # x48 = -0.25252525252525254
        # x49 = -0.15151515151515152
        # x50 = -0.050505050505050504
        # x51 = 0.050505050505050504
        # x52 = 0.15151515151515152
        # x53 = 0.25252525252525254
        # x54 = 0.35353535353535354
        # x55 = 0.45454545454545453
        # x56 = 0.5555555555555556
        # x57 = 0.6565656565656566
        # x58 = 0.7575757575757576
        # x59 = 0.8585858585858586
        # x60 = 0.9595959595959596
        # x61 = 1.0606060606060606
        # x62 = 1.1616161616161615
        # x63 = 1.2626262626262625
        # x64 = 1.3636363636363635
        # x65 = 1.4646464646464648
        # x66 = 1.5656565656565657
        # x67 = 1.6666666666666667
        # x68 = 1.7676767676767677
        # x69 = 1.8686868686868687
        # x70 = 1.9696969696969697
        # x71 = 2.0707070707070705
        # x72 = 2.1717171717171717
        # x73 = 2.272727272727273
        # x74 = 2.3737373737373737
        # x75 = 2.474747474747475
        # x76 = 2.5757575757575757
        # x77 = 2.676767676767677
        # x78 = 2.7777777777777777
        # x79 = 2.878787878787879
        # x80 = 2.9797979797979797
        # x81 = 3.080808080808081
        # x82 = 3.1818181818181817
        # x83 = 3.282828282828283
        # x84 = 3.3838383838383836
        # x85 = 3.484848484848485
        # x86 = 3.585858585858586
        # x87 = 3.686868686868687
        # x88 = 3.787878787878788
        # x89 = 3.888888888888889
        # x90 = 3.98989898989899
        # x91 = 4.090909090909091
        # x92 = 4.191919191919192
        # x93 = 4.292929292929293
        # x94 = 4.393939393939394
        # x95 = 4.494949494949495
        # x96 = 4.595959595959596
        # x97 = 4.696969696969697
        # x98 = 4.797979797979798
        # x99 = 4.898989898989899
        # x100 = 5.0

        
        # outlier1 ~ bernoulli(proboutlier)
        # if outlier1 == 0
        # mean1 = x1 * slope + intercept
        # y1 ~ normal(mean1, noise)
        # else
        # y1 ~ normal(0, 10)
        # end

        # outlier2 ~ bernoulli(proboutlier)
        # if outlier2 == 0
        # mean2 = x2 * slope + intercept
        # y2 ~ normal(mean2, noise)
        # else
        # y2 ~ normal(0, 10)
        # end

        # outlier3 ~ bernoulli(proboutlier)
        # if outlier3 == 0
        # mean3 = x3 * slope + intercept
        # y3 ~ normal(mean3, noise)
        # else
        # y3 ~ normal(0, 10)
        # end

        # outlier4 ~ bernoulli(proboutlier)
        # if outlier4 == 0
        # mean4 = x4 * slope + intercept
        # y4 ~ normal(mean4, noise)
        # else
        # y4 ~ normal(0, 10)
        # end

        # outlier5 ~ bernoulli(proboutlier)
        # if outlier5 == 0
        # mean5 = x5 * slope + intercept
        # y5 ~ normal(mean5, noise)
        # else
        # y5 ~ normal(0, 10)
        # end

        # outlier6 ~ bernoulli(proboutlier)
        # if outlier6 == 0
        # mean6 = x6 * slope + intercept
        # y6 ~ normal(mean6, noise)
        # else
        # y6 ~ normal(0, 10)
        # end

        # outlier7 ~ bernoulli(proboutlier)
        # if outlier7 == 0
        # mean7 = x7 * slope + intercept
        # y7 ~ normal(mean7, noise)
        # else
        # y7 ~ normal(0, 10)
        # end

        # outlier8 ~ bernoulli(proboutlier)
        # if outlier8 == 0
        # mean8 = x8 * slope + intercept
        # y8 ~ normal(mean8, noise)
        # else
        # y8 ~ normal(0, 10)
        # end

        # outlier9 ~ bernoulli(proboutlier)
        # if outlier9 == 0
        # mean9 = x9 * slope + intercept
        # y9 ~ normal(mean9, noise)
        # else
        # y9 ~ normal(0, 10)
        # end

        # outlier10 ~ bernoulli(proboutlier)
        # if outlier10 == 0
        # mean10 = x10 * slope + intercept
        # y10 ~ normal(mean10, noise)
        # else
        # y10 ~ normal(0, 10)
        # end

        # outlier11 ~ bernoulli(proboutlier)
        # if outlier11 == 0
        # mean11 = x11 * slope + intercept
        # y11 ~ normal(mean11, noise)
        # else
        # y11 ~ normal(0, 10)
        # end

        # outlier12 ~ bernoulli(proboutlier)
        # if outlier12 == 0
        # mean12 = x12 * slope + intercept
        # y12 ~ normal(mean12, noise)
        # else
        # y12 ~ normal(0, 10)
        # end

        # outlier13 ~ bernoulli(proboutlier)
        # if outlier13 == 0
        # mean13 = x13 * slope + intercept
        # y13 ~ normal(mean13, noise)
        # else
        # y13 ~ normal(0, 10)
        # end

        # outlier14 ~ bernoulli(proboutlier)
        # if outlier14 == 0
        # mean14 = x14 * slope + intercept
        # y14 ~ normal(mean14, noise)
        # else
        # y14 ~ normal(0, 10)
        # end

        # outlier15 ~ bernoulli(proboutlier)
        # if outlier15 == 0
        # mean15 = x15 * slope + intercept
        # y15 ~ normal(mean15, noise)
        # else
        # y15 ~ normal(0, 10)
        # end

        # outlier16 ~ bernoulli(proboutlier)
        # if outlier16 == 0
        # mean16 = x16 * slope + intercept
        # y16 ~ normal(mean16, noise)
        # else
        # y16 ~ normal(0, 10)
        # end

        # outlier17 ~ bernoulli(proboutlier)
        # if outlier17 == 0
        # mean17 = x17 * slope + intercept
        # y17 ~ normal(mean17, noise)
        # else
        # y17 ~ normal(0, 10)
        # end

        # outlier18 ~ bernoulli(proboutlier)
        # if outlier18 == 0
        # mean18 = x18 * slope + intercept
        # y18 ~ normal(mean18, noise)
        # else
        # y18 ~ normal(0, 10)
        # end

        # outlier19 ~ bernoulli(proboutlier)
        # if outlier19 == 0
        # mean19 = x19 * slope + intercept
        # y19 ~ normal(mean19, noise)
        # else
        # y19 ~ normal(0, 10)
        # end

        # outlier20 ~ bernoulli(proboutlier)
        # if outlier20 == 0
        # mean20 = x20 * slope + intercept
        # y20 ~ normal(mean20, noise)
        # else
        # y20 ~ normal(0, 10)
        # end

        # outlier21 ~ bernoulli(proboutlier)
        # if outlier21 == 0
        # mean21 = x21 * slope + intercept
        # y21 ~ normal(mean21, noise)
        # else
        # y21 ~ normal(0, 10)
        # end

        # outlier22 ~ bernoulli(proboutlier)
        # if outlier22 == 0
        # mean22 = x22 * slope + intercept
        # y22 ~ normal(mean22, noise)
        # else
        # y22 ~ normal(0, 10)
        # end

        # outlier23 ~ bernoulli(proboutlier)
        # if outlier23 == 0
        # mean23 = x23 * slope + intercept
        # y23 ~ normal(mean23, noise)
        # else
        # y23 ~ normal(0, 10)
        # end

        # outlier24 ~ bernoulli(proboutlier)
        # if outlier24 == 0
        # mean24 = x24 * slope + intercept
        # y24 ~ normal(mean24, noise)
        # else
        # y24 ~ normal(0, 10)
        # end

        # outlier25 ~ bernoulli(proboutlier)
        # if outlier25 == 0
        # mean25 = x25 * slope + intercept
        # y25 ~ normal(mean25, noise)
        # else
        # y25 ~ normal(0, 10)
        # end

        # outlier26 ~ bernoulli(proboutlier)
        # if outlier26 == 0
        # mean26 = x26 * slope + intercept
        # y26 ~ normal(mean26, noise)
        # else
        # y26 ~ normal(0, 10)
        # end

        # outlier27 ~ bernoulli(proboutlier)
        # if outlier27 == 0
        # mean27 = x27 * slope + intercept
        # y27 ~ normal(mean27, noise)
        # else
        # y27 ~ normal(0, 10)
        # end

        # outlier28 ~ bernoulli(proboutlier)
        # if outlier28 == 0
        # mean28 = x28 * slope + intercept
        # y28 ~ normal(mean28, noise)
        # else
        # y28 ~ normal(0, 10)
        # end

        # outlier29 ~ bernoulli(proboutlier)
        # if outlier29 == 0
        # mean29 = x29 * slope + intercept
        # y29 ~ normal(mean29, noise)
        # else
        # y29 ~ normal(0, 10)
        # end

        # outlier30 ~ bernoulli(proboutlier)
        # if outlier30 == 0
        # mean30 = x30 * slope + intercept
        # y30 ~ normal(mean30, noise)
        # else
        # y30 ~ normal(0, 10)
        # end

        # outlier31 ~ bernoulli(proboutlier)
        # if outlier31 == 0
        # mean31 = x31 * slope + intercept
        # y31 ~ normal(mean31, noise)
        # else
        # y31 ~ normal(0, 10)
        # end

        # outlier32 ~ bernoulli(proboutlier)
        # if outlier32 == 0
        # mean32 = x32 * slope + intercept
        # y32 ~ normal(mean32, noise)
        # else
        # y32 ~ normal(0, 10)
        # end

        # outlier33 ~ bernoulli(proboutlier)
        # if outlier33 == 0
        # mean33 = x33 * slope + intercept
        # y33 ~ normal(mean33, noise)
        # else
        # y33 ~ normal(0, 10)
        # end

        # outlier34 ~ bernoulli(proboutlier)
        # if outlier34 == 0
        # mean34 = x34 * slope + intercept
        # y34 ~ normal(mean34, noise)
        # else
        # y34 ~ normal(0, 10)
        # end

        # outlier35 ~ bernoulli(proboutlier)
        # if outlier35 == 0
        # mean35 = x35 * slope + intercept
        # y35 ~ normal(mean35, noise)
        # else
        # y35 ~ normal(0, 10)
        # end

        # outlier36 ~ bernoulli(proboutlier)
        # if outlier36 == 0
        # mean36 = x36 * slope + intercept
        # y36 ~ normal(mean36, noise)
        # else
        # y36 ~ normal(0, 10)
        # end

        # outlier37 ~ bernoulli(proboutlier)
        # if outlier37 == 0
        # mean37 = x37 * slope + intercept
        # y37 ~ normal(mean37, noise)
        # else
        # y37 ~ normal(0, 10)
        # end

        # outlier38 ~ bernoulli(proboutlier)
        # if outlier38 == 0
        # mean38 = x38 * slope + intercept
        # y38 ~ normal(mean38, noise)
        # else
        # y38 ~ normal(0, 10)
        # end

        # outlier39 ~ bernoulli(proboutlier)
        # if outlier39 == 0
        # mean39 = x39 * slope + intercept
        # y39 ~ normal(mean39, noise)
        # else
        # y39 ~ normal(0, 10)
        # end

        # outlier40 ~ bernoulli(proboutlier)
        # if outlier40 == 0
        # mean40 = x40 * slope + intercept
        # y40 ~ normal(mean40, noise)
        # else
        # y40 ~ normal(0, 10)
        # end

        # outlier41 ~ bernoulli(proboutlier)
        # if outlier41 == 0
        # mean41 = x41 * slope + intercept
        # y41 ~ normal(mean41, noise)
        # else
        # y41 ~ normal(0, 10)
        # end

        # outlier42 ~ bernoulli(proboutlier)
        # if outlier42 == 0
        # mean42 = x42 * slope + intercept
        # y42 ~ normal(mean42, noise)
        # else
        # y42 ~ normal(0, 10)
        # end

        # outlier43 ~ bernoulli(proboutlier)
        # if outlier43 == 0
        # mean43 = x43 * slope + intercept
        # y43 ~ normal(mean43, noise)
        # else
        # y43 ~ normal(0, 10)
        # end

        # outlier44 ~ bernoulli(proboutlier)
        # if outlier44 == 0
        # mean44 = x44 * slope + intercept
        # y44 ~ normal(mean44, noise)
        # else
        # y44 ~ normal(0, 10)
        # end

        # outlier45 ~ bernoulli(proboutlier)
        # if outlier45 == 0
        # mean45 = x45 * slope + intercept
        # y45 ~ normal(mean45, noise)
        # else
        # y45 ~ normal(0, 10)
        # end

        # outlier46 ~ bernoulli(proboutlier)
        # if outlier46 == 0
        # mean46 = x46 * slope + intercept
        # y46 ~ normal(mean46, noise)
        # else
        # y46 ~ normal(0, 10)
        # end

        # outlier47 ~ bernoulli(proboutlier)
        # if outlier47 == 0
        # mean47 = x47 * slope + intercept
        # y47 ~ normal(mean47, noise)
        # else
        # y47 ~ normal(0, 10)
        # end

        # outlier48 ~ bernoulli(proboutlier)
        # if outlier48 == 0
        # mean48 = x48 * slope + intercept
        # y48 ~ normal(mean48, noise)
        # else
        # y48 ~ normal(0, 10)
        # end

        # outlier49 ~ bernoulli(proboutlier)
        # if outlier49 == 0
        # mean49 = x49 * slope + intercept
        # y49 ~ normal(mean49, noise)
        # else
        # y49 ~ normal(0, 10)
        # end

        # outlier50 ~ bernoulli(proboutlier)
        # if outlier50 == 0
        # mean50 = x50 * slope + intercept
        # y50 ~ normal(mean50, noise)
        # else
        # y50 ~ normal(0, 10)
        # end

        # outlier51 ~ bernoulli(proboutlier)
        # if outlier51 == 0
        # mean51 = x51 * slope + intercept
        # y51 ~ normal(mean51, noise)
        # else
        # y51 ~ normal(0, 10)
        # end

        # outlier52 ~ bernoulli(proboutlier)
        # if outlier52 == 0
        # mean52 = x52 * slope + intercept
        # y52 ~ normal(mean52, noise)
        # else
        # y52 ~ normal(0, 10)
        # end

        # outlier53 ~ bernoulli(proboutlier)
        # if outlier53 == 0
        # mean53 = x53 * slope + intercept
        # y53 ~ normal(mean53, noise)
        # else
        # y53 ~ normal(0, 10)
        # end

        # outlier54 ~ bernoulli(proboutlier)
        # if outlier54 == 0
        # mean54 = x54 * slope + intercept
        # y54 ~ normal(mean54, noise)
        # else
        # y54 ~ normal(0, 10)
        # end

        # outlier55 ~ bernoulli(proboutlier)
        # if outlier55 == 0
        # mean55 = x55 * slope + intercept
        # y55 ~ normal(mean55, noise)
        # else
        # y55 ~ normal(0, 10)
        # end

        # outlier56 ~ bernoulli(proboutlier)
        # if outlier56 == 0
        # mean56 = x56 * slope + intercept
        # y56 ~ normal(mean56, noise)
        # else
        # y56 ~ normal(0, 10)
        # end

        # outlier57 ~ bernoulli(proboutlier)
        # if outlier57 == 0
        # mean57 = x57 * slope + intercept
        # y57 ~ normal(mean57, noise)
        # else
        # y57 ~ normal(0, 10)
        # end

        # outlier58 ~ bernoulli(proboutlier)
        # if outlier58 == 0
        # mean58 = x58 * slope + intercept
        # y58 ~ normal(mean58, noise)
        # else
        # y58 ~ normal(0, 10)
        # end

        # outlier59 ~ bernoulli(proboutlier)
        # if outlier59 == 0
        # mean59 = x59 * slope + intercept
        # y59 ~ normal(mean59, noise)
        # else
        # y59 ~ normal(0, 10)
        # end

        # outlier60 ~ bernoulli(proboutlier)
        # if outlier60 == 0
        # mean60 = x60 * slope + intercept
        # y60 ~ normal(mean60, noise)
        # else
        # y60 ~ normal(0, 10)
        # end

        # outlier61 ~ bernoulli(proboutlier)
        # if outlier61 == 0
        # mean61 = x61 * slope + intercept
        # y61 ~ normal(mean61, noise)
        # else
        # y61 ~ normal(0, 10)
        # end

        # outlier62 ~ bernoulli(proboutlier)
        # if outlier62 == 0
        # mean62 = x62 * slope + intercept
        # y62 ~ normal(mean62, noise)
        # else
        # y62 ~ normal(0, 10)
        # end

        # outlier63 ~ bernoulli(proboutlier)
        # if outlier63 == 0
        # mean63 = x63 * slope + intercept
        # y63 ~ normal(mean63, noise)
        # else
        # y63 ~ normal(0, 10)
        # end

        # outlier64 ~ bernoulli(proboutlier)
        # if outlier64 == 0
        # mean64 = x64 * slope + intercept
        # y64 ~ normal(mean64, noise)
        # else
        # y64 ~ normal(0, 10)
        # end

        # outlier65 ~ bernoulli(proboutlier)
        # if outlier65 == 0
        # mean65 = x65 * slope + intercept
        # y65 ~ normal(mean65, noise)
        # else
        # y65 ~ normal(0, 10)
        # end

        # outlier66 ~ bernoulli(proboutlier)
        # if outlier66 == 0
        # mean66 = x66 * slope + intercept
        # y66 ~ normal(mean66, noise)
        # else
        # y66 ~ normal(0, 10)
        # end

        # outlier67 ~ bernoulli(proboutlier)
        # if outlier67 == 0
        # mean67 = x67 * slope + intercept
        # y67 ~ normal(mean67, noise)
        # else
        # y67 ~ normal(0, 10)
        # end

        # outlier68 ~ bernoulli(proboutlier)
        # if outlier68 == 0
        # mean68 = x68 * slope + intercept
        # y68 ~ normal(mean68, noise)
        # else
        # y68 ~ normal(0, 10)
        # end

        # outlier69 ~ bernoulli(proboutlier)
        # if outlier69 == 0
        # mean69 = x69 * slope + intercept
        # y69 ~ normal(mean69, noise)
        # else
        # y69 ~ normal(0, 10)
        # end

        # outlier70 ~ bernoulli(proboutlier)
        # if outlier70 == 0
        # mean70 = x70 * slope + intercept
        # y70 ~ normal(mean70, noise)
        # else
        # y70 ~ normal(0, 10)
        # end

        # outlier71 ~ bernoulli(proboutlier)
        # if outlier71 == 0
        # mean71 = x71 * slope + intercept
        # y71 ~ normal(mean71, noise)
        # else
        # y71 ~ normal(0, 10)
        # end

        # outlier72 ~ bernoulli(proboutlier)
        # if outlier72 == 0
        # mean72 = x72 * slope + intercept
        # y72 ~ normal(mean72, noise)
        # else
        # y72 ~ normal(0, 10)
        # end

        # outlier73 ~ bernoulli(proboutlier)
        # if outlier73 == 0
        # mean73 = x73 * slope + intercept
        # y73 ~ normal(mean73, noise)
        # else
        # y73 ~ normal(0, 10)
        # end

        # outlier74 ~ bernoulli(proboutlier)
        # if outlier74 == 0
        # mean74 = x74 * slope + intercept
        # y74 ~ normal(mean74, noise)
        # else
        # y74 ~ normal(0, 10)
        # end

        # outlier75 ~ bernoulli(proboutlier)
        # if outlier75 == 0
        # mean75 = x75 * slope + intercept
        # y75 ~ normal(mean75, noise)
        # else
        # y75 ~ normal(0, 10)
        # end

        # outlier76 ~ bernoulli(proboutlier)
        # if outlier76 == 0
        # mean76 = x76 * slope + intercept
        # y76 ~ normal(mean76, noise)
        # else
        # y76 ~ normal(0, 10)
        # end

        # outlier77 ~ bernoulli(proboutlier)
        # if outlier77 == 0
        # mean77 = x77 * slope + intercept
        # y77 ~ normal(mean77, noise)
        # else
        # y77 ~ normal(0, 10)
        # end

        # outlier78 ~ bernoulli(proboutlier)
        # if outlier78 == 0
        # mean78 = x78 * slope + intercept
        # y78 ~ normal(mean78, noise)
        # else
        # y78 ~ normal(0, 10)
        # end

        # outlier79 ~ bernoulli(proboutlier)
        # if outlier79 == 0
        # mean79 = x79 * slope + intercept
        # y79 ~ normal(mean79, noise)
        # else
        # y79 ~ normal(0, 10)
        # end

        # outlier80 ~ bernoulli(proboutlier)
        # if outlier80 == 0
        # mean80 = x80 * slope + intercept
        # y80 ~ normal(mean80, noise)
        # else
        # y80 ~ normal(0, 10)
        # end

        # outlier81 ~ bernoulli(proboutlier)
        # if outlier81 == 0
        # mean81 = x81 * slope + intercept
        # y81 ~ normal(mean81, noise)
        # else
        # y81 ~ normal(0, 10)
        # end

        # outlier82 ~ bernoulli(proboutlier)
        # if outlier82 == 0
        # mean82 = x82 * slope + intercept
        # y82 ~ normal(mean82, noise)
        # else
        # y82 ~ normal(0, 10)
        # end

        # outlier83 ~ bernoulli(proboutlier)
        # if outlier83 == 0
        # mean83 = x83 * slope + intercept
        # y83 ~ normal(mean83, noise)
        # else
        # y83 ~ normal(0, 10)
        # end

        # outlier84 ~ bernoulli(proboutlier)
        # if outlier84 == 0
        # mean84 = x84 * slope + intercept
        # y84 ~ normal(mean84, noise)
        # else
        # y84 ~ normal(0, 10)
        # end

        # outlier85 ~ bernoulli(proboutlier)
        # if outlier85 == 0
        # mean85 = x85 * slope + intercept
        # y85 ~ normal(mean85, noise)
        # else
        # y85 ~ normal(0, 10)
        # end

        # outlier86 ~ bernoulli(proboutlier)
        # if outlier86 == 0
        # mean86 = x86 * slope + intercept
        # y86 ~ normal(mean86, noise)
        # else
        # y86 ~ normal(0, 10)
        # end

        # outlier87 ~ bernoulli(proboutlier)
        # if outlier87 == 0
        # mean87 = x87 * slope + intercept
        # y87 ~ normal(mean87, noise)
        # else
        # y87 ~ normal(0, 10)
        # end

        # outlier88 ~ bernoulli(proboutlier)
        # if outlier88 == 0
        # mean88 = x88 * slope + intercept
        # y88 ~ normal(mean88, noise)
        # else
        # y88 ~ normal(0, 10)
        # end

        # outlier89 ~ bernoulli(proboutlier)
        # if outlier89 == 0
        # mean89 = x89 * slope + intercept
        # y89 ~ normal(mean89, noise)
        # else
        # y89 ~ normal(0, 10)
        # end

        # outlier90 ~ bernoulli(proboutlier)
        # if outlier90 == 0
        # mean90 = x90 * slope + intercept
        # y90 ~ normal(mean90, noise)
        # else
        # y90 ~ normal(0, 10)
        # end

        # outlier91 ~ bernoulli(proboutlier)
        # if outlier91 == 0
        # mean91 = x91 * slope + intercept
        # y91 ~ normal(mean91, noise)
        # else
        # y91 ~ normal(0, 10)
        # end

        # outlier92 ~ bernoulli(proboutlier)
        # if outlier92 == 0
        # mean92 = x92 * slope + intercept
        # y92 ~ normal(mean92, noise)
        # else
        # y92 ~ normal(0, 10)
        # end

        # outlier93 ~ bernoulli(proboutlier)
        # if outlier93 == 0
        # mean93 = x93 * slope + intercept
        # y93 ~ normal(mean93, noise)
        # else
        # y93 ~ normal(0, 10)
        # end

        # outlier94 ~ bernoulli(proboutlier)
        # if outlier94 == 0
        # mean94 = x94 * slope + intercept
        # y94 ~ normal(mean94, noise)
        # else
        # y94 ~ normal(0, 10)
        # end

        # outlier95 ~ bernoulli(proboutlier)
        # if outlier95 == 0
        # mean95 = x95 * slope + intercept
        # y95 ~ normal(mean95, noise)
        # else
        # y95 ~ normal(0, 10)
        # end

        # outlier96 ~ bernoulli(proboutlier)
        # if outlier96 == 0
        # mean96 = x96 * slope + intercept
        # y96 ~ normal(mean96, noise)
        # else
        # y96 ~ normal(0, 10)
        # end

        # outlier97 ~ bernoulli(proboutlier)
        # if outlier97 == 0
        # mean97 = x97 * slope + intercept
        # y97 ~ normal(mean97, noise)
        # else
        # y97 ~ normal(0, 10)
        # end

        # outlier98 ~ bernoulli(proboutlier)
        # if outlier98 == 0
        # mean98 = x98 * slope + intercept
        # y98 ~ normal(mean98, noise)
        # else
        # y98 ~ normal(0, 10)
        # end

        # outlier99 ~ bernoulli(proboutlier)
        # if outlier99 == 0
        # mean99 = x99 * slope + intercept
        # y99 ~ normal(mean99, noise)
        # else
        # y99 ~ normal(0, 10)
        # end

        # outlier100 ~ bernoulli(proboutlier)
        # if outlier100 == 0
        # mean100 = x100 * slope + intercept
        # y100 ~ normal(mean100, noise)
        # else
        # y100 ~ normal(0, 10)
        # end

    end

