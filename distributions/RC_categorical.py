import math
import z3

from distributions.RC import RC_Distribution


class RC_Categorical(RC_Distribution):
    def __init__(self, RC, probs):
        super().__init__(RC)
        self.probs = probs

    def true_likelihood(self, x):
        return self.p[x]

    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def estim_likelihood(self, x):
        pdf = 0
        for i in range(len(self.probs)):
            pdf = z3.If(x == i, self.probs[i], pdf)
        return pdf

    def solver_bounds(self, solver):
        solver.add(self.RC.value >= 1)
        solver.add(self.RC.value <= len(self.probs))