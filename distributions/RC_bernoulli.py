import math
import random

import z3

from distributions.RC import RC_Distribution


class RC_Bernoulli(RC_Distribution):

    def __init__(self, RC, p):
        super().__init__(RC)
        self.p = p

    def true_likelihood(self, x):
        if x == 1:
            return self.p
        else:# x == 0:
            return 1 - self.p
    #
    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))
    #
    def estim_likelihood(self, x):
        return z3.If(x == 1, self.p, 1 - self.p)
    #
    def solver_bounds(self, solver): #TODO use True/False values instead?
        solver.add(z3.Or(self.RC.value == 0, self.RC.value ==1))

    def sample(self):
        return random.randint(0, 1)