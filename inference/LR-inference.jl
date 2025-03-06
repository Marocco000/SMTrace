include("LR-model.jl") # the ppmodel TODO pass the name of the ppmodel function instead of always naming it ppmodel

path = joinpath("..", "teste.jl")
include(path) 

#Plotting

using Plots
path = joinpath("..", "regression_viz.jl")
include(path)


function make_constraints(ys::Vector{Float64})
    constraints = Gen.choicemap()
    # for i=1:length(ys)
    #     constraints[:data => i => :y] = ys[i]
    # end

    #linear regression observations TODO howwww
    # TODO: again problem with geenrating code, i need the name and ref to the address
    # for i = 1:lenght(ys)
    #     constraints[yi]
    # end


    #Burglar alarm
    # constraints[:B] = 1
    # constraints = burglar_alarm_constraints()
    constraints
end;


function inference_over_simple_LR()
    # Get SMT trace as initial state 
    init_trace = ransac_smt(observations) #TODO (observations are not done here, for now they are hacked in as constants in the ppmodel)

    println("Initial score: $(get_score(init_trace))")
    # intercept = 6758822414725939/5000000000000000
    # slope = -1345506026865873/1562500000000000  
    # score: -24.205867303903318

    tr = init_trace
    besttr = tr
    bestscore = get_score(tr)

    # Run MH for a couple of steps for asympt guarantees ("couple of steps != asymptotic") TODO
    for i=1:50
        (tr, _) = mh(tr, select(:intercept, :slope))
        println(" score: $(get_score(tr))")
        if get_score(tr) > bestscore
            bestscore = get_score(tr)
            besttr = tr
        end

    end

    # Plot intial trace, last and best
    p = Plots.plot([visualize_trace(init_trace, title="SMT (init) trace"), 
                visualize_trace(tr, title="last trace"), 
                visualize_trace(besttr, title="best trace")
                ]...)
    savefig(p, "LR-SMT-MH.png")
    p
end



# observations = make_constraints(ys);

inference_over_simple_LR()

