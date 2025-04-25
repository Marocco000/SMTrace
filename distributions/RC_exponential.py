import math
import random

from distributions.RC import RC_Distribution
from tools.approximations import exp_maclaurin


class RC_Exponential(RC_Distribution):

    def __init__(self, RC, lambd):
        super().__init__(RC)
        self.lambd = lambd

        #Sanity check lambd > 0

    def true_likelihood(self, x):
        return self.lambd * math.exp(-self.lambd * x)

    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def estim_likelihood(self, x, exp_func=exp_maclaurin):
        return self.lambd * exp_func(-self.lambd * x)

    def solver_bounds(self, solver):
        solver.add(self.RC.value >= 0)
        #TODO upper bound restricition?

    def sample(self):
        return random.expovariate(self.lambd)