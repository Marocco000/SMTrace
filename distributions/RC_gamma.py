import math
import random

from scipy.stats import norm

from distributions.PiecewiseGaussian import estim_likelihood_piecewise_mixture
from distributions.RC import RC_Distribution

import z3


class RC_Gamma(RC_Distribution):

    def __init__(self, RC, alpha, beta, solver):
        super().__init__(RC)
        self.alpha = alpha
        self.beta = beta

        self.solver = solver

        # Gaussian mixture approximation
        # Gamma(α1, α2), ν, ρ) :=  MoG(x; 1, [1], [α1α2], [√α1α2])
        self.mean = alpha*beta
        self.var = math.sqrt(alpha*beta)

        # Sanity constraint that variance for the gaussian mixture > 0
        if isinstance(self.var, z3.ExprRef):
            self.solver.add(self.var > 0)
        else:
            assert self.var > 0

        self.distribution_support_constraints(solver)

    def distribution_support_constraints(self, solver):
        if isinstance(self.alpha, z3.ExprRef):
            self.solver.add(self.alpha > 0)
        if isinstance(self.beta, z3.ExprRef):
            self.solver.add(self.beta > 0)

    def true_likelihood(self, x):
        #TODO add true pdf
        return norm.pdf(x, self.mean, self.var) #gaussian mixture estim

    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def solver_bounds(self, solver):
        # Normal bounds -> Using the 68-95-99.7 rule take 3 standard deviations from mean as bounds
        num_of_stds = 3
        if not self.RC.is_observation:
            self.normal_bounds(solver, self.RC.value, num_of_stds)

    def normal_bounds(self, solver, value, num_of_stds = 3):
        solver.add(self.RC.value >= 0)
        solver.add(self.RC.value <= self.mean + 10 * self.var) #using gaussian mixture approx

    def sample(self):
        return random.uniform(0, self.mean + 5*self.var)

    def estim_likelihood(self, x):
        return self.estim_likelihood_with_gaussian_mixture(x)

    def estim_likelihood_with_gaussian_mixture(self, x):
        # Gaussian mixture approximation
        # Gamma(α1, α2), ν, ρ) :=  MoG(x; 1, [1], [α1α2], [√α1α2])
        #source: https://dl.acm.org/doi/10.1145/2813885.2737982
        return estim_likelihood_piecewise_mixture(x, self.mean, self.var, self.RC.name, self.solver)

