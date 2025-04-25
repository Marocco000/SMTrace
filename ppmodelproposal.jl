@gen function smt_proposal()
	A ~ normal(0, epsilon)
	intercept ~ normal(0, epsilon)
	slope ~ normal(0, epsilon)
	B ~ normal(1, epsilon)
	noise ~ normal(0.019061625176369425, epsilon)
	C ~ normal(0.9, epsilon)
end
