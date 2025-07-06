mutable struct Tracker
    scores::Vector{Float64}
    drifts::Vector{Int64}
    jumps::Vector{Bool} #Bool
    mh_steps::Int
    accepted::Vector{Bool} # array of MH acceptance true/false to compute accepted ratio for a drift window
    jump_successes::Dict{String, Int}
end

function jumpsucc!(t::Tracker, str)
    #str = unsat, reject, accept
    t.jump_successes[str] = get(t.jump_successes, str, 0) + 1
end

function update!(t::Tracker, score, is_drift, is_jump)
    push!(t.scores, score)
    push!(t.drifts, is_drift)
    push!(t.jumps, is_jump)
    t.mh_steps += 1
end
"""Trims tracked information at a cap."""
function trim!(t::Tracker, cap=2000)
    t.scores = t.scores[1:cap]
    t.jumps = t.jumps[1:cap]
    t.drifts = t.drifts[1:cap]
end

function accepted!(t::Tracker, a)
    # if !@isdefined t.accepted
    #     t.accepted = []
    # end
    push!(t.accepted, a)
end

function new_tracker()
    # return Tracker(Float64[], [], [], 0, [])
    return Tracker(Float64[], Int64[], Bool[], 0, Bool[], Dict{String, Int}())
end