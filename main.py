import math
import sys
import time

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
start_time = None

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

def solver_opti_loop(solver, trace_prob, iter_resources = 10, log = False, plot=True):
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


        # update trace_prob lower bound, use current model trace value as lower bound
        current = m[trace_prob].as_decimal(20)
        new_lower_bound = update_lower_bound(trace_prob, current, solver)
        if new_lower_bound:
            if log:
                print(f"new lower bound for trace probability found: {new_lower_bound}")
            solver.add(trace_prob >= float(new_lower_bound))  # Add new bound as constraint
        else: # if no new lower bound can be found, optimization is done
            break;

        iter += 1
        if iter % 5 == 0:
            if m is not None:
                save_model_solution(m, f"solver_results/intermediate_solution{iter}.txt", likelihoods = True)

    print(f"Final Model: {m}")
    end_time = time.time()
    print(f"SAT Exec time: {end_time - start_time:.4f}")
    if m is not None:
        save_model_solution(m)
        if phase == 1:
            # Save trace prob to be used in phase 0
            with open(config.run_dir + "solver_results/trace_prob_to_improve.txt", "w") as f:
                f.write(f"{m[trace_prob]}")
            f.close
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


def use_manual_optimiz_loop(phase):
    solver = init_solver()

    choice_map, trace, soft_preferences = transport_data_from_PP_model(solver, phase)

    global tracey
    tracey = trace
    # Compute trace probability estimation
    # select_vars_to_include_in_trace_prob_computation(choice_map)
    # trace_prob_estim = compute_trace_prob_estim(trace, choice_map)

    trace_prob_estim = copmute_trace_prob_estim_from_likelihood_dv(trace, choice_map)
    # Trace prob estimation will be the objective function to minimize
    trace_prob = z3.Real("trace_prob")
    solver.add(trace_prob == trace_prob_estim)

    if phase == 0 and os.path.exists(config.run_dir + 'solver_results/trace_prob_to_improve.txt'):
        with open(config.run_dir + 'solver_results/trace_prob_to_improve.txt', "r") as f:
            line = f.read().strip()
            val = float(eval(line))  # or use Fraction, if you want exact math
        # print(val)
        solver.add(trace_prob > val)

    global start_time
    start_time = time.time()
    save_SMT_LIB_standard_model(solver)

    # Maximize number of soft_constraints (preferences) via binary search
    max_soft_constr = len(soft_preferences)
    if max_soft_constr > 0:
        # Add counter for the number of soft constraints satisfied by the solution
        sum = 0
        for i in soft_preferences:
            sum += i
        satisfied_preferences = z3.Int("satisfied_preferences")
        solver.add(satisfied_preferences == sum)

        if phase == 0: #ignore soft if just computing current trace prob
            maximize_soft_constr_naive_binary_search(max_soft_constr, satisfied_preferences, solver)

            # solver.add(satisfied_preferences >= max_soft_constr)

        # HARD CONSTRAINTS INSTEAD #c4
        # for i in soft_preferences:
        #     solver.add(i == 1)

    # Trace prob Optimization loop
    solver_opti_loop(solver, trace_prob, log=True)


def maximize_soft_constr_naive_binary_search(max_soft_constr, satisfied_preferences, solver):
    print(f"Maximizing soft constraints ...out of {max_soft_constr}")
    # First check if all soft constraints are satisfiable
    solver.push()
    solver.add(satisfied_preferences >= max_soft_constr)  # TODO: why is it that if i put "==" here it takes forever??
    if solver.check() == z3.sat:
        last = max_soft_constr
        print(":p")
    else:
        print("Not all soft constraints are satisfiable, using binary search to find max satisfiable soft constraints")
        solver.pop()
        last = 0
        left = 0
        right = max_soft_constr
        solver.set("timeout",
                   150000)  # set timeout for checks at 5' #  TODO account for solver taking longer the smaller mid is
        while (
                left <= right):  # TODO cap at depth depending on #soft_constr? knowing precicely how many soft constr is not as important as maintianing most of them
            mid = (left + right) // 2
            solver.push()
            solver.add(satisfied_preferences >= mid)
            if solver.check() == z3.sat:
                # mid is a possible solution
                print(f"soft >= {mid}")
                left = mid + 1
                last = mid
                save_model_solution(solver.model(), f"solver_results/pref_solution{mid}.txt", likelihoods=True)
            else:
                # TODO check if addign following constraint makes it faster
                # solver.add(satisfied_preferences < mid ) # have to make sure its poped properly
                print(f"soft < {mid}")
                # mid is not a possible solution
                right = mid - 1
            solver.pop()
    solver.set("timeout", 4294967295)  # unset timeout
    print(f"Max soft constraints: {last}")
    solver.add(satisfied_preferences >= last)


#Setup file paths
# Probabilisitc problem directory
# working_dir = ""#TODO get from run args[]
# run_dir = #TODO get from run args[] or determine through name conflict; create on the spot

config.run_option = ""
if len(sys.argv) > 1:
    config.working_dir = sys.argv[1]
    config.run_dir = sys.argv[2]
    if len(sys.argv) > 3:
        config.run_option = sys.argv[3]

else:
    config.working_dir = "/home/mars/Documents/Documents/Study/Master/thesis/pipe/testing/"
    config.run_dir = "/home/mars/Documents/Documents/Study/Master/thesis/pipe/testing/"

phase = 0
import os
if os.path.isfile(config.run_dir + "parsing_results/current_trace.txt"):
    phase = 1
print(f"PHASE: {phase}")
use_manual_optimiz_loop(phase)
if phase == 1:
    # phase 1 would save the current trace prob and subsequent solver will try to improve it
    phase = 0
    print(f"PHASE: {phase}")
    use_manual_optimiz_loop(phase)








