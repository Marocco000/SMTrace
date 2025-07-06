@gen function ppmodel()

    sigmaxstate ~ uniform(0.1, 1.0)
    sigmaxdistrict ~ uniform(0.1, 1.0)
    sigmaxtype ~ uniform(0.1, 1.0)

    betaxbaseline ~ normal(1, 50)


    betaxstate1 ~ normal(0, sigmaxstate)
    betaxstate2 ~ normal(0, sigmaxstate)
    betaxstate3 ~ normal(0, sigmaxstate)
    betaxstate4 ~ normal(0, sigmaxstate)


    betaxdistrict1To1 ~ normal(0, sigmaxdistrict)
    betaxdistrict1To2 ~ normal(0, sigmaxdistrict)
    betaxdistrict2To1 ~ normal(0, sigmaxdistrict)
    betaxdistrict2To2 ~ normal(0, sigmaxdistrict)
    betaxdistrict3To1 ~ normal(0, sigmaxdistrict)
    betaxdistrict3To2 ~ normal(0, sigmaxdistrict)
    betaxdistrict4To1 ~ normal(0, sigmaxdistrict)
    betaxdistrict4To2 ~ normal(0, sigmaxdistrict)


    betaxtype1 ~ normal(0, sigmaxtype)
    betaxtype2 ~ normal(0, sigmaxtype)
    betaxtype3 ~ normal(0, sigmaxtype)
    betaxtype4 ~ normal(0, sigmaxtype)
    betaxtype5 ~ normal(0, sigmaxtype)


    yhat1 =  betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype4
    sigma1 ~ uniform(0.5, 1.5)
    y1 ~ normal(yhat1, sigma1)

    yhat2 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype1
    sigma2 ~ uniform(0.5, 1.5)
    y2 ~ normal(yhat2, sigma2)

    yhat3 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype4
    sigma3 ~ uniform(0.5, 1.5)
    y3 ~ normal(yhat3, sigma3)

    yhat4 = betaxbaseline + betaxstate1
            + betaxdistrict1To2
            + betaxtype3
    sigma4 ~ uniform(0.5, 1.5)
    y4 ~ normal(yhat4, sigma4)

    yhat5 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype3
    sigma5 ~ uniform(0.5, 1.5)
    y5 ~ normal(yhat5, sigma5)

    yhat6 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype1
    sigma6 ~ uniform(0.5, 1.5)
    y6 ~ normal(yhat6, sigma6)

    yhat7 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype3
    sigma7 ~ uniform(0.5, 1.5)
    y7 ~ normal(yhat7, sigma7)

    yhat8 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype5
    sigma8 ~ uniform(0.5, 1.5)
    y8 ~ normal(yhat8, sigma8)

    yhat9 = betaxbaseline + betaxstate2
            + betaxdistrict2To2
            + betaxtype2
    sigma9 ~ uniform(0.5, 1.5)
    y9 ~ normal(yhat9, sigma9)

    yhat10 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype4
    sigma10 ~ uniform(0.5, 1.5)
    y10 ~ normal(yhat10, sigma10)

    yhat11 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype5
    sigma11 ~ uniform(0.5, 1.5)
    y11 ~ normal(yhat11, sigma11)

    yhat12 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype4
    sigma12 ~ uniform(0.5, 1.5)
    y12 ~ normal(yhat12, sigma12)

    yhat13 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype1
    sigma13 ~ uniform(0.5, 1.5)
    y13 ~ normal(yhat13, sigma13)

    yhat14 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype3
    sigma14 ~ uniform(0.5, 1.5)
    y14 ~ normal(yhat14, sigma14)

    yhat15 = betaxbaseline + betaxstate4
            + betaxdistrict4To1
            + betaxtype3
    sigma15 ~ uniform(0.5, 1.5)
    y15 ~ normal(yhat15, sigma15)

    yhat16 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype5
    sigma16 ~ uniform(0.5, 1.5)
    y16 ~ normal(yhat16, sigma16)

    yhat17 = betaxbaseline + betaxstate2
            + betaxdistrict2To2
            + betaxtype4
    sigma17 ~ uniform(0.5, 1.5)
    y17 ~ normal(yhat17, sigma17)

    yhat18 = betaxbaseline + betaxstate1
            + betaxdistrict1To2
            + betaxtype1
    sigma18 ~ uniform(0.5, 1.5)
    y18 ~ normal(yhat18, sigma18)

    yhat19 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype4
    sigma19 ~ uniform(0.5, 1.5)
    y19 ~ normal(yhat19, sigma19)

    yhat20 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype5
    sigma20 ~ uniform(0.5, 1.5)
    y20 ~ normal(yhat20, sigma20)

    yhat21 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype1
    sigma21 ~ uniform(0.5, 1.5)
    y21 ~ normal(yhat21, sigma21)

    yhat22 = betaxbaseline + betaxstate2
            + betaxdistrict2To2
            + betaxtype4
    sigma22 ~ uniform(0.5, 1.5)
    y22 ~ normal(yhat22, sigma22)

    yhat23 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype2
    sigma23 ~ uniform(0.5, 1.5)
    y23 ~ normal(yhat23, sigma23)

    yhat24 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype4
    sigma24 ~ uniform(0.5, 1.5)
    y24 ~ normal(yhat24, sigma24)

    yhat25 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype4
    sigma25 ~ uniform(0.5, 1.5)
    y25 ~ normal(yhat25, sigma25)

    yhat26 = betaxbaseline + betaxstate4
            + betaxdistrict4To1
            + betaxtype5
    sigma26 ~ uniform(0.5, 1.5)
    y26 ~ normal(yhat26, sigma26)

    yhat27 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype2
    sigma27 ~ uniform(0.5, 1.5)
    y27 ~ normal(yhat27, sigma27)

    yhat28 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype2
    sigma28 ~ uniform(0.5, 1.5)
    y28 ~ normal(yhat28, sigma28)

    yhat29 = betaxbaseline + betaxstate1
            + betaxdistrict1To2
            + betaxtype2
    sigma29 ~ uniform(0.5, 1.5)
    y29 ~ normal(yhat29, sigma29)

    yhat30 = betaxbaseline + betaxstate4
            + betaxdistrict4To1
            + betaxtype3
    sigma30 ~ uniform(0.5, 1.5)
    y30 ~ normal(yhat30, sigma30)

    yhat31 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype5
    sigma31 ~ uniform(0.5, 1.5)
    y31 ~ normal(yhat31, sigma31)

    yhat32 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype5
    sigma32 ~ uniform(0.5, 1.5)
    y32 ~ normal(yhat32, sigma32)

    yhat33 = betaxbaseline + betaxstate2
            + betaxdistrict2To2
            + betaxtype5
    sigma33 ~ uniform(0.5, 1.5)
    y33 ~ normal(yhat33, sigma33)

    yhat34 = betaxbaseline + betaxstate4
            + betaxdistrict4To1
            + betaxtype4
    sigma34 ~ uniform(0.5, 1.5)
    y34 ~ normal(yhat34, sigma34)

    yhat35 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype2
    sigma35 ~ uniform(0.5, 1.5)
    y35 ~ normal(yhat35, sigma35)

    yhat36 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype5
    sigma36 ~ uniform(0.5, 1.5)
    y36 ~ normal(yhat36, sigma36)

    yhat37 = betaxbaseline + betaxstate4
            + betaxdistrict4To1
            + betaxtype1
    sigma37 ~ uniform(0.5, 1.5)
    y37 ~ normal(yhat37, sigma37)

    yhat38 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype3
    sigma38 ~ uniform(0.5, 1.5)
    y38 ~ normal(yhat38, sigma38)

    yhat39 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype1
    sigma39 ~ uniform(0.5, 1.5)
    y39 ~ normal(yhat39, sigma39)

    yhat40 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype2
    sigma40 ~ uniform(0.5, 1.5)
    y40 ~ normal(yhat40, sigma40)

    yhat41 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype1
    sigma41 ~ uniform(0.5, 1.5)
    y41 ~ normal(yhat41, sigma41)

    yhat42 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype3
    sigma42 ~ uniform(0.5, 1.5)
    y42 ~ normal(yhat42, sigma42)

    yhat43 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype5
    sigma43 ~ uniform(0.5, 1.5)
    y43 ~ normal(yhat43, sigma43)

    yhat44 = betaxbaseline + betaxstate1
            + betaxdistrict1To2
            + betaxtype1
    sigma44 ~ uniform(0.5, 1.5)
    y44 ~ normal(yhat44, sigma44)

    yhat45 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype1
    sigma45 ~ uniform(0.5, 1.5)
    y45 ~ normal(yhat45, sigma45)

    yhat46 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype5
    sigma46 ~ uniform(0.5, 1.5)
    y46 ~ normal(yhat46, sigma46)

    yhat47 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype3
    sigma47 ~ uniform(0.5, 1.5)
    y47 ~ normal(yhat47, sigma47)

    yhat48 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype1
    sigma48 ~ uniform(0.5, 1.5)
    y48 ~ normal(yhat48, sigma48)

    yhat49 = betaxbaseline + betaxstate1
            + betaxdistrict1To2
            + betaxtype3
    sigma49 ~ uniform(0.5, 1.5)
    y49 ~ normal(yhat49, sigma49)

    yhat50 = betaxbaseline + betaxstate2
            + betaxdistrict2To2
            + betaxtype1
    sigma50 ~ uniform(0.5, 1.5)
    y50 ~ normal(yhat50, sigma50)

    yhat51 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype4
    sigma51 ~ uniform(0.5, 1.5)
    y51 ~ normal(yhat51, sigma51)

    yhat52 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype2
    sigma52 ~ uniform(0.5, 1.5)
    y52 ~ normal(yhat52, sigma52)

    yhat53 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype5
    sigma53 ~ uniform(0.5, 1.5)
    y53 ~ normal(yhat53, sigma53)

    yhat54 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype5
    sigma54 ~ uniform(0.5, 1.5)
    y54 ~ normal(yhat54, sigma54)

    yhat55 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype1
    sigma55 ~ uniform(0.5, 1.5)
    y55 ~ normal(yhat55, sigma55)

    yhat56 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype5
    sigma56 ~ uniform(0.5, 1.5)
    y56 ~ normal(yhat56, sigma56)

    yhat57 = betaxbaseline + betaxstate2
            + betaxdistrict2To2
            + betaxtype4
    sigma57 ~ uniform(0.5, 1.5)
    y57 ~ normal(yhat57, sigma57)

    yhat58 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype1
    sigma58 ~ uniform(0.5, 1.5)
    y58 ~ normal(yhat58, sigma58)

    yhat59 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype3
    sigma59 ~ uniform(0.5, 1.5)
    y59 ~ normal(yhat59, sigma59)

    yhat60 = betaxbaseline + betaxstate4
            + betaxdistrict4To1
            + betaxtype2
    sigma60 ~ uniform(0.5, 1.5)
    y60 ~ normal(yhat60, sigma60)

    yhat61 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype5
    sigma61 ~ uniform(0.5, 1.5)
    y61 ~ normal(yhat61, sigma61)

    yhat62 = betaxbaseline + betaxstate4
            + betaxdistrict4To1
            + betaxtype1
    sigma62 ~ uniform(0.5, 1.5)
    y62 ~ normal(yhat62, sigma62)

    yhat63 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype2
    sigma63 ~ uniform(0.5, 1.5)
    y63 ~ normal(yhat63, sigma63)

    yhat64 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype1
    sigma64 ~ uniform(0.5, 1.5)
    y64 ~ normal(yhat64, sigma64)

    yhat65 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype5
    sigma65 ~ uniform(0.5, 1.5)
    y65 ~ normal(yhat65, sigma65)

    yhat66 = betaxbaseline + betaxstate4
            + betaxdistrict4To1
            + betaxtype2
    sigma66 ~ uniform(0.5, 1.5)
    y66 ~ normal(yhat66, sigma66)

    yhat67 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype5
    sigma67 ~ uniform(0.5, 1.5)
    y67 ~ normal(yhat67, sigma67)

    yhat68 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype4
    sigma68 ~ uniform(0.5, 1.5)
    y68 ~ normal(yhat68, sigma68)

    yhat69 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype2
    sigma69 ~ uniform(0.5, 1.5)
    y69 ~ normal(yhat69, sigma69)

    yhat70 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype5
    sigma70 ~ uniform(0.5, 1.5)
    y70 ~ normal(yhat70, sigma70)

    yhat71 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype5
    sigma71 ~ uniform(0.5, 1.5)
    y71 ~ normal(yhat71, sigma71)

    yhat72 = betaxbaseline + betaxstate4
            + betaxdistrict4To1
            + betaxtype3
    sigma72 ~ uniform(0.5, 1.5)
    y72 ~ normal(yhat72, sigma72)

    yhat73 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype3
    sigma73 ~ uniform(0.5, 1.5)
    y73 ~ normal(yhat73, sigma73)

    yhat74 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype1
    sigma74 ~ uniform(0.5, 1.5)
    y74 ~ normal(yhat74, sigma74)

    yhat75 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype2
    sigma75 ~ uniform(0.5, 1.5)
    y75 ~ normal(yhat75, sigma75)

    yhat76 = betaxbaseline + betaxstate2
            + betaxdistrict2To2
            + betaxtype4
    sigma76 ~ uniform(0.5, 1.5)
    y76 ~ normal(yhat76, sigma76)

    yhat77 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype4
    sigma77 ~ uniform(0.5, 1.5)
    y77 ~ normal(yhat77, sigma77)

    yhat78 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype2
    sigma78 ~ uniform(0.5, 1.5)
    y78 ~ normal(yhat78, sigma78)

    yhat79 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype3
    sigma79 ~ uniform(0.5, 1.5)
    y79 ~ normal(yhat79, sigma79)

    yhat80 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype4
    sigma80 ~ uniform(0.5, 1.5)
    y80 ~ normal(yhat80, sigma80)

    yhat81 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype4
    sigma81 ~ uniform(0.5, 1.5)
    y81 ~ normal(yhat81, sigma81)

    yhat82 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype4
    sigma82 ~ uniform(0.5, 1.5)
    y82 ~ normal(yhat82, sigma82)

    yhat83 = betaxbaseline + betaxstate4
            + betaxdistrict4To2
            + betaxtype2
    sigma83 ~ uniform(0.5, 1.5)
    y83 ~ normal(yhat83, sigma83)

    yhat84 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype1
    sigma84 ~ uniform(0.5, 1.5)
    y84 ~ normal(yhat84, sigma84)

    yhat85 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype1
    sigma85 ~ uniform(0.5, 1.5)
    y85 ~ normal(yhat85, sigma85)

    yhat86 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype2
    sigma86 ~ uniform(0.5, 1.5)
    y86 ~ normal(yhat86, sigma86)

    yhat87 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype3
    sigma87 ~ uniform(0.5, 1.5)
    y87 ~ normal(yhat87, sigma87)

    yhat88 = betaxbaseline + betaxstate2
            + betaxdistrict2To2
            + betaxtype1
    sigma88 ~ uniform(0.5, 1.5)
    y88 ~ normal(yhat88, sigma88)

    yhat89 = betaxbaseline + betaxstate4
            + betaxdistrict4To1
            + betaxtype3
    sigma89 ~ uniform(0.5, 1.5)
    y89 ~ normal(yhat89, sigma89)

    yhat90 = betaxbaseline + betaxstate4
            + betaxdistrict4To1
            + betaxtype4
    sigma90 ~ uniform(0.5, 1.5)
    y90 ~ normal(yhat90, sigma90)

    yhat91 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype5
    sigma91 ~ uniform(0.5, 1.5)
    y91 ~ normal(yhat91, sigma91)

    yhat92 = betaxbaseline + betaxstate1
            + betaxdistrict1To2
            + betaxtype1
    sigma92 ~ uniform(0.5, 1.5)
    y92 ~ normal(yhat92, sigma92)

    yhat93 = betaxbaseline + betaxstate2
            + betaxdistrict2To2
            + betaxtype5
    sigma93 ~ uniform(0.5, 1.5)
    y93 ~ normal(yhat93, sigma93)

    yhat94 = betaxbaseline + betaxstate2
            + betaxdistrict2To1
            + betaxtype2
    sigma94 ~ uniform(0.5, 1.5)
    y94 ~ normal(yhat94, sigma94)

    yhat95 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype3
    sigma95 ~ uniform(0.5, 1.5)
    y95 ~ normal(yhat95, sigma95)

    yhat96 = betaxbaseline + betaxstate1
            + betaxdistrict1To1
            + betaxtype4
    sigma96 ~ uniform(0.5, 1.5)
    y96 ~ normal(yhat96, sigma96)

    yhat97 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype2
    sigma97 ~ uniform(0.5, 1.5)
    y97 ~ normal(yhat97, sigma97)

    yhat98 = betaxbaseline + betaxstate3
            + betaxdistrict3To1
            + betaxtype5
    sigma98 ~ uniform(0.5, 1.5)
    y98 ~ normal(yhat98, sigma98)

    yhat99 = betaxbaseline + betaxstate2
            + betaxdistrict2To2
            + betaxtype2
    sigma99 ~ uniform(0.5, 1.5)
    y99 ~ normal(yhat99, sigma99)

    yhat100 = betaxbaseline + betaxstate3
            + betaxdistrict3To2
            + betaxtype1
    sigma100 ~ uniform(0.5, 1.5)
    y100 ~ normal(yhat100, sigma100)

end
#Addapted from
#source: https://github.com/facebookresearch/pplbench/blob/3023989cf05e96c3316046c40a9745f8628de5eb/pplbench/models/n_schools.py#L41
# """
# N Schools

# This is a generalization of a classical 8 schools model to n schools.
# The model posits that the effect of a school on a student's performance
# can be explained by the a baseline effect of all schools plus an additive
# effect of the state, the school district and the school type.

# Hyper Parameters:

#     n - total number of schools
#     num_states - number of states
#     num_districts_per_state - number of school districts in each state
#     num_types - number of school types
#     scale_state - state effect scale
#     scale_district - district effect scale
#     scale_type - school type effect scale

# Model:


#     beta_baseline = StudentT(dof_baseline, 0.0, scale_baseline)

#     sigma_state ~ HalfCauchy(0, scale_state)

#     sigma_district ~ HalfCauchy(0, scale_district)

#     sigma_type ~ HalfCauchy(0, scale_type)

#     for s in 0 .. num_states - 1
#         beta_state[s] ~ Normal(0, sigma_state)

#         for d in 0 .. num_districts_per_state - 1
#             beta_district[s, d] ~ Normal(0, sigma_district)

#     for t in 0 .. num_types - 1
#         beta_type[t] ~ Normal(0, sigma_type)

#     for i in 0 ... n - 1
#         Assume we are given state[i], district[i], type[i]

#         Y_hat[i] = beta_baseline + beta_state[state[i]]
#                     + beta_district[state[i], district[i]]
#                     + beta_type[type[i]]

#         sigma[i] ~ Uniform(0.5, 1.5)

#         Y[i] ~ Normal(Y_hat[i], sigma[i])

# The dataset consists of the following

#     Y[school]         - float
#     sigma[school]     - float

# and it includes the attributes

#     n  - number of schools
#     num_states
#     num_districts_per_state
#     num_types
#     dof_baseline
#     scale_baseline
#     scale_state
#     scale_district
#     scale_type
#     state_idx[school]     - 0 .. num_states - 1
#     district_idx[school]  - 0 .. num_districts_per_state - 1
#     type_idx[school]      - 0 .. num_types - 1

# The posterior samples include the following,

#     sigma_state[draw]                    - float
#     sigma_district[draw]                 - float
#     sigma_type[draw]                     - float
#     beta_baseline[draw]                  - float
#     beta_state[draw, state]              - float
#     beta_district[draw, state, district] - float
#     beta_type[draw, type]                - float
# """