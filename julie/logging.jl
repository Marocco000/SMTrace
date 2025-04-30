using Gen

function log_trace(scores, tr, besttr, is_warm_jump = false)
    # keeps track of score progress
    push!(scores, get_score(tr))

    if get_score(tr) > get_score(besttr)
        bestscore = get_score(tr)
        besttr = deepcopy(tr)
    end

    # push!(is_warm_jump, )
end

function log_score(scores, tr)
    push!(scores, get_score(tr))
end

function log_jump(jumps, is_jump)
    #keep track each sample point if it used an SMT trace or not
    push!(jumps, is_jump)
end

function log_drift(drifts, is_drift)
    push!(drifts, is_drift)
end