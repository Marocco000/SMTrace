import math
import random

from scipy.stats import norm

from distributions.PiecewiseGaussian import estim_likelihood_piecewise_mixture
from distributions.RC import RC_Distribution

import z3

class RC_Beta(RC_Distribution):

    def __init__(self, RC, alpha, beta, solver):
        super().__init__(RC)
        self.alpha = alpha
        self.beta = beta

        # Gaussian mixture approximation
        # Beta(x;α1, α2), ν, ρ) := (ν
        # [ x ← MoG(x; 1, [1], [α1 α1 + α2],[√ α1α2 (α1 + α2)2(α1 + α2 + 1)])
        self.mean = alpha / (alpha + beta)
        self.var = (alpha * beta)/((alpha + beta)**2 * (alpha + beta + 1))

        self.solver = solver

        # Sanity constraint that variance > 0
        if isinstance(self.var, z3.ExprRef):
            self.solver.add(self.var > 0)
        else:
            assert self.var > 0

    def true_likelihood(self, x):
        #TODO add true pdf instead of gaussian mixture estimation
        return norm.pdf(x, self.mean, self.var)

    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def solver_bounds(self, solver):
        # Normal bounds -> Using the 68-95-99.7 rule take 3 standard deviations from mean as bounds
        num_of_stds = 3
        if not self.RC.is_observation:
            self.normal_bounds(solver, num_of_stds)

    def normal_bounds(self, solver, num_of_stds = 3):
        solver.add(self.RC.value >= 0)
        solver.add(self.RC.value <= 1)

        # from gaussian mixture estim, TODO take out after testing
        # solver.add(self.RC.value >= self.mean - num_of_stds * self.var)
        # solver.add(self.RC.value <= self.mean + num_of_stds * self.var)

    def sample(self):
        return random.betavariate(self.alpha, self.beta)

    def estim_likelihood(self, x):
        return estim_likelihood_piecewise_mixture(x, self.mean, self.var, self.RC.name, self.solver)
        #TODO: truncate piecewise at 0? technically x is already bounded but there still is extra computation. (cant check if var and mean are not constants)


