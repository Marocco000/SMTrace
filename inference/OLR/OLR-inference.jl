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

include(joinpath("..", "..", "julie", "mh_tracker.jl"))


#Plotting
using Plots
using Statistics
path = joinpath( "regression_viz.jl")
include(path)

# # Plots and results_dir
# results_dir = joinpath(pwd(), "inference", "OLR", "res/")


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
        outlier = rand()
        if outlier < prob_outlier
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

    for i=1:length(ys)
        yi = QuoteNode(Symbol(:y, i))
        constraints[eval(yi)] = ys[i]
    end

    constraints
end;


"""Creates data and observations"""
function get_data_and_observations()

    println(20)
    #Generate synthetic data
    (xs, ys) = make_synthetic_dataset(20);
    
    #Pack data (parameter for the inference procedure)
    data = [xs]

    #Create observations
    observations = make_constraints(ys)
    return (data, observations)
end


# """Performs a Gaussian drift over the trace returned by the SMT solver"""
# function smt_and_gaussian_drift()
#     # SMT trace as warm start
#     init_trace = ransac_smt(observations, ppfile, false) #TODO (observations are not done here, for now they are hacked in as constants in the ppmodel)
    
#     # #Gaussian drift over the smt trace 
#     # (init_trace, did_accept) = mh(init_trace, line_proposal, ())

#     init_trace
# end

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
    
    tracker = new_tracker()
 
    # Initial guess
    if infer_flavor.warm_start
        # Warm start using the SMT trace
        # init_trace = smt_and_gaussian_drift()
        init_trace = ransac_smt(observations, ppfile, false)
        # init_trace = reuse_warm_start()

        update!(tracker, get_score(init_trace), false, true)
        gaussian_drift_resources = infer_flavor.gaussian_drift_res

    else 
        #Random start
        (init_trace, _) = generate(ppmodel, (),  observations)
        update!(tracker, get_score(init_trace), false, true)

        gaussian_drift_resources = 0
    end
    tr = deepcopy(init_trace)
    
    println("Initial score: $(get_score(init_trace))")

    # block resimulation
    mh_steps_cap = 2000

    rejects = 0 
    # Sample iterations
    while tracker.mh_steps <= mh_steps_cap
        println("rejects : $rejects")
        jump_condition = rejects > 5
        if infer_flavor.warm_jump && jump_condition#TODO add frequency j%infer_flavor.warm_jump_frequency == 0
            #Perform warm jump (fully with diversity or for random block)
            # if j == 2
            #     params = select(:outlier1)
            # else
            params = select( :slope, :intercept) #reintroduce noise here TODO
            # end

            # tr_try = block_smt(params, tr, observations, ppfile) #TODO: pass ppfile
            tr_try = score_improve_smt(tr, observations, ppfile)

            if tr_try === nothing
                # try again or bail?
                # iter+=1
                jumpsucc!(tracker, "unsat")
            else 

                score_before = get_score(tr)
                score_smt = get_score(tr_try)
                accept_SMT_jump = score_smt > score_before
                if accept_SMT_jump
                    tr = tr_try
                    #reset gaussian drift resources
                    gaussian_drift_resources = infer_flavor.gaussian_drift_res
                    update!(tracker, get_score(tr), false, true)        
                    gaussian_drift_resources = infer_flavor.gaussian_drift_res # reset resources after smt jump

                    jumpsucc!(tracker, "accept")
                else
                    jumpsucc!(tracker, "reject")
                end

            end
        end
        rejects = 0
        if (infer_flavor.warm_jump || infer_flavor.warm_start) && gaussian_drift_resources > 0
            #Gaussian drift phase 

            (tr, a) = mh(tr, line_proposal, ())
            update!(tracker, get_score(tr), true, false)
            accepted!(tracker, a)
            gaussian_drift_resources -= 1
            
            for i=1:100 #TODO not hardcoded
                outlier_i = QuoteNode(Symbol(:outlier, i))
                selection = select(eval(outlier_i))
                
                # normal resample
                (tr, a) = mh(tr, selection) 
                update!(tracker, get_score(tr), false, false)

                #drift resample of bernoulli
                # latent = eval(outlier_i)
                # (tr, a) = mh(tr, bernoulli_outlier_proposal, (latent,) )
                # update!(tracker, get_score(tr), true, false)

                accepted!(tracker, a)
                # gaussian_drift_resources -= 1
            end

            (tr, a) = mh(tr, select(:proboutlier))
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)

        else
            # Standard inference

            #Block 1: Update the line's parameters
            line_params = select( :slope, :intercept) #reintroduce noise here TODO
            (tr, a) = mh(tr, line_params)

            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)
            rejects += (!a ? 1 : 0)

            # Blocks 2-N+1: Update the outlier classifications
            # (xs,) = get_args(tr)
            # n = length(xs)
            for i=1:100 #TODO not hardcoded
                outlier_i = QuoteNode(Symbol(:outlier, i))
                selection = select(eval(outlier_i))
                (tr, a) = mh(tr, selection)
                update!(tracker, get_score(tr), false, false)
                accepted!(tracker, a)
                rejects += (!a ? 1 : 0)
            end
            
            # Block N+2: Update the prob_outlier parameter
            (tr, a) = mh(tr, select(:proboutlier))
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)
            rejects += (!a ? 1 : 0)

        end
    end

    # Plots 
    # plot_line(infer_flavor, init_trace, tr, tr)
    # plot_score_progression(infer_flavor, scores)
    #Cap scores at 2000 mh steps
    trim!(tracker, mh_steps_cap)

    return tracker
end

function plot_line(infer_flavor, init_trace, tr, besttr)
    plot_name = inference_flavor_name(infer_flavor)

    # Plot intial trace, last and best
    p = Plots.plot([visualize_trace(init_trace, title="SMT (init) trace"), 
                visualize_trace(tr, title="last trace"), 
                visualize_trace(besttr, title="best trace")
                ]...)
    savefig(p, RESULTS_DIR[] *"OLR-$plot_name.png")

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

@gen function line_proposal(current_trace)
    slope ~ normal(current_trace[:slope], 0.1)
    intercept ~ normal(current_trace[:intercept],0.1)
end

@gen function slope_proposal(current_trace)
    slope ~ normal(current_trace[:slope], 0.01)
end

@gen function intercept_proposal(current_trace)
    intercept ~ normal(current_trace[:intercept],0.01)
end

@gen function bernoulli_outlier_proposal(current_trace, latent)
    p = current_trace[latent] ? 0.8 : 0.3
    @trace(bernoulli(p), latent)
end    

