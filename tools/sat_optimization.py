import math
import z3

from tools.numerical import floaty
up = None

def check_new_upper_constraint_sat(var, upper, solver):
    '''Verifies if var <= upper constraint can be satisfied in the current model'''
    print("Checking new bound: {upper}")
    solver.set("timeout", 2000) #set timeout for checks

    solver.push() # save previous assertion stack
    solver.add(var <= upper) # push experimental domain contraction
    sat = solver.check() == z3.sat
    solver.pop() #restore assertion stack window

    solver.set("timeout", 4294967295)  # unset timeout
    return sat

# def update_upper_bound(var, upper_bound, solver):
#     '''Tries different strategies to optimize(lower) an upper bound for a given decision variable,
#     returns False if no optimization is possible or new bound otherwise'''
#
#     upper_bound = floaty(upper_bound)
#     #Update with (-oo, -1), (-1,0), etc ranges
#     if check_new_upper_constraint_sat(var, math.sqrt(upper_bound), solver): # aggressive
#         print(f"aggressive succeeds: {math.sqrt(upper_bound)}")
#         return math.sqrt(upper_bound)
#     elif check_new_upper_constraint_sat(var, upper_bound / 2, solver): # binary search
#         print(f"binary succeeds: {upper_bound/2}")
#         return upper_bound/2
#     elif check_new_upper_constraint_sat(var, math.floor(upper_bound), solver): # conservative
#         print(f"conservative succeeds: {math.floor(upper_bound)}")
#         return math.floor(upper_bound)
#     else:
#         return None


def add_lower_bound_to_model(var, lower, solver):
    solver.add(var >= lower)

def check_new_lower_constraint_sat(var, lower, solver):
    '''Verifies if var >= upper constraint can be satisfies in the current model'''
    print(f"Checking new lower bound: {lower}")
    solver.set("timeout", 20000)  # set timeout for checking model with new bounds

    solver.push() # save previous assertion stack
    solver.add(var >= lower) # push experimental domain contraction
    sat = solver.check() == z3.sat
    solver.pop() #restore assertion stack window

    solver.set("timeout", 4294967295)  # unset timeout
    print(f"sat?: {sat}")
    return sat

def under_up(lb):
    '''Checks if the lower bound is under the upper bound
    to prevent redundant/repetitive checks'''
    if up is None:
        return True
    else:
        return lb <= up #TODO = here looks like a inf loop?

def update_up(lb):
    '''Tightens upper bound'''
    global up
    if up is None or lb < up:
        up = lb


def update_0_1_bounde_lower_bound(var, lower_bound, solver): #TODO: maybe do this without a given lower bound, try binary on the range dirrectly instead of progressive addition
    '''Tries diffrerent strategies to tighten the lower bound of qa variable var in the 0,1 range. Given the variable is bound to the [0,1] range'''
    if check_new_lower_constraint_sat(var, lower_bound + 0.3, solver):
        return lower_bound + 0.3
    if check_new_lower_constraint_sat(var, lower_bound + 0.1, solver):
        return lower_bound + 0.1
    if check_new_lower_constraint_sat(var, lower_bound + 0.01, solver):
        return lower_bound + 0.01
   # if check_new_lower_constraint_sat(var, lower_bound + 0.001, solver)
      #  return lower_bound + 0.001
def update_lower_bound(var, lower_bound, solver): #TODO: needs verification-testing, also fix duplication (maybe incroporate update in)
    '''Tries different strategies to optimize(lower) an upper bound for a given decision variable,
    returns False if no optimization is possible or new bound otherwise'''
    lower_bound = floaty(lower_bound)
    print(f"attempting to update lower bound of {lower_bound}")

    #TODO slplit interval between lb and up and try to find new possible lb there instead of just static
    if lower_bound > 1:
        # lower_bound ** 2,lower_bound * 2, #TODO add back? too aggressive and loose time
        possible_lb_updates = [ lower_bound *2, lower_bound + 1, math.ceil(lower_bound),
                               lower_bound + 0.1, lower_bound + 0.01, lower_bound + 0.001]
        for lb in possible_lb_updates:
            if under_up(lb) and check_new_lower_constraint_sat(var, lb, solver):
                return lb
            else:
                update_up(lb)
        # return None

    elif lower_bound > -1: # (-1, 0) & [0, 1) range
        # quirk: if lb is int, then math.ceil(lb) = lb, and would go into inf loop
        possible_lb_updates = [lower_bound + 1, math.ceil(lower_bound + 0.0001), lower_bound + 0.1, lower_bound + 0.01]
        for lb in possible_lb_updates:
            if under_up(lb) and check_new_lower_constraint_sat(var, lb, solver):
                return lb
            else:
                update_up(lb)

    else: # (-oo, -1] range
        #TODO is math.ceil a infinite loop trap here?
        possible_lb_updates = [lower_bound/2, lower_bound + 1, math.ceil(lower_bound)]
        for lb in possible_lb_updates:
            if under_up(lb) and check_new_lower_constraint_sat(var, lb, solver):
                return lb
            else:
                update_up(lb)
    return None
