import math
import random

from scipy.stats import norm

from distributions.PiecewiseGaussian import estim_likelihood_piecewise_mixture
from distributions.RC import RC_Distribution
from tools.approximations import exp_maclaurin, log_bilinear
from tools.numerical import slope, bias
import z3


class RC_Normal(RC_Distribution):

    # def __init__(self, RC, mean, var):
    #     super().__init__(RC)
    #     self.mean = mean
    #     self.var = var

    def __init__(self, RC, mean, var, solver):
        super().__init__(RC)
        self.mean = mean
        self.var = var
        self.solver = solver

        #Sanity constraint that variance > 0
        if isinstance(var, z3.ExprRef):
            self.solver.add(self.var > 0)
        else:
            assert var > 0


    def lb(self):
        return self.mean - 3 * self.var
    def ub(self):
        return self.mean + 3 * self.var



    def true_likelihood(self, x):
        return norm.pdf(x, self.mean, self.var)

    def true_log_likelihood(self, x):
        return math.log(self.true_likelihood(x))

    def estim_likelihood_taylor(self, x):
        return self.gaussian_pdf(x, self.mean, self.var)

    def estim_log_likelihood_taylor(self, x):
        return self.log_gaussian_pdf(x, self.mean, self.var)

    #Gaussian pdf estimation variants
    def gaussian_pdf(self, x, exp_func=exp_maclaurin, denom_mode="nromal"):
        if (denom_mode == "normal"):
            denom = self.var * math.sqrt(2 * math.pi)
        elif (denom_mode == "no_pi"):
            denom = self.var
        pdf = exp_func((-1 / 2) * (((x - self.mean) / self.var) ** 2)) / denom
        return pdf
    def log_gaussian_pdf(self, x, log_func=log_bilinear):
        log_denom = log_func(1 / self.var)  # * math.sqrt(2 * math.pi)
        log_pdf = log_denom + ((-1 / 2) * (((x - self.mean) / self.var) ** 2))
        return log_pdf


    def solver_bounds(self, solver):
        # Normal bounds -> Using the 68-95-99.7 rule take 3 standard deviations from mean as bounds
        #TODO: be more lenient towards the observations? or not ionclude at all
        num_of_stds = 3
        if not self.RC.is_observation:
            # num_of_stds = 10
            self.normal_bounds(solver, self.RC.value, num_of_stds)

    def normal_bounds(self, solver, value, num_of_stds = 3):
        solver.add(self.RC.value >= self.mean - num_of_stds * self.var)
        solver.add(self.RC.value <= self.mean + num_of_stds * self.var)

    def sample(self):
        '''Samples a value from the distribution'''
        # return norm.rvs(self.mean, self.var)
        return self.mean + self.var * random.uniform(-3,3)


    def estim_likelihood(self, x):
        # return self.estim_likelihood_piecewise(x)
        return estim_likelihood_piecewise_mixture(x, self.mean, self.var, self.RC.name, self.solver)


    # def estim_likelihood_piecewise(self, x, segments=3):
    #     '''Computes a set of constraint representing a gaussian likelihood of x for N(mean, var). The computation is done
    #     with a pioce-wise linear approximation of the gaussian distribuition
    #     Splits the [mean +- 3*vaer] interval into 2*segments splits. The likelihood is computed as the point on the piecewise line.
    #
    #     It will have the form If (x< mean - 3var, 0
    #                                 If(x< mean - 2var, a1*x+b1,
    #                                 ..
    #                                     If(x< mean + 3var, a2S*x+b2S, 0)
    #
    #
    #     TODO: problematic if variance is a decision var..
    #     TODO: compute based on true likelihood??
    #     '''
    #
    #
    #     # S segments of size k = (3*var/S). with each segment endpoint having following pdf value f(mean+ k*i*var) = 1/var\/2Pi  exp(-1/2 (ki/2)^2)
    #     S = segments
    #     # k = 3*self.var / S
    #     k = self.var * z3.Q(3, S)
    #     #TODO make use of distribution symmetry for computation; maybe also compacter representation with less decision boundry vars
    #     # abs(x-mean) should give dist , then take positive range ...
    #
    #     # Compute segments on gaussian pdf as (endpoint, val), endpoint in 3var range, val = pdf value
    #     endpoints = []
    #     vals = []
    #     for i in range(S, 0, -1): # Points from [mean - 3*var, mean]
    #         print(self.var)
    #         endpoints.append(self.mean - k * i)
    #         # vals.append((1 / (self.var * 2.5066)) * math.exp(-k * k * i * i / 8))
    #         valy = z3.Real(f'{self.RC.name}_endpoint{i}_1')
    #         # x = (1 / (self.var * 2.5066)) * math.exp(-k * k * i * i / 8)
    #         self.solver.add( valy == (1 / (self.var * 2.5066)) * exp_maclaurin(-k * k * i * i / 8))# * math.exp(-k * k * i * i / 8))
    #         vals.append(valy)
    #         # vals.append(z3.Q(1, (self.var)) * 0.3989 * math.exp(-k * k * i * i / 8))
    #
    #     # print("HERE\n")
    #     # print(vals)
    #
    #     for i in range(S+1): # Points from [mean, mean + 3*var]
    #         endpoints.append(self.mean + k*i) #xi in gaussian pdf
    #         # vals.append((1/(self.var * 2.5066)) * math.exp(-k*k*i*i/8)) #yi in gaussian pdf f(xi) = 1/var2Pi * exp (kkii/8)
    #         # self.solver.add(x == (1 / (self.var * 2.5066)) )#* math.exp(-k * k * i * i / 8))
    #         valy = z3.Real(f'{self.RC.name}_endpoint{i}_2')
    #         # x = (1 / (self.var * 2.5066)) * math.exp(-k * k * i * i / 8)
    #         self.solver.add(valy == (1 / (self.var * 2.5066)) * exp_maclaurin(-k * k * i * i / 8))  # * math.exp(-k * k * i * i / 8))
    #         vals.append(valy)
    #
    #     # print("HERE\n")
    #     # print(vals)
    #     # Compute segment lines formulas
    #     a = []
    #     b = []
    #     for i in range(2*S):
    #         x1 = endpoints[i] #TODO pls dont be model variabe name clash!! might need diff adresses
    #         x2 = endpoints[i+1]
    #         y1 = vals[i]
    #         y2 = vals[i+1]
    #         a.append(slope(x1, x2, y1, y2))
    #         b.append(bias(x1, x2, y1, y2))
    #
    #
    #     #TODO iterative & remake for symmetry and simplify, should be able to compute directly the segm needed
    #     pdf = 0
    #     for i in range(2*S , 0, -1):
    #         pdf = z3.If(x < endpoints[i], a[i-1]*x+b[i-1], pdf)
    #     pdf = z3.If(x<endpoints[S], 0, pdf)
    #
    #     return pdf








