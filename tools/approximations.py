from math import e
import math

def exp(x):
    return e ** x

def exp_maclaurin(x, n = 10):
    # Exponential function using MacLaurin series expansion e^x = 1 + x + x^2/2! + .. + x^n/n!
    sum = 0
    if x == 0:
        return 1 #TO avoid 0^0? #TODO trial, check if its a keep
    for i in range(n):
        sum += x ** i / math.factorial(i)
    return sum

# def exp_taylor2(x):
#     # e^(-x^2) = 1-x2 + x4/2! -x6/3! + ...
#     # a^x = ...
#     #TODO
#     pass

def exp_pade_1_1_approximant(x):
    # Pade approximant = Pm(x)/Qn(x); Where Pm, Qn are polynomials of degrees m and n
    # [1 / 1] Pade Approximant: e^x = 1+x/2  / 1- x/2
    return (1+x/2) / (1-x/2)
def exp_pade_2_2_approximant(x):
    # [2/2] Pade approximant
    return (1 + x/3 + (x**2)/12) / (1 -x/3 + (x**2)/12)

# def exp_continued_fractions( n=30 ):
#     '''Compute an approximative value of exp(x) from'''
#     # TODO
#     # a = 1. + n
#     # for k in range(n, 0, -1):
#     #     a = k + k/a
#     # return 2+1/a

def precision_check_exp(x, exp_approximant):

    print(f"exponential approximation comparison: e^{x}")
    print(f"{exp(x)} - true")
    print(f"{exp_approximant(x)} - approximant")
    print(f"loss: {abs(exp(x)-exp_approximant(x))}")

    print()


def gaussian_pdf(x, mean = 0, var = 1, exp_func = exp_maclaurin):
    denom = var #TODO: leave these stripped out * math.sqrt(2 * math.pi)
    pdf = exp_func((-1/2) * (((x-mean)/var)**2)) / denom
    return pdf


def log_taylor(x, n = 20):
    if x > 0 and x <= 2:
        sum = 0
        for i in range(1, n):
            sum += (((-1)**(i+1)) * ((x-1)**i)) / i
        return sum
    if x >= 1/2:
        sum = 0
        for i in range(1, n):
            sum += (((1 - 1/x) ** i)) / i
        return sum
    else:
        raise Exception(f"log taylor expansion not defined for {x}")

def log_bilinear(x, n = 20):
    if x > 0:
        sum = 0
        for i in range(1, n, 2):
            sum += (((x-1)/x)**i) / i
        return 2*sum
    else:
        raise Exception(f"log bilinear expansion not defined for {x}")

def log_gaussian_pdf(x, mean, var, exp_func= exp_maclaurin, log_func = log_bilinear):
    log_denom = log_func(1/var)  # * math.sqrt(2 * math.pi)
    log_pdf = log_denom + ((-1 / 2) * (((x - mean) / var) ** 2))
    return log_pdf


