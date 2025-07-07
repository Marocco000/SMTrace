using Gen
using Distributions

include("NS-model.jl")
ppfile = "NSchools/NS-model.jl"

path = joinpath("..","..", "teste.jl")
include(path) 

smt_infrnc_path = joinpath("..", "..", "julie", "inference-smt.jl")
include(smt_infrnc_path)

logg = joinpath("..", "..", "julie", "logging.jl")
include(logg)

bench = joinpath("..", "..", "julie", "benchmarking.jl")
include(bench)

include(joinpath("..", "..", "julie", "mh_tracker.jl"))

function make_synthetic_data(n, num_states, num_districts_per_state, num_types)
    # n = 100 # num of scools 
    # num_states = 4
    # num_districts_per_state = 2
    # num_types = 5

    scale_state = 1.0
    scale_district = 1.0
    scale_type = 1.0
    Random.seed!(1)

    state = Vector{Int64}(undef, n)
    district = Vector{Int64}(undef, n)
    type = Vector{Int64}(undef, n)
    for i =1:n
        # Assume we are given state[i], district[i], type[i]
        state[i] = rand(1:num_states)
        district[i] = rand(1:num_districts_per_state)
        type[i] =  rand(1:num_types)
    end

    sigma_state = 0.2#TODO maybe this is wrong
    sigma_district = 0.3
    sigma_type = 0.5

    beta_baseline = 20

    beta_state = zeros(Float64, num_states)
    for s = 1:num_states
        beta_state[s] = 0 + randn() * sigma_state
    end

    beta_district = zeros(Float64, num_states, num_districts_per_state)
    for s = 1:num_states
        for d = 1:num_districts_per_state
            beta_district[s, d] =  0 + randn() * sigma_district
        end
    end

    beta_type = zeros(Float64, num_types)
    for t = 1:num_types
        beta_type[t] = 0 + randn() * sigma_type
    end

    sigma = zeros(Float64, n)
    y = zeros(Float64, n)
    for i = 1:n
        yhat = beta_baseline + beta_state[state[i]] + beta_district[state[i], district[i]] + beta_type[type[i]]
        sigma[i] = 0.5 + rand() #uniform(0.5, 1.5)
        y[i] = yhat + randn() * sigma[i]
    end

    Random.seed!()
    return sigma, y
end

function make_constraints(sigma, y)::Gen.ChoiceMap
    constraints = Gen.choicemap()
    
    for i=1:length(sigma)
        sigmai = QuoteNode(Symbol(:sigma, i))
        constraints[eval(sigmai)] = sigma[i]
    end

    for i=1:length(y)
        yi = QuoteNode(Symbol(:y, i))
        constraints[eval(yi)] = y[i]
    end

    constraints
end



function get_data_and_observations()
    n = 100 # num of scools 
    num_states = 4
    num_districts_per_state = 2
    num_types = 5

    sigma, y = make_synthetic_data(n, num_states, num_districts_per_state, num_types)
    observations = make_constraints(sigma, y)
    
    data = Dict(
    "n" => n,
    "num_states" => num_states,
    "num_districts_per_state" => num_districts_per_state,
    "num_types" => num_types
)

    return (data, observations)
end

function inference(data, infer_flavor::Inference_flavor)
    # Track score progression and mh steps (drifts, smt-driven)
    tracker = new_tracker()

    # Initial guess
    if infer_flavor.warm_start
        init_trace = ransac_smt(observations, ppfile, false)
        # init_trace = reuse_warm_start()
        
        gaussian_drift_resources = infer_flavor.gaussian_drift_res # set resources after smt start
        update!(tracker, get_score(init_trace), false, true)
    else
        (init_trace, _) = generate(ppmodel, (),  observations)

        gaussian_drift_resources = 0
        update!(tracker, get_score(init_trace), false, false)
    end

    tr = deepcopy(init_trace)


    println("INIT SCORE: $(get_score(tr))")
    
    mh_steps_cap = 2000

    # Sample iterations
    while tracker.mh_steps <= mh_steps_cap
        # if infer_flavor.warm_jump 
        #     # perform warm_jump if possible
        #     fixed_selection_options = [select(:mean1, :mean2), select(:mean3, :mean2), select(:mean1, :mean3)]
        #     fixed_selection = fixed_selection_options[Int(j/2)]
        #     try_tr = block_smt_with_fixed_selection(fixed_selection, tr, observations, ppfile)
        #     if try_tr === nothing
        #         iter += 1
        #     else 
        #         tr = try_tr
        #         println("Pre-jump score $(get_score(tr))")
        #         println("JUMP SCORE: $(get_score(tr))")


        #         update!(tracker, get_score(tr), false, true)        
        #         gaussian_drift_resources = infer_flavor.gaussian_drift_res # reset resources after smt jump
        #     end
        #     # Options: try to improve only on e of the means and the allocations, add less resources
        #elseif...
        # if (infer_flavor.warm_jump || infer_flavor.warm_start) && gaussian_drift_resources > 0
            #Drift MH proposals

        #     #Gaussian drift over each means #TODO can i de-duplicate?
        #     (tr, _) = mh(tr, mean1_drift_proposal, ())
        #     update!(tracker, get_score(tr), true, false)

        #     (tr, _) = mh(tr, mean2_drift_proposal, ())
        #     update!(tracker, get_score(tr), true, false)

        #     (tr, _) = mh(tr, mean3_drift_proposal, ())
        #     update!(tracker, get_score(tr), true, false)
        #     # TODO: option Throw zi -> zi-1 or zi+1? assume u could put point in neighbouring piles


        #     gaussian_drift_resources -= 1

        # else 
            # perform standard inference (mh, block resim mh, etc)
            #block1: update sigmas
            (tr, a) = mh(tr, select(:sigmaxstate); observations=observations)
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)

            (tr, a) = mh(tr, select(:sigmaxdistrict); observations=observations)
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)

            (tr, a) = mh(tr, select(:sigmaxtype); observations=observations)
            update!(tracker, get_score(tr), false, false)
            accepted!(tracker, a)
        

            #block2: update betas
            for s=1:data["num_states"]
                beta_statei = QuoteNode(Symbol(:betaxstate, s))
                selection = select(eval(beta_statei))

                if (infer_flavor.warm_jump || infer_flavor.warm_start) && gaussian_drift_resources > 0
                    latent = eval(beta_statei) 
                    (tr, a) = mh(tr, beta_state_drift_proposal, (latent, ); observations=observations)
                    update!(tracker, get_score(tr), true, false)
                    accepted!(tracker, a)
                    gaussian_drift_resources -= 1
                else
                    (tr, a) = mh(tr, selection; observations=observations)
                    update!(tracker, get_score(tr), false, false)
                    accepted!(tracker, a)
                end                
            end

            for s=1:data["num_states"] 
                for d=1:data["num_districts_per_state"]
                    # beta_districti = QuoteNode(Symbol(:betaxdistrict, i)) #TODO
                    beta_districti = QuoteNode(Symbol(":betaxdistrict$(s)To$(d)")) #TODO
                    selection = select(eval(beta_districti))

                    if (infer_flavor.warm_jump || infer_flavor.warm_start) && gaussian_drift_resources > 0
                        latent = Symbol("betaxdistrict$(s)To$(d)")
                        (tr, a) = mh(tr, beta_district_drift_proposal, (latent, ); observations=observations)

                        update!(tracker, get_score(tr), true, false)
                        accepted!(tracker, a)
                        gaussian_drift_resources -= 1
                    else
                        (tr, a) = mh(tr, selection; observations=observations)
                        update!(tracker, get_score(tr), false, false)
                        accepted!(tracker, a)
                    end
                end
            end

            for i=1:data["num_types"]
                beta_typei = QuoteNode(Symbol(:betaxtype, i))
                selection = select(eval(beta_typei))

                if (infer_flavor.warm_jump || infer_flavor.warm_start) && gaussian_drift_resources > 0
                    latent = eval(beta_typei)
                    (tr, a) = mh(tr, beta_type_drift_proposal, (latent, ); observations=observations)

                    update!(tracker, get_score(tr), true, false)
                    accepted!(tracker, a)
                    gaussian_drift_resources -= 1
                else
                    (tr, a) = mh(tr, selection; observations=observations)
                    update!(tracker, get_score(tr), false, false)
                    accepted!(tracker, a)
                end
            end
            
        # end
    end

  

    #Cap scores at 2000 mh steps
    trim!(tracker, mh_steps_cap)

    # return (scores, jumps, drifts)
    # return (tracker.scores, tracker.jumps, tracker.drifts)
    return tracker

end

# Gaussian drifts:

@gen function beta_state_drift_proposal(current_trace, latent)
    @trace(normal(current_trace[latent], 0.1), latent)
end

@gen function beta_district_drift_proposal(current_trace, latent)
    @trace(normal(current_trace[latent], 0.1), latent)
end

@gen function beta_type_drift_proposal(current_trace, latent)
    @trace(normal(current_trace[latent], 0.1), latent)
end
#     @gen function bernoulli_outlier_proposal(current_trace, latent)
#     p = current_trace[latent] ? 0.6 : 0.5
#     @trace(bernoulli(p), latent)
# end  



