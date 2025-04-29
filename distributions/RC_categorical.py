import math
import z3

from distributions.RC import RC_Distribution
import random

class RC_Categorical(RC_Distribution):
    def __init__(self, RC, probs):
        super().__init__(RC)
        # self.length = len(probs)
        self.probs = probs

    def true_likelihood(self, x):
        return self.probs[x]

    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def estim_likelihood(self, x):
        pdf = 0
        for i in range(len(self.probs)):
            pdf = z3.If(x == i+1, self.probs[i], pdf)
        return pdf

    def solver_bounds(self, solver):
        solver.add(self.RC.value >= 1)
        solver.add(self.RC.value <= len(self.probs))

    def sample(self):
        """Samples a value from the distribution,
        but within the [restricted] bounds used for the CP model of the distribution"""
        # Important: the sample should be within the bounds of the CP model given in the solver_bounds method
        return random.randint(1, len(self.probs))
