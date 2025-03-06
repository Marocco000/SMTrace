# Linear regression model with outliers 
using Gen

ppfile = "OLR-model.jl"
include(ppfile) # the ppmodel TODO pass the name of the ppmodel function instead of always naming it ppmodel

path = joinpath("..", "teste.jl")
include(path) 

#Plotting
using Plots
path = joinpath("..", "regression_viz.jl")
include(path)

## DATA
#1388888888888889/1250000000000000

# data (params and observations)
function make_synthetic_dataset(n)
    Random.seed!(1)
    prob_outlier = 0.2
    true_inlier_noise = 0.5
    true_outlier_noise = 5.0
    true_slope = -1
    true_intercept = 2
    xs = collect(range(-5, stop=5, length=n))
    ys = Float64[]
    for (i, x) in enumerate(xs)
        if rand() < prob_outlier
            y = randn() * true_outlier_noise
        else
            y = true_slope * x + true_intercept + randn() * true_inlier_noise
        end
        push!(ys, y)
    end
    (xs, ys)
end
    


function make_constraints(ys::Vector{Float64})
    constraints = Gen.choicemap()
    # for i=1:length(ys)
    #     constraints[:data => i => :y] = ys[i]
    # end

    for i=1:length(ys)
        yi = QuoteNode(Symbol(:y, i))
        constraints[eval(yi)] = ys[i]
    end

    #linear regression observations TODO howwww
    # TODO: again problem with geenrating code, i need the name and ref to the address
    # for i = 1:lenght(ys)
    #     constraints[yi]
    # end

        #     y1 = 2.6573837689159814
    #     y2 = 7.702179877517962
    #     y3 = 6.081150630367074
    #     y4 = 5.008042235619298
    #     y5 = 4.730169919177062
    #     y6 = 4.959542404331658
    #     y7 = 3.8408261728807407
    #     y8 = 3.581811690993659
    #     y9 = 0.10122966946595927
    #     y10 = 2.3093030917112363
    #     y11 = 1.114208947120075
    #     y12 = 1.579562816549691
    #     y13 = 1.460511864881077
    #     y14 = 1.2188854648088319
    #     y15 = -1.0634788926558225
    #     y16 = -1.1333844328209919
    #     y17 = -0.6478476691012588
    #     y18 = -1.7134940283536377
    #     y19 = 2.9220620949510896
    #     y20 = -7.992466952018953

    constraints
end;



function inference_over_LR_with_outliers(xs)
    print("\033c") # clean terminal log
    # Warm start: Get SMT trace as initial state 
    init_trace = ransac_smt(observations, ppfile, false) #TODO (observations are not done here, for now they are hacked in as constants in the ppmodel)
    
    #Random start
    # (init_trace, _) = generate(ppmodel, (),  observations)

    println("Initial score: $(get_score(init_trace))")
    # println(get_choices(init_trace))
    #prev LR model
    # intercept = 6758822414725939/5000000000000000
    # slope = -1345506026865873/1562500000000000  
    # score: -24.205867303903318

    #for zero outliers and same LR model
    # intercept = 4258822414725939/5000000000000000
    # slope = -1501756026865873/1562500000000000
    # score: -37.87954778712651

    #LATEST??
    # intercept = 5/4
    # slope = -119/64



    tr = init_trace #TODO abs trash as it is not considering modifying the outlier/outlier prob
    besttr = tr
    bestscore = get_score(tr)

    xs = collect(range(-5, stop=5, length=10))

    block_smt_active = false

    for j=1:10
        # Block 1: Update the line's parameters
        line_params = select( :slope, :intercept) #reintroduce noise here TODO
        (tr, _) = mh(tr, line_params)

        if block_smt_active && j%7 == 0
            tr = block_smt(line_params, tr, observations, ppfile) #TODO: pass ppfile
        end

        # Blocks 2-N+1: Update the outlier classifications
        # (xs,) = get_args(tr)
        # n = length(xs)

        for i=1:20
            yi = QuoteNode(Symbol(:outlier, i))
            selection = select(eval(yi))

            #block smt 
            if block_smt_active && j%7 == 0 && i%7 == 0
                tr = block_smt(selection, tr, observations, ppfile)
            end
        end
        
        # Block N+2: Update the prob_outlier parameter
        (tr, _) = mh(tr, select(:proboutlier))
        if block_smt_active && j %7 == 0
            tr = block_smt(select(:proboutlier), tr, observations, ppfile)
        end


        if get_score(tr) > bestscore
            bestscore = get_score(tr)
            besttr = tr
        end
    end
        # Return the updated trace
    # tr

    # Plot intial trace, last and best
    p = Plots.plot([visualize_trace(init_trace, title="SMT (init) trace"), 
                visualize_trace(tr, title="last trace"), 
                visualize_trace(besttr, title="best trace")
                ]...)
    savefig(p, "DEMO2-OLR-WARM-START-5Resim-noise-set.png")
    p
end



(xs, ys) = make_synthetic_dataset(20);
# print("SYNTH DATA")
# println(xs)
# println(ys)

observations = make_constraints(ys)

inference_over_LR_with_outliers(xs)

