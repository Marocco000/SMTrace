import math
import random

from scipy.stats import norm

from distributions.PiecewiseGaussian import estim_likelihood_piecewise_mixture
from distributions.RC import RC_Distribution

import z3


class RC_Poisson(RC_Distribution):

    def __init__(self, RC, rate, solver):
        super().__init__(RC)
        self.rate = rate

        # Gaussian mixture approximation
        # LL(x ∼ Poisson(λ), ν, ρ) := (ν[x ← MoG(x; 1, [1], [λ], [√λ])], ρ)
        self.mean = rate
        self.var = math.sqrt(rate)

        self.solver = solver

        # Sanity constraint that variance > 0
        if isinstance(self.var, z3.ExprRef):
            self.solver.add(self.var > 0)
        else:
            assert self.var > 0


    def true_likelihood(self, x):
        # return norm.pdf(x, self.mean, self.var) #gaussian mixture estim
        return self.rate ** x * math.exp(-self.rate) / math.factorial(x)

    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def solver_bounds(self, solver):
        # Normal bounds -> Using the 68-95-99.7 rule take 3 standard deviations from mean as bounds
        num_of_stds = 3
        if not self.RC.is_observation:
            self.normal_bounds(solver, self.RC.value, num_of_stds)

    def normal_bounds(self, solver, value, num_of_stds = 3):
        solver.add(self.RC.value >= 0) #rate is bigger than 0
        solver.add(self.RC.value <= self.mean + num_of_stds * self.var) #using gaussian mixture approx


    def sample(self):
        value = random.uniform(1, self.mean + 3*self.var)
        print(f"sampled POIS {value}")
        return value

    def estim_likelihood(self, x):
        return estim_likelihood_piecewise_mixture(x, self.mean, self.var, self.RC.name, self.solver)
        #TODO: truncate piecewise at 0? technically x is already bounded but there still is extra computation. (cant check if var and mean are not constants)


