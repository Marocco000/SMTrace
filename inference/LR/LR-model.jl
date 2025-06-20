@gen function ppmodel()
    intercept ~ normal(0,2)
    slope ~ normal(0,2)
    # slope ~ normal(0,2)

    # x1 = -5.0
    # x2 = -4.473684210526316
    # x3 = -3.9473684210526314
    # x4 = -3.4210526315789473
    # x5 = -2.8947368421052633
    # x6 = -2.3684210526315788
    # x7 = -1.8421052631578947
    # x8 = -1.3157894736842106
    # x9 = -0.7894736842105263
    # x10 = -0.2631578947368421
    # x11 = 0.2631578947368421
    # x12 = 0.7894736842105263
    # x13 = 1.3157894736842106
    # x14 = 1.8421052631578947
    # x15 = 2.3684210526315788
    # x16 = 2.8947368421052633
    # x17 = 3.4210526315789473
    # x18 = 3.9473684210526314
    # x19 = 4.473684210526316
    # x20 = 5.0
    
    
    # mean1 = x1 * slope + intercept
    # y1 ~ normal(mean1, 0.5)
    
    # mean2 = x2 * slope + intercept
    # y2 ~ normal(mean2, 0.5)
    
    # mean3 = x3 * slope + intercept
    # y3 ~ normal(mean3, 0.5)
    
    # mean4 = x4 * slope + intercept
    # y4 ~ normal(mean4, 0.5)
    
    # mean5 = x5 * slope + intercept
    # y5 ~ normal(mean5, 0.5)
    
    # mean6 = x6 * slope + intercept
    # y6 ~ normal(mean6, 0.5)
    
    # mean7 = x7 * slope + intercept
    # y7 ~ normal(mean7, 0.5)
    
    # mean8 = x8 * slope + intercept
    # y8 ~ normal(mean8, 0.5)
    
    # mean9 = x9 * slope + intercept
    # y9 ~ normal(mean9, 0.5)
    
    # mean10 = x10 * slope + intercept
    # y10 ~ normal(mean10, 0.5)
    
    # mean11 = x11 * slope + intercept
    # y11 ~ normal(mean11, 0.5)
    
    # mean12 = x12 * slope + intercept
    # y12 ~ normal(mean12, 0.5)
    
    # mean13 = x13 * slope + intercept
    # y13 ~ normal(mean13, 0.5)
    
    # mean14 = x14 * slope + intercept
    # y14 ~ normal(mean14, 0.5)
    
    # mean15 = x15 * slope + intercept
    # y15 ~ normal(mean15, 0.5)
    
    # mean16 = x16 * slope + intercept
    # y16 ~ normal(mean16, 0.5)
    
    # mean17 = x17 * slope + intercept
    # y17 ~ normal(mean17, 0.5)
    
    # mean18 = x18 * slope + intercept
    # y18 ~ normal(mean18, 0.5)
    
    # mean19 = x19 * slope + intercept
    # y19 ~ normal(mean19, 0.5)
    
    # mean20 = x20 * slope + intercept
    # y20 ~ normal(mean20, 0.5)

    # # n = 100 data points
    x1 = -5.0
    x2 = -4.898989898989899
    x3 = -4.797979797979798
    x4 = -4.696969696969697
    x5 = -4.595959595959596
    x6 = -4.494949494949495
    x7 = -4.393939393939394
    x8 = -4.292929292929293
    x9 = -4.191919191919192
    x10 = -4.090909090909091
    x11 = -3.98989898989899
    x12 = -3.888888888888889
    x13 = -3.787878787878788
    x14 = -3.686868686868687
    x15 = -3.585858585858586
    x16 = -3.484848484848485
    x17 = -3.3838383838383836
    x18 = -3.282828282828283
    x19 = -3.1818181818181817
    x20 = -3.080808080808081
    x21 = -2.9797979797979797
    x22 = -2.878787878787879
    x23 = -2.7777777777777777
    x24 = -2.676767676767677
    x25 = -2.5757575757575757
    x26 = -2.474747474747475
    x27 = -2.3737373737373737
    x28 = -2.272727272727273
    x29 = -2.1717171717171717
    x30 = -2.0707070707070705
    x31 = -1.9696969696969697
    x32 = -1.8686868686868687
    x33 = -1.7676767676767677
    x34 = -1.6666666666666667
    x35 = -1.5656565656565657
    x36 = -1.4646464646464648
    x37 = -1.3636363636363635
    x38 = -1.2626262626262625
    x39 = -1.1616161616161615
    x40 = -1.0606060606060606
    x41 = -0.9595959595959596
    x42 = -0.8585858585858586
    x43 = -0.7575757575757576
    x44 = -0.6565656565656566
    x45 = -0.5555555555555556
    x46 = -0.45454545454545453
    x47 = -0.35353535353535354
    x48 = -0.25252525252525254
    x49 = -0.15151515151515152
    x50 = -0.050505050505050504
    x51 = 0.050505050505050504
    x52 = 0.15151515151515152
    x53 = 0.25252525252525254
    x54 = 0.35353535353535354
    x55 = 0.45454545454545453
    x56 = 0.5555555555555556
    x57 = 0.6565656565656566
    x58 = 0.7575757575757576
    x59 = 0.8585858585858586
    x60 = 0.9595959595959596
    x61 = 1.0606060606060606
    x62 = 1.1616161616161615
    x63 = 1.2626262626262625
    x64 = 1.3636363636363635
    x65 = 1.4646464646464648
    x66 = 1.5656565656565657
    x67 = 1.6666666666666667
    x68 = 1.7676767676767677
    x69 = 1.8686868686868687
    x70 = 1.9696969696969697
    x71 = 2.0707070707070705
    x72 = 2.1717171717171717
    x73 = 2.272727272727273
    x74 = 2.3737373737373737
    x75 = 2.474747474747475
    x76 = 2.5757575757575757
    x77 = 2.676767676767677
    x78 = 2.7777777777777777
    x79 = 2.878787878787879
    x80 = 2.9797979797979797
    x81 = 3.080808080808081
    x82 = 3.1818181818181817
    x83 = 3.282828282828283
    x84 = 3.3838383838383836
    x85 = 3.484848484848485
    x86 = 3.585858585858586
    x87 = 3.686868686868687
    x88 = 3.787878787878788
    x89 = 3.888888888888889
    x90 = 3.98989898989899
    x91 = 4.090909090909091
    x92 = 4.191919191919192
    x93 = 4.292929292929293
    x94 = 4.393939393939394
    x95 = 4.494949494949495
    x96 = 4.595959595959596
    x97 = 4.696969696969697
    x98 = 4.797979797979798
    x99 = 4.898989898989899
    x100 = 5.0


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

    mean21 = x21 * slope + intercept
    y21 ~ normal(mean21, 0.5)

    mean22 = x22 * slope + intercept
    y22 ~ normal(mean22, 0.5)

    mean23 = x23 * slope + intercept
    y23 ~ normal(mean23, 0.5)

    mean24 = x24 * slope + intercept
    y24 ~ normal(mean24, 0.5)

    mean25 = x25 * slope + intercept
    y25 ~ normal(mean25, 0.5)

    mean26 = x26 * slope + intercept
    y26 ~ normal(mean26, 0.5)

    mean27 = x27 * slope + intercept
    y27 ~ normal(mean27, 0.5)

    mean28 = x28 * slope + intercept
    y28 ~ normal(mean28, 0.5)

    mean29 = x29 * slope + intercept
    y29 ~ normal(mean29, 0.5)

    mean30 = x30 * slope + intercept
    y30 ~ normal(mean30, 0.5)

    mean31 = x31 * slope + intercept
    y31 ~ normal(mean31, 0.5)

    mean32 = x32 * slope + intercept
    y32 ~ normal(mean32, 0.5)

    mean33 = x33 * slope + intercept
    y33 ~ normal(mean33, 0.5)

    mean34 = x34 * slope + intercept
    y34 ~ normal(mean34, 0.5)

    mean35 = x35 * slope + intercept
    y35 ~ normal(mean35, 0.5)

    mean36 = x36 * slope + intercept
    y36 ~ normal(mean36, 0.5)

    mean37 = x37 * slope + intercept
    y37 ~ normal(mean37, 0.5)

    mean38 = x38 * slope + intercept
    y38 ~ normal(mean38, 0.5)

    mean39 = x39 * slope + intercept
    y39 ~ normal(mean39, 0.5)

    mean40 = x40 * slope + intercept
    y40 ~ normal(mean40, 0.5)

    mean41 = x41 * slope + intercept
    y41 ~ normal(mean41, 0.5)

    mean42 = x42 * slope + intercept
    y42 ~ normal(mean42, 0.5)

    mean43 = x43 * slope + intercept
    y43 ~ normal(mean43, 0.5)

    mean44 = x44 * slope + intercept
    y44 ~ normal(mean44, 0.5)

    mean45 = x45 * slope + intercept
    y45 ~ normal(mean45, 0.5)

    mean46 = x46 * slope + intercept
    y46 ~ normal(mean46, 0.5)

    mean47 = x47 * slope + intercept
    y47 ~ normal(mean47, 0.5)

    mean48 = x48 * slope + intercept
    y48 ~ normal(mean48, 0.5)

    mean49 = x49 * slope + intercept
    y49 ~ normal(mean49, 0.5)

    mean50 = x50 * slope + intercept
    y50 ~ normal(mean50, 0.5)

    mean51 = x51 * slope + intercept
    y51 ~ normal(mean51, 0.5)

    mean52 = x52 * slope + intercept
    y52 ~ normal(mean52, 0.5)

    mean53 = x53 * slope + intercept
    y53 ~ normal(mean53, 0.5)

    mean54 = x54 * slope + intercept
    y54 ~ normal(mean54, 0.5)

    mean55 = x55 * slope + intercept
    y55 ~ normal(mean55, 0.5)

    mean56 = x56 * slope + intercept
    y56 ~ normal(mean56, 0.5)

    mean57 = x57 * slope + intercept
    y57 ~ normal(mean57, 0.5)

    mean58 = x58 * slope + intercept
    y58 ~ normal(mean58, 0.5)

    mean59 = x59 * slope + intercept
    y59 ~ normal(mean59, 0.5)

    mean60 = x60 * slope + intercept
    y60 ~ normal(mean60, 0.5)

    mean61 = x61 * slope + intercept
    y61 ~ normal(mean61, 0.5)

    mean62 = x62 * slope + intercept
    y62 ~ normal(mean62, 0.5)

    mean63 = x63 * slope + intercept
    y63 ~ normal(mean63, 0.5)

    mean64 = x64 * slope + intercept
    y64 ~ normal(mean64, 0.5)

    mean65 = x65 * slope + intercept
    y65 ~ normal(mean65, 0.5)

    mean66 = x66 * slope + intercept
    y66 ~ normal(mean66, 0.5)

    mean67 = x67 * slope + intercept
    y67 ~ normal(mean67, 0.5)

    mean68 = x68 * slope + intercept
    y68 ~ normal(mean68, 0.5)

    mean69 = x69 * slope + intercept
    y69 ~ normal(mean69, 0.5)

    mean70 = x70 * slope + intercept
    y70 ~ normal(mean70, 0.5)

    mean71 = x71 * slope + intercept
    y71 ~ normal(mean71, 0.5)

    mean72 = x72 * slope + intercept
    y72 ~ normal(mean72, 0.5)

    mean73 = x73 * slope + intercept
    y73 ~ normal(mean73, 0.5)

    mean74 = x74 * slope + intercept
    y74 ~ normal(mean74, 0.5)

    mean75 = x75 * slope + intercept
    y75 ~ normal(mean75, 0.5)

    mean76 = x76 * slope + intercept
    y76 ~ normal(mean76, 0.5)

    mean77 = x77 * slope + intercept
    y77 ~ normal(mean77, 0.5)

    mean78 = x78 * slope + intercept
    y78 ~ normal(mean78, 0.5)

    mean79 = x79 * slope + intercept
    y79 ~ normal(mean79, 0.5)

    mean80 = x80 * slope + intercept
    y80 ~ normal(mean80, 0.5)

    mean81 = x81 * slope + intercept
    y81 ~ normal(mean81, 0.5)

    mean82 = x82 * slope + intercept
    y82 ~ normal(mean82, 0.5)

    mean83 = x83 * slope + intercept
    y83 ~ normal(mean83, 0.5)

    mean84 = x84 * slope + intercept
    y84 ~ normal(mean84, 0.5)

    mean85 = x85 * slope + intercept
    y85 ~ normal(mean85, 0.5)

    mean86 = x86 * slope + intercept
    y86 ~ normal(mean86, 0.5)

    mean87 = x87 * slope + intercept
    y87 ~ normal(mean87, 0.5)

    mean88 = x88 * slope + intercept
    y88 ~ normal(mean88, 0.5)

    mean89 = x89 * slope + intercept
    y89 ~ normal(mean89, 0.5)

    mean90 = x90 * slope + intercept
    y90 ~ normal(mean90, 0.5)

    mean91 = x91 * slope + intercept
    y91 ~ normal(mean91, 0.5)

    mean92 = x92 * slope + intercept
    y92 ~ normal(mean92, 0.5)

    mean93 = x93 * slope + intercept
    y93 ~ normal(mean93, 0.5)

    mean94 = x94 * slope + intercept
    y94 ~ normal(mean94, 0.5)

    mean95 = x95 * slope + intercept
    y95 ~ normal(mean95, 0.5)

    mean96 = x96 * slope + intercept
    y96 ~ normal(mean96, 0.5)

    mean97 = x97 * slope + intercept
    y97 ~ normal(mean97, 0.5)

    mean98 = x98 * slope + intercept
    y98 ~ normal(mean98, 0.5)

    mean99 = x99 * slope + intercept
    y99 ~ normal(mean99, 0.5)

    mean100 = x100 * slope + intercept
    y100 ~ normal(mean100, 0.5)
end
