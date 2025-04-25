# Linear regression model with outliers 
using Gen

ppfile = "OLR-model.jl"
include(ppfile) # the ppmodel TODO pass the name of the ppmodel function instead of always naming it ppmodel
ppfile = "OLR/OLR-model.jl"

path = joinpath("..","..", "teste.jl")
include(path) 

smt_infrnc_path = joinpath("..", "..", "julie", "inference-smt.jl")
include(smt_infrnc_path)

logg = joinpath("..", "..", "julie", "logging.jl")
include(logg)

bench = joinpath("..", "..", "julie", "benchmarking.jl")
include(bench)

#Plotting
using Plots
using Statistics
path = joinpath( "regression_viz.jl")
include(path)

# Plots and results_dir
results_dir = joinpath(pwd(), "inference", "OLR", "res/")


## DATA

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


"""Creates data and observations"""
function get_data_and_observations()

    #Generate synthetic data
    (xs, ys) = make_synthetic_dataset(20);
    
    #Pack data (parameter for the inference procedure)
    data = [xs]

    #Create observations
    observations = make_constraints(ys)
    return (data, observations)
end


@gen function line_proposal(current_trace)
    # Since SMT trace is pretty good, propose small changes, adapt noise 
    slope ~ normal(current_trace[:slope], 0.01)
    intercept ~ normal(current_trace[:intercept],0.01)
end;

"""Performs a Gaussian drift over the trace returned by the SMT solver"""
function smt_and_gaussian_drift()
    # SMT trace as warm start
    init_trace = ransac_smt(observations, ppfile, false) #TODO (observations are not done here, for now they are hacked in as constants in the ppmodel)
    
    #Gaussian drift over the smt trace 
    (init_trace, did_accept) = mh(init_trace, line_proposal, ())

    init_trace
end

"""Inference method for the OLR model"""
function inference(data, infer_flavor::Inference_flavor, iter = 10)
    # Unpack data
    xs = data[1]

    # Call inference function
    inference_over_LR_with_outliers(xs, infer_flavor, iter)
end

"""
Inference function
    Arguments

    if warm_start = true the initial guess would be the SMT trace, otherwise a random guess
    - `gaussian_drift_resource::Int`: after a warm-jump or warm-start prefer gaussian drift moves for # of steps
"""
function inference_over_LR_with_outliers(xs, infer_flavor::Inference_flavor, iter = 10)
    
    scores = []# trace scores for plot 
    is_a_jump = []

    current_gaussian_resources = 0

    # Initial guess
    if infer_flavor.warm_start
        # Warm start using the SMT trace
        init_trace = smt_and_gaussian_drift()
        push!(is_a_jump, true)
        current_gaussian_resources = infer_flavor.gaussian_drift_res

    else 
        #Random start
        (init_trace, _) = generate(ppmodel, (),  observations)
        push!(is_a_jump, false)
    end
    tr = deepcopy(init_trace)


    
    push!(scores, get_score(init_trace))
    println("Initial score: $(get_score(init_trace))")

    besttr = tr
    bestscore = get_score(tr)

    # for j=1:50
    #     #Gaussian drift over the smt trace 
    #     (init_trace, did_accept) = mh(init_trace, line_proposal, ())
    #     log_trace(scores, tr, besttr)
    # end

    # block resimulation
    for j=1:iter
      
        if infer_flavor.warm_jump && (j == 2 || j == 4)#%7 == 0 #TODO add frequency j%infer_flavor.warm_jump_frequency == 0
            #Perform warm jump (fully with diversity or for random block)
            # if j == 2
            #     params = select(:outlier1)
            # else
            params = select( :slope, :intercept) #reintroduce noise here TODO
            # end

            tr_try = block_smt(params, tr, observations, ppfile) #TODO: pass ppfile
            if tr_try === nothing
                # try again or bail?
                iter+=1
            else 
                tr = tr_try
                #reset gaussian drift resources
                current_gaussian_resources = infer_flavor.gaussian_drift_res

                log_trace(scores, tr, besttr)
                #mark as warm_jump
                push!(is_a_jump, true)
            end
        else 
            # Block 1: Update the line's parameters
            line_params = select( :slope, :intercept) #reintroduce noise here TODO
            
            if  current_gaussian_resources  > 0 && (infer_flavor.warm_start || infer_flavor.warm_jump)
                (tr, did_accept) = mh(tr, line_proposal, ())
                current_gaussian_resources -= 1

            else
                (tr, _) = mh(tr, line_params)
            end
            
            log_trace(scores, tr, besttr)
            push!(is_a_jump, false)

           

            # Blocks 2-N+1: Update the outlier classifications
            # (xs,) = get_args(tr)
            # n = length(xs)
            for i=1:20
                yi = QuoteNode(Symbol(:outlier, i))
                selection = select(eval(yi))
                (tr, _) = mh(tr, selection)
                log_trace(scores, tr, besttr)
                push!(is_a_jump, false)

                #block smt TODO this should have a fast result as its a bernoulli choice, check this
                # if infer_flavor.warm_jump && j%7 == 0 && i%7 == 0
                #     tr = block_smt(selection, tr, observations, ppfile)
                    
                # end
            end
            
            # Block N+2: Update the prob_outlier parameter
            (tr, _) = mh(tr, select(:proboutlier))
            log_trace(scores, tr, besttr)
            push!(is_a_jump, false)


        end


        if get_score(tr) > bestscore
            bestscore = get_score(tr)
            besttr = deepcopy(tr)
        end
    end

    # Plots 
    # plot_line(infer_flavor, init_trace, tr, besttr)
    # plot_score_progression(infer_flavor, scores)

    println("last score $(scores[end])")
    
    # println("JUMPS")
    # println(is_a_jump)
    return (scores, is_a_jump)
end

function plot_line(infer_flavor, init_trace, tr, besttr)
    plot_name = inference_flavor_name(infer_flavor)

    # Plot intial trace, last and best
    p = Plots.plot([visualize_trace(init_trace, title="SMT (init) trace"), 
                visualize_trace(tr, title="last trace"), 
                visualize_trace(besttr, title="best trace")
                ]...)
    savefig(p, results_dir *"OLR-$plot_name.png")

    # p = Plots.plot([visualize_trace(init_trace, title="SMT (init) trace"), 
    #         visualize_trace(tr, title="last trace")
    #         ]...)

end

function plot_score_progression(infer_flavor, scores)
    plot_name = inference_flavor_name(infer_flavor)

    min_y = min(minimum(scores), 0)
    max_y = max(maximum(scores), 0)

    scoring_plot = plot(1:length(scores), scores, 
     title=plot_name, 
     xlabel="Sample Index", 
     ylabel="Score", 
     legend=false,
     marker=:circle,
     linewidth=2,
     ylims = (min_y, max_y))

    savefig(scoring_plot, results_dir *"score-"*plot_name)

end

