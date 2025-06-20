using Plots

function make_synthetic_dataset(n)
    Random.seed!(1)
    noise = 0.5
    true_slope = -1
    true_intercept = 2
    xs = collect(range(-5, stop=5, length=n))
    ys = Float64[]
    for (i, x) in enumerate(xs)
        
        y = true_slope * x + true_intercept + randn() * noise
        
        push!(ys, y)
    end
    (xs, ys)
end

function serialize_trace(trace)
    # (xs,) = Gen.get_args(trace)
    xs = [-5.0, -3.888888888888889, -2.7777777777777777, -1.6666666666666667, -0.5555555555555556, 0.5555555555555556, 1.6666666666666667, 2.7777777777777777, 3.888888888888889, 5.0]
    
    # y1 = 2.6573837689159814
    # y2 = 7.117384555880536
    # y3 = 4.91155998709222
    # y4 = 3.253656270707018
    # y5 = 2.3909886326273533
    # y6 = 2.0355657961445237
    # y7 = 0.3320542430561795
    # y8 = -0.5117555604683294
    # y9 = 0.10122966946595927
    # y10 = -2.9538548030256058
    # ys = [y1, y2, y3, y4, y5, y6, y7, y8, y9, y10]
    # xs, ys = 
    (xs, ys) = make_synthetic_dataset(100)

    Dict(:slope => trace[:slope],
         :intercept => trace[:intercept],
        #  :inlier_std => trace[:noise],
         :inlier_std => 1,
        #  :points => zip(xs, [trace[:data => i => :y] for i in 1:length(xs)]),
        #  :outliers => [trace[:data => i => :is_outlier] for i in 1:length(xs)]
         :points => zip(xs, ys)
        #  :points => zip(xs, [trace[eval(:(Symbol("y$i")))] for i in 1:length(xs)])
         
         )
end

function synt_data(n)
    Random.seed!(1)
    noise = 0.5
    true_slope = -1
    true_intercept = 2
    xs = collect(range(-5, stop=5, length=n))
    ys = Float64[]
    for (i, x) in enumerate(xs)
        
        y = true_slope * x + true_intercept + randn() * noise
        
        push!(ys, y)
    end
    (xs, ys)
end

function visualize_trace(trace::Trace; title="")
    println("plotting")
    # ys = [trace[:y1],trace[:y2], trace[:y3], trace[:y4], trace[:y5],
    #       trace[:y6], trace[:y7], trace[:y8], trace[:y9],trace[:y10]]
    # ys = [trace[:y1], trace[:y2], trace[:y3], trace[:y4], trace[:y5],
    #   trace[:y6], trace[:y7], trace[:y8], trace[:y9], trace[:y10],
    #   trace[:y11], trace[:y12], trace[:y13], trace[:y14], trace[:y15],
    #   trace[:y16], trace[:y17], trace[:y18], trace[:y19], trace[:y20]]

    # ys =   
    trace = serialize_trace(trace)
    (xs, ys) = synt_data(100)

    # outliers = [pt for (pt, outlier) in zip(trace[:points], trace[:outliers]) if outlier]
    # inliers =  [pt for (pt, outlier) in zip(trace[:points], trace[:outliers]) if !outlier]
    # inliers =  [pt for (pt, outlier) in zip(trace[:points], trace[:points]) ]
    # Plots.scatter(map(first, inliers), map(last, inliers), markercolor="blue", label=nothing, xlims=[-5, 5], ylims=[-20, 20], title=title) 
    # Plots.scatter!(map(first, outliers), map(last, outliers), markercolor="red", label=nothing)

    Plots.scatter(xs, ys, label=nothing, marker=:circle, color=:blue)

    inferred_line(x) = trace[:slope] * x + trace[:intercept]
    left_x = -5
    left_y  = inferred_line(left_x)
    right_x = 5
    right_y = inferred_line(right_x)
    Plots.plot!([left_x, right_x], [left_y, right_y], color="black", label=nothing)


    # Inlier noise
    # inlier_std = trace[:inlier_std]
    # noise_points = [(left_x, left_y + inlier_std),
    #                 (right_x, right_y + inlier_std),
    #                 (right_x, right_y - inlier_std),
    #                 (left_x, left_y - inlier_std)]
    # Plots.plot!(Shape(map(first, noise_points), map(last, noise_points)), color="black", alpha=0.2, label=nothing)
    # Plots.plot!(Shape([-5, 5, 5, -5], [10, 10, -10, -10]), color="black", label=nothing, alpha=0.08)
end