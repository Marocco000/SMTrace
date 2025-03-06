import math

import z3

from tools.approximations import exp_maclaurin
from tools.numerical import slope, bias


def estim_likelihood_piecewise_mixture(x, mean, var, name, solver, segments=3):
    '''Computes a set of constraint representing a gaussian likelihood of x for N(mean, var). The computation is done
    with a pioce-wise linear approximation of the gaussian distribuition
    Splits the [mean +- 3*vaer] interval into 2*segments splits. The likelihood is computed as the point on the piecewise line.

    It will have the form If (x< mean - 3var, 0
                                If(x< mean - 2var, a1*x+b1,
                                ..
                                    If(x< mean + 3var, a2S*x+b2S, 0)


    TODO: problematic if variance is a decision var..
    TODO: compute based on true likelihood??
    '''

    # S segments of size k = (3*var/S). with each segment endpoint having following pdf value f(mean+ k*i*var) = 1/var\/2Pi  exp(-1/2 (ki/2)^2)
    S = segments
    k = 3*var / S
    # TODO make use of distribution symmetry for computation; maybe also compacter representation with less decision boundry vars
    # abs(x-mean) should give dist , then take positive range ...

    fixed = True
    # Sanity constraint that variance > 0
    if isinstance(var, z3.ExprRef):
        solver.add(var > 0)
        fixed = False
        k = var * z3.Q(3, S)
        # TODO: used fixed value here from fixed sample

    # Compute segments on gaussian pdf as (endpoint, val), endpoint in 3var range, val = pdf value
    endpoints = []
    vals = []
    for i in range(S, 0, -1):  # Points from [mean - 3*var, mean]
        endpoints.append(mean - k * i)
        if fixed:
            # if var is not a decision variable, try without further segment decision variables and original exp function
            one_over_var_component = (1 / (var * 2.5066))
            exp_component =  math.exp(-k * k * i * i / 8)
            vals.append(one_over_var_component * exp_component)
        else:
            valy = z3.Real(f'{name}_endpoint{i}_1')
            solver.add(valy == (1 / (var * 2.5066)) * estim_exp_component(-k * k * i * i / 8))  # * math.exp(-k * k * i * i / 8))
            vals.append(valy)

    for i in range(S + 1):  # Points from [mean, mean + 3*var]
        endpoints.append(mean + k * i)  # xi in gaussian pdf
        if fixed:
            vals.append((1/(var * 2.5066)) * math.exp(-k*k*i*i/8)) #yi in gaussian pdf f(xi) = 1/var2Pi * exp (kkii/8)
        else:
            valy = z3.Real(f'{name}_endpoint{i}_2')
            solver.add(valy == (1 / (var * 2.5066)) * estim_exp_component(-k * k * i * i / 8))  # * math.exp(-k * k * i * i / 8))
            vals.append(valy)

    # Compute segment lines formulas
    a = []
    b = []
    for i in range(2 * S):
        x1 = endpoints[i]  # TODO pls dont be model variable name clash!! might need diff adresses
        x2 = endpoints[i + 1]
        y1 = vals[i]
        y2 = vals[i + 1]
        a.append(slope(x1, x2, y1, y2))
        b.append(bias(x1, x2, y1, y2))

    # TODO iterative & remake for symmetry and simplify, should be able to compute directly the segm needed
    pdf = 0
    for i in range(2 * S, 0, -1):
        pdf = z3.If(x < endpoints[i], a[i - 1] * x + b[i - 1], pdf)

    #Zero outside +- 3Var range from mean
    pdf = z3.If(x < endpoints[0], 0, pdf) # x< -3var + meanTODO check this again, this was < endpoints[S]
    pdf = z3.If(x > endpoints[2*S], 0, pdf) # x> 3*var + mean
    return pdf

def estim_exp_component(x):
    '''
    Computes an estimate of the exponential component
    In the case of x being ArithRef instance, the computation isnt working as expected.
    This is a TODO to check why it doesnt accept the computation as unknown.

    If x is a constant, we can just use the exp value.
    '''
    # if isinstance(x, z3.ExprRef):
    return exp_maclaurin(x)
    # else:
    #     return math.exp(x)