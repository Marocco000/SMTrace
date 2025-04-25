using Gen

ppfile = "gaussian-model.jl"
include(ppfile)
ppfile = "Gaussian/gaussian-model.jl"

path = joinpath("..","..", "teste.jl")
include(path) 

smt_infrnc_path = joinpath("..", "..", "julie", "inference-smt.jl")
include(smt_infrnc_path)

logg = joinpath("..", "..", "julie", "logging.jl")
include(logg)

#Plotting
using Plots

results_dir = joinpath(pwd(), "inference", "Gaussian", "res/")


function make_synth_data(n)
    Random.seed!(1)

    true_mu = 10
    true_sigma = 10

    ys = Float64[]
    for i = 1:n
        y = true_mu + randn() * true_sigma
        print
        push!(ys, y)
    end
    print(ys)

    ys
end

function generate_unrolled_loops(ys)
    #generates the unroleed loops assignmentnt for the ppmodel until loops are dealt with in parsing
    # for i = 1:length(ys)
    #     println("y$i = $(ys[i])")
    # end

    for i = 1:length(ys)
        println("\ty$i ~ normal(mu, sigma)")
    end
end


function make_constraints(ys::Vector{Float64})
    constraints = Gen.choicemap()

    for i=1:length(ys)
        yi = QuoteNode(Symbol(:y, i))
        constraints[eval(yi)] = ys[i]
    end

    constraints
end

function inference(inference_type::Inference_type)
    scores = []

    if inference_type.warm_start
        init_trace  = ransac_smt(observations, ppfile, false)
    else
        (init_trace, _) = generate(ppmodel, (),  observations)
    end
    tr = deepcopy(init_trace)
    besttr = deepcopy(init_trace)

    log_trace(scores, tr, besttr)
    
    for i=1:20
        selection = select(:mu, :sigma)

        (tr, _) = mh(tr, selection)

        log_trace(scores, tr, besttr)
    end

    scores
end


n = 10
# generate_unrolled_loops(make_synth_data(n))

ys = make_synth_data(n)
observations = make_constraints(ys)

print("\033c") # clean terminal log
Random.seed!()

# Compare 

scoring_warm = inference(Inference_type(true, false, 50))
scoring_rand = inference(Inference_type(false, false, 50))

plot(scoring_warm; label = "Warm start", marker = :circle, linewidth = 2)
plot!(scoring_rand; label = "Rand start", marker = :diamond, linewidth = 2)

savefig(results_dir * "score_comparison.png")



