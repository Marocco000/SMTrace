@gen function ppmodel()
    # !Name must remain ppmodel

    #Gaussian mixture model:
    # K ∼ Poisson(9)+1, μk ∼ Uniform( 20(k − 1)K , 20k/K),
    # zn ∼ Cat({1/K, ..., 1/K}), yn ∼ N (μzn , 0.12).


    #number of clusters
    K = 3
   
    # TRUE
    mean1 ~ uniform(0, 6.5) # 0-6,6
    mean2 ~ uniform(6.5,13.3) # 6.6 - 13.3
    mean3 ~ uniform(13.3,20)#13.3 - 20

    # mean1 ~ normal(5, 0.5) # 0-6,6
    # mean2 ~ normal(6.5,0.5) # 6.6 - 13.3
    # mean3 ~ normal(18.3, 0.5) #13.3 - 20
 
    # z = [1, 3, 3, 3, 3, 2, 1, 2, 1, 1, 2, 1, 2, 2, 3, 2, 3, 2, 1, 1, 2, 2, 1, 3, 
    # 2, 1, 1, 3, 3, 2, 2, 3, 1, 3, 3, 2, 3, 3, 2, 1, 3, 3, 2, 2, 3, 3, 3, 3, 3, 1, 2, 3, 1, 2, 2, 1, 2, 1, 3, 3, 2, 2, 3, 3, 1, 1, 3, 2, 3, 1, 2, 3, 3, 3, 2, 1, 3, 1, 3, 1, 1, 1, 2, 1, 2, 2, 1, 2, 3, 2, 2, 1, 3, 3, 3, 2, 2, 3, 3, 3]
    # v = [1/3, 1/3, 1/3] 
    #  z1 ~ categorical(v) 
    z1 ~ categorical([1/3, 1/3, 1/3])
    z2 ~ categorical([1/3, 1/3, 1/3])
    z3 ~ categorical([1/3, 1/3, 1/3])
    z4 ~ categorical([1/3, 1/3, 1/3])
    z5 ~ categorical([1/3, 1/3, 1/3])
    z6 ~ categorical([1/3, 1/3, 1/3])
    z7 ~ categorical([1/3, 1/3, 1/3])
    z8 ~ categorical([1/3, 1/3, 1/3])
    z9 ~ categorical([1/3, 1/3, 1/3])
    z10 ~ categorical([1/3, 1/3, 1/3])
    z11 ~ categorical([1/3, 1/3, 1/3])
    z12 ~ categorical([1/3, 1/3, 1/3])
    z13 ~ categorical([1/3, 1/3, 1/3])
    z14 ~ categorical([1/3, 1/3, 1/3])
    z15 ~ categorical([1/3, 1/3, 1/3])
    z16 ~ categorical([1/3, 1/3, 1/3])
    z17 ~ categorical([1/3, 1/3, 1/3])
    z18 ~ categorical([1/3, 1/3, 1/3])
    z19 ~ categorical([1/3, 1/3, 1/3])
    z20 ~ categorical([1/3, 1/3, 1/3])
    z21 ~ categorical([1/3, 1/3, 1/3])
    z22 ~ categorical([1/3, 1/3, 1/3])
    z23 ~ categorical([1/3, 1/3, 1/3])
    z24 ~ categorical([1/3, 1/3, 1/3])
    z25 ~ categorical([1/3, 1/3, 1/3])
    z26 ~ categorical([1/3, 1/3, 1/3])
    z27 ~ categorical([1/3, 1/3, 1/3])
    z28 ~ categorical([1/3, 1/3, 1/3])
    z29 ~ categorical([1/3, 1/3, 1/3])
    z30 ~ categorical([1/3, 1/3, 1/3])
    z31 ~ categorical([1/3, 1/3, 1/3])
    z32 ~ categorical([1/3, 1/3, 1/3])
    z33 ~ categorical([1/3, 1/3, 1/3])
    z34 ~ categorical([1/3, 1/3, 1/3])
    z35 ~ categorical([1/3, 1/3, 1/3])
    z36 ~ categorical([1/3, 1/3, 1/3])
    z37 ~ categorical([1/3, 1/3, 1/3])
    z38 ~ categorical([1/3, 1/3, 1/3])
    z39 ~ categorical([1/3, 1/3, 1/3])
    z40 ~ categorical([1/3, 1/3, 1/3])
    z41 ~ categorical([1/3, 1/3, 1/3])
    z42 ~ categorical([1/3, 1/3, 1/3])
    z43 ~ categorical([1/3, 1/3, 1/3])
    z44 ~ categorical([1/3, 1/3, 1/3])
    z45 ~ categorical([1/3, 1/3, 1/3])
    z46 ~ categorical([1/3, 1/3, 1/3])
    z47 ~ categorical([1/3, 1/3, 1/3])
    z48 ~ categorical([1/3, 1/3, 1/3])
    z49 ~ categorical([1/3, 1/3, 1/3])
    z50 ~ categorical([1/3, 1/3, 1/3])
    z51 ~ categorical([1/3, 1/3, 1/3])
    z52 ~ categorical([1/3, 1/3, 1/3])
    z53 ~ categorical([1/3, 1/3, 1/3])
    z54 ~ categorical([1/3, 1/3, 1/3])
    z55 ~ categorical([1/3, 1/3, 1/3])
    z56 ~ categorical([1/3, 1/3, 1/3])
    z57 ~ categorical([1/3, 1/3, 1/3])
    z58 ~ categorical([1/3, 1/3, 1/3])
    z59 ~ categorical([1/3, 1/3, 1/3])
    z60 ~ categorical([1/3, 1/3, 1/3])
    z61 ~ categorical([1/3, 1/3, 1/3])
    z62 ~ categorical([1/3, 1/3, 1/3])
    z63 ~ categorical([1/3, 1/3, 1/3])
    z64 ~ categorical([1/3, 1/3, 1/3])
    z65 ~ categorical([1/3, 1/3, 1/3])
    z66 ~ categorical([1/3, 1/3, 1/3])
    z67 ~ categorical([1/3, 1/3, 1/3])
    z68 ~ categorical([1/3, 1/3, 1/3])
    z69 ~ categorical([1/3, 1/3, 1/3])
    z70 ~ categorical([1/3, 1/3, 1/3])
    z71 ~ categorical([1/3, 1/3, 1/3])
    z72 ~ categorical([1/3, 1/3, 1/3])
    z73 ~ categorical([1/3, 1/3, 1/3])
    z74 ~ categorical([1/3, 1/3, 1/3])
    z75 ~ categorical([1/3, 1/3, 1/3])
    z76 ~ categorical([1/3, 1/3, 1/3])
    z77 ~ categorical([1/3, 1/3, 1/3])
    z78 ~ categorical([1/3, 1/3, 1/3])
    z79 ~ categorical([1/3, 1/3, 1/3])
    z80 ~ categorical([1/3, 1/3, 1/3])
    z81 ~ categorical([1/3, 1/3, 1/3])
    z82 ~ categorical([1/3, 1/3, 1/3])
    z83 ~ categorical([1/3, 1/3, 1/3])
    z84 ~ categorical([1/3, 1/3, 1/3])
    z85 ~ categorical([1/3, 1/3, 1/3])
    z86 ~ categorical([1/3, 1/3, 1/3])
    z87 ~ categorical([1/3, 1/3, 1/3])
    z88 ~ categorical([1/3, 1/3, 1/3])
    z89 ~ categorical([1/3, 1/3, 1/3])
    z90 ~ categorical([1/3, 1/3, 1/3])
    z91 ~ categorical([1/3, 1/3, 1/3])
    z92 ~ categorical([1/3, 1/3, 1/3])
    z93 ~ categorical([1/3, 1/3, 1/3])
    z94 ~ categorical([1/3, 1/3, 1/3])
    z95 ~ categorical([1/3, 1/3, 1/3])
    z96 ~ categorical([1/3, 1/3, 1/3])
    z97 ~ categorical([1/3, 1/3, 1/3])
    z98 ~ categorical([1/3, 1/3, 1/3])
    z99 ~ categorical([1/3, 1/3, 1/3])
    z100 ~ categorical([1/3, 1/3, 1/3])



    if z1 == 1
        y1 ~ normal(mean1, 0.1)
    elseif z1 == 2
        y1 ~ normal(mean2, 0.1)
    else
        y1 ~ normal(mean3, 0.1)
    end

    if z2 == 1
        y2 ~ normal(mean1, 0.1)
    elseif z2 == 2
        y2 ~ normal(mean2, 0.1)
    else
        y2 ~ normal(mean3, 0.1)
    end

    if z3 == 1
        y3 ~ normal(mean1, 0.1)
    elseif z3 == 2
        y3 ~ normal(mean2, 0.1)
    else
        y3 ~ normal(mean3, 0.1)
    end

    if z4 == 1
        y4 ~ normal(mean1, 0.1)
    elseif z4 == 2
        y4 ~ normal(mean2, 0.1)
    else
        y4 ~ normal(mean3, 0.1)
    end

    if z5 == 1
        y5 ~ normal(mean1, 0.1)
    elseif z5 == 2
        y5 ~ normal(mean2, 0.1)
    else
        y5 ~ normal(mean3, 0.1)
    end

    if z6 == 1
        y6 ~ normal(mean1, 0.1)
    elseif z6 == 2
        y6 ~ normal(mean2, 0.1)
    else
        y6 ~ normal(mean3, 0.1)
    end

    if z7 == 1
        y7 ~ normal(mean1, 0.1)
    elseif z7 == 2
        y7 ~ normal(mean2, 0.1)
    else
        y7 ~ normal(mean3, 0.1)
    end

    if z8 == 1
        y8 ~ normal(mean1, 0.1)
    elseif z8 == 2
        y8 ~ normal(mean2, 0.1)
    else
        y8 ~ normal(mean3, 0.1)
    end

    if z9 == 1
        y9 ~ normal(mean1, 0.1)
    elseif z9 == 2
        y9 ~ normal(mean2, 0.1)
    else
        y9 ~ normal(mean3, 0.1)
    end

    if z10 == 1
        y10 ~ normal(mean1, 0.1)
    elseif z10 == 2
        y10 ~ normal(mean2, 0.1)
    else
        y10 ~ normal(mean3, 0.1)
    end

    if z11 == 1
        y11 ~ normal(mean1, 0.1)
    elseif z11 == 2
        y11 ~ normal(mean2, 0.1)
    else
        y11 ~ normal(mean3, 0.1)
    end

    if z12 == 1
        y12 ~ normal(mean1, 0.1)
    elseif z12 == 2
        y12 ~ normal(mean2, 0.1)
    else
        y12 ~ normal(mean3, 0.1)
    end

    if z13 == 1
        y13 ~ normal(mean1, 0.1)
    elseif z13 == 2
        y13 ~ normal(mean2, 0.1)
    else
        y13 ~ normal(mean3, 0.1)
    end

    if z14 == 1
        y14 ~ normal(mean1, 0.1)
    elseif z14 == 2
        y14 ~ normal(mean2, 0.1)
    else
        y14 ~ normal(mean3, 0.1)
    end

    if z15 == 1
        y15 ~ normal(mean1, 0.1)
    elseif z15 == 2
        y15 ~ normal(mean2, 0.1)
    else
        y15 ~ normal(mean3, 0.1)
    end

    if z16 == 1
        y16 ~ normal(mean1, 0.1)
    elseif z16 == 2
        y16 ~ normal(mean2, 0.1)
    else
        y16 ~ normal(mean3, 0.1)
    end

    if z17 == 1
        y17 ~ normal(mean1, 0.1)
    elseif z17 == 2
        y17 ~ normal(mean2, 0.1)
    else
        y17 ~ normal(mean3, 0.1)
    end

    if z18 == 1
        y18 ~ normal(mean1, 0.1)
    elseif z18 == 2
        y18 ~ normal(mean2, 0.1)
    else
        y18 ~ normal(mean3, 0.1)
    end

    if z19 == 1
        y19 ~ normal(mean1, 0.1)
    elseif z19 == 2
        y19 ~ normal(mean2, 0.1)
    else
        y19 ~ normal(mean3, 0.1)
    end

    if z20 == 1
        y20 ~ normal(mean1, 0.1)
    elseif z20 == 2
        y20 ~ normal(mean2, 0.1)
    else
        y20 ~ normal(mean3, 0.1)
    end

    if z21 == 1
        y21 ~ normal(mean1, 0.1)
    elseif z21 == 2
        y21 ~ normal(mean2, 0.1)
    else
        y21 ~ normal(mean3, 0.1)
    end

    if z22 == 1
        y22 ~ normal(mean1, 0.1)
    elseif z22 == 2
        y22 ~ normal(mean2, 0.1)
    else
        y22 ~ normal(mean3, 0.1)
    end

    if z23 == 1
        y23 ~ normal(mean1, 0.1)
    elseif z23 == 2
        y23 ~ normal(mean2, 0.1)
    else
        y23 ~ normal(mean3, 0.1)
    end

    if z24 == 1
        y24 ~ normal(mean1, 0.1)
    elseif z24 == 2
        y24 ~ normal(mean2, 0.1)
    else
        y24 ~ normal(mean3, 0.1)
    end

    if z25 == 1
        y25 ~ normal(mean1, 0.1)
    elseif z25 == 2
        y25 ~ normal(mean2, 0.1)
    else
        y25 ~ normal(mean3, 0.1)
    end

    if z26 == 1
        y26 ~ normal(mean1, 0.1)
    elseif z26 == 2
        y26 ~ normal(mean2, 0.1)
    else
        y26 ~ normal(mean3, 0.1)
    end

    if z27 == 1
        y27 ~ normal(mean1, 0.1)
    elseif z27 == 2
        y27 ~ normal(mean2, 0.1)
    else
        y27 ~ normal(mean3, 0.1)
    end

    if z28 == 1
        y28 ~ normal(mean1, 0.1)
    elseif z28 == 2
        y28 ~ normal(mean2, 0.1)
    else
        y28 ~ normal(mean3, 0.1)
    end

    if z29 == 1
        y29 ~ normal(mean1, 0.1)
    elseif z29 == 2
        y29 ~ normal(mean2, 0.1)
    else
        y29 ~ normal(mean3, 0.1)
    end

    if z30 == 1
        y30 ~ normal(mean1, 0.1)
    elseif z30 == 2
        y30 ~ normal(mean2, 0.1)
    else
        y30 ~ normal(mean3, 0.1)
    end

    if z31 == 1
        y31 ~ normal(mean1, 0.1)
    elseif z31 == 2
        y31 ~ normal(mean2, 0.1)
    else
        y31 ~ normal(mean3, 0.1)
    end

    if z32 == 1
        y32 ~ normal(mean1, 0.1)
    elseif z32 == 2
        y32 ~ normal(mean2, 0.1)
    else
        y32 ~ normal(mean3, 0.1)
    end

    if z33 == 1
        y33 ~ normal(mean1, 0.1)
    elseif z33 == 2
        y33 ~ normal(mean2, 0.1)
    else
        y33 ~ normal(mean3, 0.1)
    end

    if z34 == 1
        y34 ~ normal(mean1, 0.1)
    elseif z34 == 2
        y34 ~ normal(mean2, 0.1)
    else
        y34 ~ normal(mean3, 0.1)
    end

    if z35 == 1
        y35 ~ normal(mean1, 0.1)
    elseif z35 == 2
        y35 ~ normal(mean2, 0.1)
    else
        y35 ~ normal(mean3, 0.1)
    end

    if z36 == 1
        y36 ~ normal(mean1, 0.1)
    elseif z36 == 2
        y36 ~ normal(mean2, 0.1)
    else
        y36 ~ normal(mean3, 0.1)
    end

    if z37 == 1
        y37 ~ normal(mean1, 0.1)
    elseif z37 == 2
        y37 ~ normal(mean2, 0.1)
    else
        y37 ~ normal(mean3, 0.1)
    end

    if z38 == 1
        y38 ~ normal(mean1, 0.1)
    elseif z38 == 2
        y38 ~ normal(mean2, 0.1)
    else
        y38 ~ normal(mean3, 0.1)
    end

    if z39 == 1
        y39 ~ normal(mean1, 0.1)
    elseif z39 == 2
        y39 ~ normal(mean2, 0.1)
    else
        y39 ~ normal(mean3, 0.1)
    end

    if z40 == 1
        y40 ~ normal(mean1, 0.1)
    elseif z40 == 2
        y40 ~ normal(mean2, 0.1)
    else
        y40 ~ normal(mean3, 0.1)
    end

    if z41 == 1
        y41 ~ normal(mean1, 0.1)
    elseif z41 == 2
        y41 ~ normal(mean2, 0.1)
    else
        y41 ~ normal(mean3, 0.1)
    end

    if z42 == 1
        y42 ~ normal(mean1, 0.1)
    elseif z42 == 2
        y42 ~ normal(mean2, 0.1)
    else
        y42 ~ normal(mean3, 0.1)
    end

    if z43 == 1
        y43 ~ normal(mean1, 0.1)
    elseif z43 == 2
        y43 ~ normal(mean2, 0.1)
    else
        y43 ~ normal(mean3, 0.1)
    end

    if z44 == 1
        y44 ~ normal(mean1, 0.1)
    elseif z44 == 2
        y44 ~ normal(mean2, 0.1)
    else
        y44 ~ normal(mean3, 0.1)
    end

    if z45 == 1
        y45 ~ normal(mean1, 0.1)
    elseif z45 == 2
        y45 ~ normal(mean2, 0.1)
    else
        y45 ~ normal(mean3, 0.1)
    end

    if z46 == 1
        y46 ~ normal(mean1, 0.1)
    elseif z46 == 2
        y46 ~ normal(mean2, 0.1)
    else
        y46 ~ normal(mean3, 0.1)
    end

    if z47 == 1
        y47 ~ normal(mean1, 0.1)
    elseif z47 == 2
        y47 ~ normal(mean2, 0.1)
    else
        y47 ~ normal(mean3, 0.1)
    end

    if z48 == 1
        y48 ~ normal(mean1, 0.1)
    elseif z48 == 2
        y48 ~ normal(mean2, 0.1)
    else
        y48 ~ normal(mean3, 0.1)
    end

    if z49 == 1
        y49 ~ normal(mean1, 0.1)
    elseif z49 == 2
        y49 ~ normal(mean2, 0.1)
    else
        y49 ~ normal(mean3, 0.1)
    end

    if z50 == 1
        y50 ~ normal(mean1, 0.1)
    elseif z50 == 2
        y50 ~ normal(mean2, 0.1)
    else
        y50 ~ normal(mean3, 0.1)
    end

    if z51 == 1
        y51 ~ normal(mean1, 0.1)
    elseif z51 == 2
        y51 ~ normal(mean2, 0.1)
    else
        y51 ~ normal(mean3, 0.1)
    end

    if z52 == 1
        y52 ~ normal(mean1, 0.1)
    elseif z52 == 2
        y52 ~ normal(mean2, 0.1)
    else
        y52 ~ normal(mean3, 0.1)
    end

    if z53 == 1
        y53 ~ normal(mean1, 0.1)
    elseif z53 == 2
        y53 ~ normal(mean2, 0.1)
    else
        y53 ~ normal(mean3, 0.1)
    end

    if z54 == 1
        y54 ~ normal(mean1, 0.1)
    elseif z54 == 2
        y54 ~ normal(mean2, 0.1)
    else
        y54 ~ normal(mean3, 0.1)
    end

    if z55 == 1
        y55 ~ normal(mean1, 0.1)
    elseif z55 == 2
        y55 ~ normal(mean2, 0.1)
    else
        y55 ~ normal(mean3, 0.1)
    end

    if z56 == 1
        y56 ~ normal(mean1, 0.1)
    elseif z56 == 2
        y56 ~ normal(mean2, 0.1)
    else
        y56 ~ normal(mean3, 0.1)
    end

    if z57 == 1
        y57 ~ normal(mean1, 0.1)
    elseif z57 == 2
        y57 ~ normal(mean2, 0.1)
    else
        y57 ~ normal(mean3, 0.1)
    end

    if z58 == 1
        y58 ~ normal(mean1, 0.1)
    elseif z58 == 2
        y58 ~ normal(mean2, 0.1)
    else
        y58 ~ normal(mean3, 0.1)
    end

    if z59 == 1
        y59 ~ normal(mean1, 0.1)
    elseif z59 == 2
        y59 ~ normal(mean2, 0.1)
    else
        y59 ~ normal(mean3, 0.1)
    end

    if z60 == 1
        y60 ~ normal(mean1, 0.1)
    elseif z60 == 2
        y60 ~ normal(mean2, 0.1)
    else
        y60 ~ normal(mean3, 0.1)
    end

    if z61 == 1
        y61 ~ normal(mean1, 0.1)
    elseif z61 == 2
        y61 ~ normal(mean2, 0.1)
    else
        y61 ~ normal(mean3, 0.1)
    end

    if z62 == 1
        y62 ~ normal(mean1, 0.1)
    elseif z62 == 2
        y62 ~ normal(mean2, 0.1)
    else
        y62 ~ normal(mean3, 0.1)
    end

    if z63 == 1
        y63 ~ normal(mean1, 0.1)
    elseif z63 == 2
        y63 ~ normal(mean2, 0.1)
    else
        y63 ~ normal(mean3, 0.1)
    end

    if z64 == 1
        y64 ~ normal(mean1, 0.1)
    elseif z64 == 2
        y64 ~ normal(mean2, 0.1)
    else
        y64 ~ normal(mean3, 0.1)
    end

    if z65 == 1
        y65 ~ normal(mean1, 0.1)
    elseif z65 == 2
        y65 ~ normal(mean2, 0.1)
    else
        y65 ~ normal(mean3, 0.1)
    end

    if z66 == 1
        y66 ~ normal(mean1, 0.1)
    elseif z66 == 2
        y66 ~ normal(mean2, 0.1)
    else
        y66 ~ normal(mean3, 0.1)
    end

    if z67 == 1
        y67 ~ normal(mean1, 0.1)
    elseif z67 == 2
        y67 ~ normal(mean2, 0.1)
    else
        y67 ~ normal(mean3, 0.1)
    end

    if z68 == 1
        y68 ~ normal(mean1, 0.1)
    elseif z68 == 2
        y68 ~ normal(mean2, 0.1)
    else
        y68 ~ normal(mean3, 0.1)
    end

    if z69 == 1
        y69 ~ normal(mean1, 0.1)
    elseif z69 == 2
        y69 ~ normal(mean2, 0.1)
    else
        y69 ~ normal(mean3, 0.1)
    end

    if z70 == 1
        y70 ~ normal(mean1, 0.1)
    elseif z70 == 2
        y70 ~ normal(mean2, 0.1)
    else
        y70 ~ normal(mean3, 0.1)
    end

    if z71 == 1
        y71 ~ normal(mean1, 0.1)
    elseif z71 == 2
        y71 ~ normal(mean2, 0.1)
    else
        y71 ~ normal(mean3, 0.1)
    end

    if z72 == 1
        y72 ~ normal(mean1, 0.1)
    elseif z72 == 2
        y72 ~ normal(mean2, 0.1)
    else
        y72 ~ normal(mean3, 0.1)
    end

    if z73 == 1
        y73 ~ normal(mean1, 0.1)
    elseif z73 == 2
        y73 ~ normal(mean2, 0.1)
    else
        y73 ~ normal(mean3, 0.1)
    end

    if z74 == 1
        y74 ~ normal(mean1, 0.1)
    elseif z74 == 2
        y74 ~ normal(mean2, 0.1)
    else
        y74 ~ normal(mean3, 0.1)
    end

    if z75 == 1
        y75 ~ normal(mean1, 0.1)
    elseif z75 == 2
        y75 ~ normal(mean2, 0.1)
    else
        y75 ~ normal(mean3, 0.1)
    end

    if z76 == 1
        y76 ~ normal(mean1, 0.1)
    elseif z76 == 2
        y76 ~ normal(mean2, 0.1)
    else
        y76 ~ normal(mean3, 0.1)
    end

    if z77 == 1
        y77 ~ normal(mean1, 0.1)
    elseif z77 == 2
        y77 ~ normal(mean2, 0.1)
    else
        y77 ~ normal(mean3, 0.1)
    end

    if z78 == 1
        y78 ~ normal(mean1, 0.1)
    elseif z78 == 2
        y78 ~ normal(mean2, 0.1)
    else
        y78 ~ normal(mean3, 0.1)
    end

    if z79 == 1
        y79 ~ normal(mean1, 0.1)
    elseif z79 == 2
        y79 ~ normal(mean2, 0.1)
    else
        y79 ~ normal(mean3, 0.1)
    end

    if z80 == 1
        y80 ~ normal(mean1, 0.1)
    elseif z80 == 2
        y80 ~ normal(mean2, 0.1)
    else
        y80 ~ normal(mean3, 0.1)
    end

    if z81 == 1
        y81 ~ normal(mean1, 0.1)
    elseif z81 == 2
        y81 ~ normal(mean2, 0.1)
    else
        y81 ~ normal(mean3, 0.1)
    end

    if z82 == 1
        y82 ~ normal(mean1, 0.1)
    elseif z82 == 2
        y82 ~ normal(mean2, 0.1)
    else
        y82 ~ normal(mean3, 0.1)
    end

    if z83 == 1
        y83 ~ normal(mean1, 0.1)
    elseif z83 == 2
        y83 ~ normal(mean2, 0.1)
    else
        y83 ~ normal(mean3, 0.1)
    end

    if z84 == 1
        y84 ~ normal(mean1, 0.1)
    elseif z84 == 2
        y84 ~ normal(mean2, 0.1)
    else
        y84 ~ normal(mean3, 0.1)
    end

    if z85 == 1
        y85 ~ normal(mean1, 0.1)
    elseif z85 == 2
        y85 ~ normal(mean2, 0.1)
    else
        y85 ~ normal(mean3, 0.1)
    end

    if z86 == 1
        y86 ~ normal(mean1, 0.1)
    elseif z86 == 2
        y86 ~ normal(mean2, 0.1)
    else
        y86 ~ normal(mean3, 0.1)
    end

    if z87 == 1
        y87 ~ normal(mean1, 0.1)
    elseif z87 == 2
        y87 ~ normal(mean2, 0.1)
    else
        y87 ~ normal(mean3, 0.1)
    end

    if z88 == 1
        y88 ~ normal(mean1, 0.1)
    elseif z88 == 2
        y88 ~ normal(mean2, 0.1)
    else
        y88 ~ normal(mean3, 0.1)
    end

    if z89 == 1
        y89 ~ normal(mean1, 0.1)
    elseif z89 == 2
        y89 ~ normal(mean2, 0.1)
    else
        y89 ~ normal(mean3, 0.1)
    end

    if z90 == 1
        y90 ~ normal(mean1, 0.1)
    elseif z90 == 2
        y90 ~ normal(mean2, 0.1)
    else
        y90 ~ normal(mean3, 0.1)
    end

    if z91 == 1
        y91 ~ normal(mean1, 0.1)
    elseif z91 == 2
        y91 ~ normal(mean2, 0.1)
    else
        y91 ~ normal(mean3, 0.1)
    end

    if z92 == 1
        y92 ~ normal(mean1, 0.1)
    elseif z92 == 2
        y92 ~ normal(mean2, 0.1)
    else
        y92 ~ normal(mean3, 0.1)
    end

    if z93 == 1
        y93 ~ normal(mean1, 0.1)
    elseif z93 == 2
        y93 ~ normal(mean2, 0.1)
    else
        y93 ~ normal(mean3, 0.1)
    end

    if z94 == 1
        y94 ~ normal(mean1, 0.1)
    elseif z94 == 2
        y94 ~ normal(mean2, 0.1)
    else
        y94 ~ normal(mean3, 0.1)
    end

    if z95 == 1
        y95 ~ normal(mean1, 0.1)
    elseif z95 == 2
        y95 ~ normal(mean2, 0.1)
    else
        y95 ~ normal(mean3, 0.1)
    end

    if z96 == 1
        y96 ~ normal(mean1, 0.1)
    elseif z96 == 2
        y96 ~ normal(mean2, 0.1)
    else
        y96 ~ normal(mean3, 0.1)
    end

    if z97 == 1
        y97 ~ normal(mean1, 0.1)
    elseif z97 == 2
        y97 ~ normal(mean2, 0.1)
    else
        y97 ~ normal(mean3, 0.1)
    end

    if z98 == 1
        y98 ~ normal(mean1, 0.1)
    elseif z98 == 2
        y98 ~ normal(mean2, 0.1)
    else
        y98 ~ normal(mean3, 0.1)
    end

    if z99 == 1
        y99 ~ normal(mean1, 0.1)
    elseif z99 == 2
        y99 ~ normal(mean2, 0.1)
    else
        y99 ~ normal(mean3, 0.1)
    end

    if z100 == 1
        y100 ~ normal(mean1, 0.1)
    elseif z100 == 2
        y100 ~ normal(mean2, 0.1)
    else
        y100 ~ normal(mean3, 0.1)
    end


end