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