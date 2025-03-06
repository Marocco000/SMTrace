import math
import z3

from distributions.RC import RC_Distribution


class RC_Unknown(RC_Distribution):

    def __init__(self, RC):
        super().__init__(RC)

    def true_likelihood(self, x):
        print("Should not get here")

    def true_log_likelihood(self, x):
        print("Should not get here")

    def estim_likelihood(self, x):
        print("Should not get here")

    def solver_bounds(self, solver):
        print("Should not get here")

    def sample(self):
        print("Should not get here")
