mutable struct Tracker
    scores::Vector{Float64}
    jumps::Vector{Int64} #Bool
    drifts::Vector{Int64}
    mh_steps::Int
    accepted::Vector{Bool} # array of MH acceptance true/false to compute accepted ratio for a drift window
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
    return Tracker(Float64[], Int64[], Int64[], 0, Bool[])
end