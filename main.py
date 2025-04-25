import math
import sys

import matplotlib.pyplot as plt
import numpy as np
import z3

# from choice import Choice
from distributions.RC import RC
from distributions.RC_Branch import RC_Branch, Branch
from distributions.RC_bernoulli import RC_Bernoulli
from distributions.RC_normal import RC_Normal
# from plotting.essentials import plot_linear_regression
from data_transport import transport_data_from_PP_model, save_SMT_LIB_standard_model
from tools.numerical import floaty
from tools.sat_optimization import update_lower_bound
from tools.solver import init_solver

import config


'''
Simple If statement program:
A~Ber(0.5)
If (A)
	B ~ Ber(0.1)
else
	B ~ Ber(0.9)
OBS(B == 1)

- By running OPT on this we find A == 1.
- If we runn the same thing without observation statement, then we also get a high probability trace
'''


tracey = [] # Used as a hacky way to print out only choice_map decision vars for the final model


def select_vars_to_include_in_trace_prob_computation(choice_map, option="ALL", custom=[]):
    '''Selects the variables to include in the trace probability computation
        options = ALL, PRIOR, POST, CUSTOM
        @param choice_map: dict of variable names and their choice objects
        @param option: string option
        @param custom: list of variable names to include in the trace computation
    '''

    for key in choice_map.keys():
        choice_map[key].selected = False

    if option == "ALL":
        for key in choice_map.keys():
            choice_map[key].selected = True
    elif option == "POST":
        for key in choice_map.keys():
            if choice_map[key].RC.is_observation == True:
                choice_map[key].selected = True
    elif option == "PRIOR":
        for key in choice_map.keys():
            if choice_map[key].RC.is_observation == False:
                choice_map[key].selected = True
    elif option == "CUSTOM":
        for key in custom:
            choice_map[key].selected = True


def sum(a, b):
    return a + b
def prod(a, b):
    return a * b
def compute_trace_prob_estim(trace, choice_map, compound_func = sum):
    '''Computes estimated trace prob
        @param trace: list of variable names in the order they were defined
        @param choice_map: dict of variable names and their choice objects
        @param compound_func: function to compound the likelihood (sum, mult)
    '''
    #TODO its not working with prod for simple programs? why?
    pdfi = 0

    for key in trace:
        if (choice_map[key].selected == True):
            print("included in trace compute: " + key)
            pdfi = compound_func(pdfi, choice_map[key].estim_likelihood(choice_map[key].RC.value))

    return pdfi

def copmute_trace_prob_estim_from_likelihood_dv(trace, choice_map, compound_func = sum):
    '''Computes estimated trace prob
        @param trace: list of variable names in the order they were defined
        @param choice_map: dict of variable names and their choice objects
        @param compound_func: function to compound the likelihood (sum, mult)
    '''
    #TODO its not working with prod for simple programs? why?
    pdfi = 0
    for key in trace:
        if (choice_map[key].selected == True):
            print("included in trace compute: " + key)
            pdfi = compound_func(pdfi, choice_map[key].likelihooddv * choice_map[key].alive)

    return pdfi

def solver_opti_loop(solver, trace_prob, iter_resources = 1, log = False, plot=True):
    '''Manual optimization loop that maximizes the trace probability'''
    #TODO: LOG decision variables
    #TODO: is this using incremental solving in th emain loop or restars CP??
    #TODO: make plots into gif as well

    # Manual optimization loop that updates the lower bound of the trace probability
    m = None
    iter = 0
    print("Solving...")
    while solver.check() == z3.sat and iter <= iter_resources:
        m = solver.model()

        if log:
            print(f"Model : {m}")
            print(f"Maximized trace_prob: {m[trace_prob]}")
        # if plot:
        #     plot_linear_regression(xs, ys, floaty(m[sloperc].as_decimal(20)), floaty(m[biasrc].as_decimal(20)),
        #                        title=f"iter {iter}")

        # update trace_prob lower bound, use current model trace value as lower bound
        # current = m[trace_prob].as_decimal(20)
        # new_lower_bound = update_lower_bound(trace_prob, current, solver)
        # if new_lower_bound:
        #     if log:
        #         print(f"new lower bound for trace probability found: {new_lower_bound}")
        #     solver.add(trace_prob >= float(new_lower_bound))  # Add new bound as constraint
        # else: # if no new lower bound can be found, optimization is done
        #     break;
        iter += 1
        if iter %5 == 0:
            if m is not None:
                save_model_solution(m, f"{config.run_dir}solver_results/intermediate/intermediate_solution{iter}.txt", likelihoods = True)

    print(f"Final Model: {m}")
    if m is not None:
        save_model_solution(m)
    if m is None:
        #TODO: for this to show an unsat core, all added constraints have to be tracked and named
        # with s.assert_and_track(constraint , 'consraint_name')
        with open(config.run_dir + "solver_results/model_solution.txt", "w") as f:
            f.write("")
        f.close
        print(f"Unsat core: {solver.unsat_core()}")

def save_model_solution(m, file = "solver_results/model_solution.txt", likelihoods = False):
    '''Saves the model solution representing the trace.'''

    print(f"saving model solution (for likelihoods ={likelihoods})")
    with open(config.run_dir + file, "w") as f:
        for d in m.decls():
            # ignore alive variables and likelihood variables
            if "alive" in d.name():
                continue
            if likelihoods:
                if "likelihood" in d.name():
                    continue
            # ignore the trace probability variable
            # if "trace_prob" in d.name():
            #     continue

            # ignore the assignment variables 
            if not d.name() in tracey:
                continue

            # ignore (branch) alternatives variables
            if "_" in d.name():
                continue

            #ignore observed variables? TODO

            # write the variable name and its value
            f.write(f"{d.name()} = {m[d]}\n")
        f.close


def use_manual_optimiz_loop():
    solver = init_solver()

    choice_map, trace = transport_data_from_PP_model(solver)

    global tracey
    tracey = trace
    # Compute trace probability estimation
    # select_vars_to_include_in_trace_prob_computation(choice_map)
    # trace_prob_estim = compute_trace_prob_estim(trace, choice_map)
    # trace_prob_estim = likelihood_A + likelihood_B

    # trace_prob_estim = likelihood_A*alive_A + likelihood_B*alive_B + likelihood_C*alive_C
    trace_prob_estim = copmute_trace_prob_estim_from_likelihood_dv(trace, choice_map)
    # Trace prob estimation will be the objective function to minimize
    trace_prob = z3.Real("trace_prob")
    solver.add(trace_prob == trace_prob_estim)

    save_SMT_LIB_standard_model(solver)

    # Optimization loop

    solver_opti_loop(solver, trace_prob, log=True)


# DATA
# xs = [1, 2, 3, 4, 5]
# # ys = [1, 2, 3, 4, 5]
# # ys = [3.2, 4.001, 5.002, 5.89, 7.01]
#
# xs = [-5., -4., -3., -2., -1., 0., 1., 2., 3., 4., 5.]
# ys = [6.75003, 6.1568, 4.26414, 1.84894, 3.09686, 1.94026, 1.36411, -0.83959, -0.976, -1.93363, -2.91303]
#

#Setup file paths
# Probabilisitc problem directory
# working_dir = ""#TODO get from run args[]
# run_dir = #TODO get from run args[] or determine through name conflict; create on the spot

if len(sys.argv) > 1:
    config.working_dir = sys.argv[1]
    config.run_dir = sys.argv[2]
else:
    config.working_dir = "/home/mars/Documents/Documents/Study/Master/thesis/pipe/testing/"
    config.run_dir = "/home/mars/Documents/Documents/Study/Master/thesis/pipe/testing/"

use_manual_optimiz_loop()









