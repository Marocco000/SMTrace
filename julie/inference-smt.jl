using Gen

module FlavorConfig


"""Inference flavor maintains if the inference procedure will use warm-start or warm-jumps to SMT traces"""
#TODO remove mutable? (problematic with gaussian_drift_res)
    Base.@kwdef mutable struct Inference_flavor
        warm_start::Bool = false
        warm_jump::Bool = false
        gaussian_drift_res::Int64 = 100# Amount of Gaussian drifts to do after a warm-jump/warm-start
    end

    const rand_start = Inference_flavor()
    const warm_start = Inference_flavor(warm_start = true)

    const with_jumps = Inference_flavor(warm_jump=true)
    const plain = Inference_flavor()

    export Inference_flavor, rand_start, warm_start, plain, with_jumps

end


function inference_flavor_name(inference_flavor:: FlavorConfig.Inference_flavor)
    plot_name = ""

    if inference_flavor.warm_start
        plot_name = plot_name * "warm-start"
    else
        plot_name = plot_name * "rand-start"
    end
    if inference_flavor.warm_jump
        plot_name = plot_name * "-with-warm-jumps"
    end

    return plot_name
end
