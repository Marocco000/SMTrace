import math
import z3

from distributions.RC import RC_Distribution
from tools.approximations import exp_maclaurin


class RC_Laplace(RC_Distribution):
    def __init__(self, RC, location, scale):
        super().__init__(RC)
        self.location = location
        self.scale = scale

    def true_likelihood(self, x):
        return 1/(2*self.scale) * math.exp(-abs(x - self.location)/self.scale)

    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def estim_likelihood(self, x):
        return self.estim_likelihood_exp_approximation(x)

    def estim_likelihood_exp_approximation(self, x, exp_func= exp_maclaurin):
        return 1/(2*self.scale) * exp_func(-abs(x - self.location)/self.scale)

    def estim_likelihodd_piecewise(self, x):
        #TODO
        pass

    def solver_bounds(self, solver):
        #num_of_stds = 3#TODO check rule correctnes, its similar to gaussian rule
        solver.add(self.RC.value >= self.location - 4 * self.scale)
        solver.add(self.RC.value <= self.location + 4 * self.scale)