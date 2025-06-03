
include( "inference-smt.jl")

"""Tracking various information during """
Base.@kwdef mutable struct Tracking
    scores::Vector{Float64} = []
    jumps::Vector{Bool} = []
end

using .FlavorConfig



"""Runs benchmarking comparison for warm-start and random_start inference"""
function compare_warm_start_to_random_start(inference, data)
    rand_start = Inference_flavor()
    warm_start = Inference_flavor(warm_start = true)
    inference_flavors = [rand_start, warm_start]

    benchmark_score_progression(inference, data, inference_flavors, 20, 100) #TODO 20, 50
end

"""Plots score progression for warm start and random start"""
function benchmark_score_progression(inference, data,  inference_flavors, burn_in=10, rounds=50)

    colors = [:orange, :blue, :green, :black, :red, :magenta] 
    combined_avg_scores_plot = plot(title="Score progression with 95% confidence interval", xlabel="Sample index", ylabel="Score")

    # Collect score progress for inference with different start flavors
    flavored_scores = []
    for (ii, flavor) in enumerate(inference_flavors) #Compare inference flavors

        Random.seed!() # Reset burn-in seed to random
        
        # Burn in time
        for j=1:burn_in
            inference(data, flavor)
        end

        # Runs inference algorithm #rounds times and collects score progression
        scores::Vector{Vector{Float64}} = [] # tracks score progress for each inference 
        for i=1:rounds
            Random.seed!(i)
            (scoring, _) = inference(data, flavor)

            push!(scores, scoring)

        end
        push!(flavored_scores, scores)


        
    end


    #PLOT

    # Plot individual and combined score progression (for each run)
    for i=1:rounds
        scores_rand = flavored_scores[1][i]
        scores_warm = flavored_scores[2][i]

        if !ispath(RESULTS_DIR[] * "figures/runpairs/$(i-1)")
            mkpath(RESULTS_DIR[] * "figures/runpairs/$(i-1)")
        end
        
        plot_individual_score_progression(scores_rand, inference_flavor_name(inference_flavors[1]), i, :blue) 
        plot_individual_score_progression(scores_warm, inference_flavor_name(inference_flavors[2]), i, :orange) #TODO plot gaussian drift

        plot_combined_score_progression(scores_rand, scores_warm, "rand-start baseline", "warm-start",  i)

    end

    #Plot individual and combined score progressions
    for (i, flavor) in enumerate(inference_flavors)
        plot_name = inference_flavor_name(flavor)
        scores = flavored_scores[i]
        score_matrix = hcat(scores...)'
    
        mean_vals = mean(score_matrix, dims=1) |> vec
        se_vals = std(score_matrix, dims=1) ./ sqrt(size(score_matrix, 1)) |> vec
        
        # print(scor# Confidence intervals (95%)
        ci_upper = mean_vals .+ 1.96 .* se_vals
        ci_lower = mean_vals .- 1.96 .* se_vals

        # Plot individual score progression for inference flavor
        pavg_individual = plot(mean_vals,
            ribbon=(mean_vals - ci_lower, ci_upper - mean_vals),
            label="Mean ± 95% CI" * plot_name,
            lw=2, fillalpha=0.3, color=colors[i], 
            xlabel="Sample index", ylabel="Score", title="Score Progression with 95% Confidence Interval")
        savefig(pavg_individual, RESULTS_DIR[] * "figures/" *"score-avg-progression-"*plot_name)
        
        #Plot score progression for comparison
        plot!(combined_avg_scores_plot, mean_vals,
            ribbon=(mean_vals - ci_lower, ci_upper - mean_vals),
            label="Mean ± 95% CI " * plot_name,
            lw=2, fillalpha=0.3, color=colors[i])
    end

    # TODO plot_progress_ratio()
    #Plotting options: 
    # - match and compare flavors with closest start point
    # - score progression comparison, +offset to shift away from negative values

    savefig(combined_avg_scores_plot, RESULTS_DIR[] * "figures/" * "score-avg-progression-combined-warm-vs-rand-start")

end

function plot_individual_score_progression(scores, plot_name, i, color)
                    
    min_y = min(minimum(scores), 0)
    max_y = max(maximum(scores), 0)

    scoring_plot = plot(1:length(scores), scores, 
        title=plot_name, 
        xlabel="Sample Index", 
        ylabel="Score", 
        legend=false,
        color=color, 
        marker=:circle,
        linewidth=2,
        ylims = (min_y, max_y))

    # x_jump = findall(jumps)
    # scatter!(x_jump, scores1[x_jump], 
    #     markershape=:circle, 
    #     markersize=8, 
    #     label="Jump", 
    #     color=:red)
    # println(plot_name)
    savefig(scoring_plot, RESULTS_DIR[] * "figures/" *"runpairs/$(i-1)/score-progression-"*plot_name*"$(i-1)")

end

function plot_combined_score_progression(scores1, scores2, name1, name2,  run)

    min_y = min(minimum(scores1), 0)
    min_y = min(minimum(scores2), min_y)
    max_y = max(maximum(scores1), 0)
    max_y = max(maximum(scores2), max_y)

    combined_score_progression = plot(1:length(scores1), scores1, 
        label=name1,
        marker=:circle,
        linewidth=2, 
        color=:blue)
    
    plot!(combined_score_progression, 1:length(scores2), scores2, 
        label=name2,
        marker=:circle,
        linewidth=2, 
        color=:orange)

    plot!(combined_score_progression,   
        title="Run$run",
        xlabel="Sample Index", 
        ylabel="Score", ylims = (min_y, max_y))

    savefig(combined_score_progression, RESULTS_DIR[] * "figures/runpairs/$(run-1)/" *"combined-score-progression-start"*"$run")
end


######################################################################################################################################################################

# """Runs benchmarking comparison for plain inference vs with warm-jumps"""
function compare_jumps_to_no_jumps(inference, data)
    with_jumps = Inference_flavor(warm_jump=true)
    plain = Inference_flavor()
    inference_flavors = [plain, with_jumps]
    # inference_flavors = [with_jumps]
    # benchmark_score_progression_with_jumps(inference, data, inference_flavors, 20, 50)
    benchmark_score_progression_with_jumps(inference, data, inference_flavors, 0, 1)#TODO do properly
end

function benchmark_score_progression_with_jumps(inference, data,  inference_flavors, burn_in=10, rounds=50)

    colors = [:orange, :blue, :green, :black, :red, :magenta] 
    combined_avg_scores_plot = plot(title="Score progression with 95% confidence interval", xlabel="Sample index", ylabel="Score")

    # Collect score progress for inference with different start flavors
    flavored_scores = []
    flavored_jumps = []
    for (ii, flavor) in enumerate(inference_flavors) #Compare inference flavors

        Random.seed!() # Reset burn-in seed to random
        
        # # Burn in time
        for i=1:burn_in
            inference(data, flavor)
        end

        # Runs inference algorithm #rounds times and collects score progression
        scores::Vector{Vector{Float64}} = [] # tracks score progress for each inference 
        jumps = []
        for i=1:rounds
            Random.seed!(i)
            (scoring, is_jump) = inference(data, flavor)

            push!(scores, scoring)
            jumps = is_jump #(TODO if u want to change) this assumes that jumps happen at same frequency in all runs


            # PLOT score progression with jumps for each inference run 
            plot_name = inference_flavor_name(flavor)
                
            min_y = min(minimum(scoring), 0)
            max_y = max(maximum(scoring), 0)

            scoring_plot = plot(1:length(scoring), scoring, 
                title=plot_name, 
                xlabel="Sample Index", 
                ylabel="Score", 
                legend=false,
                marker=:circle,
                linewidth=2,
                ylims = (min_y, max_y))

            x_jump = findall(jumps)
            scatter!(x_jump, scoring[x_jump], 
                markershape=:circle, 
                markersize=8, 
                label="Jump", 
                color=:red)
            println(plot_name)
            savefig(scoring_plot, RESULTS_DIR[] * "figures/" *"score-progression-"*plot_name*"$(i-1)")
            ######

        end
        push!(flavored_scores, scores)
        push!(flavored_jumps, jumps)
   
    end

    #Plot individual and combined score progressions
    for (i, flavor) in enumerate(inference_flavors) #REFACTOR plot individualimmediately so i get partial results
        plot_name = inference_flavor_name(flavor)
        scores = flavored_scores[i]
        jumps = flavored_jumps[i]

        # Truncate steps score progression (as warm-jumps does less mh steps)
        min_len = minimum(length.(scores))
        scores = [score[1:min_len] for score in scores]

        score_matrix = hcat(scores...)'
    
        mean_vals = mean(score_matrix, dims=1) |> vec
        se_vals = std(score_matrix, dims=1) ./ sqrt(size(score_matrix, 1)) |> vec
        
        # print(scor# Confidence intervals (95%)
        ci_upper = mean_vals .+ 1.96 .* se_vals
        ci_lower = mean_vals .- 1.96 .* se_vals

        # Plot individual score progression for inference flavor
        pavg_individual = plot(mean_vals,
            ribbon=(mean_vals - ci_lower, ci_upper - mean_vals),
            label="Mean ± 95% CI" * plot_name,
            lw=2, fillalpha=0.3, color=colors[i], 
            xlabel="Sample index", ylabel="Score", title="Score Progression with 95% Confidence Interval")
        
        #Plot dots onto the warm-jumps spots
        # Highlight points with true flags
        special_x = findall(jumps)
        special_y = mean_vals[special_x]

        scatter!(special_x, special_y, marker=:circle, ms=6, mc=:red, label="Warm jumps")

        savefig(pavg_individual, RESULTS_DIR[] * "figures/" *"score-avg-progression-"*plot_name)


        #Plot score progression for comparison
        plot!(combined_avg_scores_plot, mean_vals,
            ribbon=(mean_vals - ci_lower, ci_upper - mean_vals),
            label="Mean ± 95% CI " * plot_name,
            lw=2, fillalpha=0.3, color=colors[i])
        scatter!(combined_avg_scores_plot, special_x, special_y, marker=:circle, ms=6, mc=:red, label="Warm jumps")
    end

    # TODO plot_progress_ratio()
    #Plotting options: 
    # - match and compare flavors with closest start point
    # - score progression comparison, +offset to shift away from negative values

    savefig(combined_avg_scores_plot, RESULTS_DIR[] *"figures/score-avg-progression-combined-jumps")

end



#####################################################################################################



"""Runs benchmarking comparison for warm-start and random_start inference"""
function compare_warm_start_with_drifts(inference, data)
    warm_start = Inference_flavor(warm_start = true, gaussian_drift_res=0)
    warm_start_with_drift = Inference_flavor(warm_start = true)
    inference_flavors = [warm_start, warm_start_with_drift]

    benchmark_score_progression_with_drifts(inference, data, inference_flavors, 20, 100) #TODO 20, 50
end

"""Plots score progression for warm start and random start"""
function benchmark_score_progression_with_drifts(inference, data,  inference_flavors, burn_in=10, rounds=50)

    colors = [:orange, :blue, :green, :black, :red, :magenta] 
    combined_avg_scores_plot = plot(title="Score progression with 95% confidence interval", xlabel="Sample index", ylabel="Score")

    # Collect score progress for inference with different start flavors
    flavored_scores = []
    flavored_drifts = []
    for (ii, flavor) in enumerate(inference_flavors) #Compare inference flavors

        Random.seed!() # Reset burn-in seed to random
        
        # Burn in time
        for j=1:burn_in
            inference(data, flavor)
        end

        # Runs inference algorithm #rounds times and collects score progression
        scores::Vector{Vector{Float64}} = [] # tracks score progress for each inference 
        drifties::Vector{Vector{Float64}} = [] # tracks score progress for each inference 
        for i=1:rounds
            Random.seed!(i)
            (scoring, _, drifts) = inference(data, flavor)

            push!(scores, scoring)
            push!(drifties, drifts)

        end
        push!(flavored_scores, scores)
        push!(flavored_drifts, drifties)


        
    end


    #PLOT

    # Plot individual and combined score progression (for each run)
    for i=1:rounds
        base = flavored_scores[1][i]
        with_drifts = flavored_scores[2][i]

        drifts1 = nothing
        drifts2 = flavored_drifts[2][i]

        if !ispath(RESULTS_DIR[] * "figures/runpairs/$(i-1)")
            mkpath(RESULTS_DIR[] * "figures/runpairs/$(i-1)")
        end
        
        # plot_individual_score_progression(base, drifts1, inference_flavor_name(inference_flavors[1]) * "base", i, :blue) 
        # plot_individual_score_progression(with_drifts, drifts2, inference_flavor_name(inference_flavors[2]) * "drifts", i, :orange) #TODO plot gaussian drift

        plot_combined_score_progression(base, with_drifts, "warm-start baseline", "warm-start with drifts", i)

    end

    #Plot individual and combined score progressions
    for (i, flavor) in enumerate(inference_flavors)
        plot_name = inference_flavor_name(flavor)
        scores = flavored_scores[i]
        score_matrix = hcat(scores...)'
    
        mean_vals = mean(score_matrix, dims=1) |> vec
        se_vals = std(score_matrix, dims=1) ./ sqrt(size(score_matrix, 1)) |> vec
        
        # print(scor# Confidence intervals (95%)
        ci_upper = mean_vals .+ 1.96 .* se_vals
        ci_lower = mean_vals .- 1.96 .* se_vals

        # Plot individual score progression for inference flavor
        pavg_individual = plot(mean_vals,
            ribbon=(mean_vals - ci_lower, ci_upper - mean_vals),
            label="Mean ± 95% CI" * plot_name,
            lw=2, fillalpha=0.3, color=colors[i], 
            xlabel="Sample index", ylabel="Score", title="Score Progression with 95% Confidence Interval")
        savefig(pavg_individual, RESULTS_DIR[] * "figures/" *"score-avg-progression-"*plot_name)
        
        #Plot score progression for comparison
        plot!(combined_avg_scores_plot, mean_vals,
            ribbon=(mean_vals - ci_lower, ci_upper - mean_vals),
            label="Mean ± 95% CI " * plot_name,
            lw=2, fillalpha=0.3, color=colors[i])
    end

    # TODO plot_progress_ratio()
    #Plotting options: 
    # - match and compare flavors with closest start point
    # - score progression comparison, +offset to shift away from negative values

    savefig(combined_avg_scores_plot, RESULTS_DIR[] * "figures/" * "score-avg-progression-combined-drifts")

end