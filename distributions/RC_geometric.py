import math

from distributions.RC import RC_Distribution
import z3

class RC_Geometric(RC_Distribution):

    def __init__(self, RC, p):
        super().__init__(RC)
        self.p = p

    def true_likelihood(self, x):
        return self.p * ((1 - self.p) ** x)

    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def estim_likelihood(self, x):
        #TODO untested
        return z3.If(x == 0, self.p,
                     self.true_likelihood(x))
        # return self.true_likelihood(x)

    def sample(self):
        return 1

    def solver_bounds(self, solver):
        solver.add(self.RC.value >= 0)