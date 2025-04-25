import math
import z3

from distributions.RC import RC_Distribution


class Branch (object):
    def __init__(self, condition, distribution):
        self.condition = condition
        self.distribution = distribution

class RC_Branch(RC_Distribution):

    def __init__(self, RC, branches:list[Branch]):
        super().__init__(RC)
        self.branches = branches

    def introduce_aux_variables(self, solver):
        # introduce auxiliary variables that represent wich breanchg is selected
        self.z = [z3.Int('z_' + self.RC.name + str(i)) for i in range(len(self.branches))]
        #TODO make name bigger to avoid conflicts

        # constraint that only one branch is selected
        s = 0
        for (i, branch) in enumerate(self.branches):
            solver.add(z3.Or(self.z[i] == 1, self.z[i] == 0))
            s += self.z[i]

        solver.add(s == 1)

        # include selected branch that the condition is satisfied
        for (i, branch) in enumerate(self.branches):
            solver.add(z3.If(branch.condition, self.z[i] == 1, True))
            solver.add(z3.If(self.z[i] == 1, branch.condition, True))
            # solver.add(z3.Implies(branch[0], z[i] == 1))#TODO i think we need double impl

    def true_likelihood(self, x):
        pass
    #
    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))



    def estim_likelihood(self, x):
        '''likelihood is dependent on which branch was selected'''
        #TODO, x is not used here, is this a mistake or just beacuse of the convoluted structure of RC_Distr and branch encoding
        likelihood = 0
        for (i, branch) in enumerate(self.branches):
            likeB = self.z[i] * branch.distribution.estim_likelihood(branch.distribution.RC.value)
            likelihood += likeB
            print(f"i = {i}; z[i] = {self.z[i]}, likelihood {branch.distribution.RC.name}{i + 1} = {likeB}")
        return likelihood

    def solver_bounds(self, solver):
        #TODO bpounds for branch RCs if they are not obs
        #TODO bounds for the conditionas?
        for branch in self.branches:
            branch.distribution.solver_bounds(solver)
        # pass

