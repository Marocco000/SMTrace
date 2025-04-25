import math

from distributions.RC import RC_Distribution


class RC_Geometric(RC_Distribution):

    def __initi_(self, RC, p):
        super().__init__(RC)
        self.p = p

    def true_likelihood(self, x):
        return self.p * ((1 - self.p) ** x)

    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def estim_likelihood(self, x):
        #TODO
        pass