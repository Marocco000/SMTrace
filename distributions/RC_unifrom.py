import math
import random

import z3

from distributions.RC import RC_Distribution


class RC_Uniform(RC_Distribution):

    def __init__(self, RC, a, b, solver):
        super().__init__(RC)
        self.a = a
        self.b = b

        # Support constraints
        self.distribution_support_constraints(solver)

    def distribution_support_constraints(self, solver):
        # If one of the variables is a decision variable, add distribution support constraints
        if isinstance(self.a, z3.ExprRef) or isinstance(self.b, z3.ExprRef):
            solver.add(self.a < self.b)


    def true_likelihood(self, x):
        if x >= self.a and x <= self.b:
            return 1/(self.b - self.a)
        else:
            return 0
    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def estim_likelihood(self, x):
        return z3.If(x<self.a, 0,
                  z3.If(x<=self.b, 1/(self.b - self.a),0))

    def solver_bounds(self, solver):
        solver.add(self.RC.value >= self.a)
        solver.add(self.RC.value <= self.b)

    def sample(self):
        return random.uniform(self.a, self.b)