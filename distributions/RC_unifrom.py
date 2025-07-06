import math
import random

import z3

from distributions.RC import RC_Distribution


class RC_Uniform(RC_Distribution):

    def __init__(self, RC, a, b, solver):
        super().__init__(RC)
        self.a = a
        self.b = b
        self.div = z3.Real(f"{RC.name}_div")
        solver.add(self.div == 1/(self.b - self.a))
        # solver.add(self.div == z3.If(self.b - self.a == 0, -21, 1/(self.b - self.a)))
        # solver.add(1/(get_ub(self.b)-get_lb(self.a)) <= self.div , self.div <= 1/(get_lb(self.b)-get_ub(self.a)))
        #TODO check if bounding works but needs choice_map and prob also variable_map
        # Support constraints
        self.distribution_support_constraints(solver)

        # self.one_over_b_minus_a = z3.Real(f"{RC.name}_one_over")
        # solver.add(self.one_over_b_minus_a == 1/(self.b - self.a))


    def lb(self):
        return self.a
    def up(self):
        return self.b


    def distribution_support_constraints(self, solver):
        # If one of the variables is a decision variable, add distribution support constraints
        if isinstance(self.a, z3.ExprRef) or isinstance(self.b, z3.ExprRef):
            solver.add(self.a < self.b)
            solver.add(self.a - self.b != 0)
            solver.add(self.b - self.a > 1e-6)  # Avoids values too close to zero


    def true_likelihood(self, x):
        if x >= self.a and x <= self.b:
            return 1/(self.b - self.a)
        else:
            return 0
    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def estim_likelihood(self, x):
        # pdf(x) = 1/(b-a) if a <= x <= b else 0
        # TODO: CP issue with (1/(b-a)) due to no check before propagation and causes div0 
        guard = z3.If(self.b - self.a == 0, -21, 1/(self.b - self.a)) # Guards against division by zero
        return z3.If(x<self.a, 0,
                  z3.If(x<=self.b, self.div,0))
        # div = 1/(self.b - self.a)
        # return z3.If(x<self.a, 0,
        #           z3.If(x<=self.b, div,0))

    def solver_bounds(self, solver):
        solver.add(self.RC.value >= self.a)
        solver.add(self.RC.value <= self.b)

        self.lb = self.a
        self.up = self.b

    def sample(self):
        return random.uniform(self.a, self.b)

def get_lb(x, choice_map): #TODO put in a tool package
    if isinstance(x, z3.ArithRef):
        if choice_map.get(x) is not None:
            return choice_map.get(x).lb() #TODO also do a vaeriable_map check
    else:
        return x
def get_ub(x, choice_map):
    if isinstance(x, z3.ArithRef):
        if choice_map.get(x) is not None:
            return choice_map.get(x).lb()
    else:
        return x