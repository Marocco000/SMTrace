using Plots

function serialize_trace(trace)
    # (xs,) = Gen.get_args(trace)
    xs = collect(range(-5, stop=5, length=50))
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
    y1 = 2.6573837689159814
    y2 = 7.702179877517962
    y3 = 6.081150630367074
    y4 = 5.008042235619298
    y5 = 4.730169919177062
    y6 = 4.959542404331658
    y7 = 3.8408261728807407
    y8 = 3.581811690993659
    y9 = 0.10122966946595927
    y10 = 2.3093030917112363
    y11 = 1.114208947120075
    y12 = 1.579562816549691
    y13 = 1.460511864881077
    y14 = 1.2188854648088319
    y15 = -1.0634788926558225
    y16 = -1.1333844328209919
    y17 = -0.6478476691012588
    y18 = -1.7134940283536377
    y19 = 2.9220620949510896
    y20 = -7.992466952018953
    ys = [y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11, y12, y13, y14, y15, y16, y17, y18, y19, y20]
    

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


function visualize_trace(trace::Trace; title="")
    # println("plotting")
    ys = [trace[:y1],trace[:y2], trace[:y3], trace[:y4], trace[:y5],
        trace[:y6], trace[:y7], trace[:y8], trace[:y9],trace[:y10], 
        trace[:y11], trace[:y12], trace[:y13], trace[:y14], trace[:y15],
        trace[:y16], trace[:y17], trace[:y18], trace[:y19],trace[:y20]]
    trace = serialize_trace(trace)

    # outliers = [pt for (pt, outlier) in zip(trace[:points], trace[:outliers]) if outlier]
    # inliers =  [pt for (pt, outlier) in zip(trace[:points], trace[:outliers]) if !outlier]
    # inliers =  [pt for (pt, outlier) in zip(trace[:points], trace[:points]) ]
    # Plots.scatter(map(first, inliers), map(last, inliers), markercolor="blue", label=nothing, xlims=[-5, 5], ylims=[-20, 20], title=title) 
    # Plots.scatter!(map(first, outliers), map(last, outliers), markercolor="red", label=nothing)
    
    # print("unpack trace $trace")

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