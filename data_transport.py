import random

import z3

from distributions.RC import RC
from distributions.RC_Branch import Branch, RC_Branch
from distributions.RC_bernoulli import RC_Bernoulli
from distributions.RC_Unknown import RC_Unknown
from distributions.RC_beta import RC_Beta
from distributions.RC_categorical import RC_Categorical
from distributions.RC_exponential import RC_Exponential
from distributions.RC_gamma import RC_Gamma
from distributions.RC_normal import RC_Normal
from distributions.RC_poisson import RC_Poisson
from distributions.RC_uniform_discrete import RC_Uniform_Discrete
from distributions.RC_unifrom import RC_Uniform
from tools.solver import init_solver
import config



#TODO: var_choices is passed around like ping-pong ball, set as global variable


def transport_data_from_PP_model(solver):


    return take_model_from_files(solver)
    # return noise_model(solver)

def take_model_from_files(solver):
    var_choices = transport_alive_constraints(solver)  # alive constraints for the RCs

    choice_map, trace = read_model_from_dump(solver, var_choices)


    # Incorporate observations
    add_observations_to_model(solver, choice_map, config.working_dir + 'parsing_results/obs.txt')  # add normal vars as well for refereneces

    # Add fixed subset of decision variables (e.g. for block resimulation)(#TODO choose if u want to keep in trace prob compute)
    add_observations_to_model(solver, choice_map, config.run_dir + 'parsing_results/block.txt', False)  # add normal vars as well for refereneces

    # Check and add constraints for random samples that need to be fixed prior ot solving
    for elem in choice_map:
        if choice_map[elem].fixed_sample is not None and choice_map[elem].RC.is_observation == False:
            print(f"Fixed sample for {elem}: {choice_map[elem].fixed_sample}")
            solver.add(choice_map[elem].RC.value == choice_map[elem].fixed_sample)


    # Add bounds to the latent RC variables (eg. uniform[3,5] -> 3 <= x <= 5)
    add_bounds_to_latent_RC_vars(solver, choice_map)

    print("\nMODEL BEFORE OPTI\n")
    f = open(config.run_dir + "solver_results/pymodel.txt", "w")
    f.write(f"\n{solver.assertions()}")
    f.close()
    print("\n------------\n")

    save_SMT_LIB_standard_model(solver)
    return choice_map, trace


def add_bounds_to_latent_RC_vars(solver, choice_map):
    # Add sensible bounds to the model decision(latent) variable
    for key in choice_map.keys():
        if choice_map[key].RC.is_observation == False:
            # print(f"Added bounds for variable: {key}")
            choice_map[key].solver_bounds(solver)

def add_observations_to_model(solver, choice_map, filename, keep_in_trace_compute = True):
    '''Takes a file with adr = value lines and adds the values to the SMT model as constraints.'''
    # TODO (deal with Branch vars, is B == 1 enough or do i need B1 == B2 == 1
    with open(filename, 'r') as file:
        data = file.read().split("\n")
    for line in data:
        if line != "":
            var_name = line.split(" = ")[0]
            value = line.split(" = ")[1]
            solver.add(choice_map[var_name].RC.value == float(value))
            choice_map[var_name].RC.is_observation = True
            choice_map[var_name].selected = keep_in_trace_compute # Remove likelihood from trace prob compute


def transport_alive_constraints(solver):
    '''Read SMT-LIB standard constraint porlem containing the alive conditions.
    Alive constraints represent the conditions stochastic existence of their associated RC variables'''
    with open(config.working_dir + 'parsing_results/smtdump.txt', 'r') as file:
        smt = file.read()

    solver.from_string(smt) # add the alive constraints

    #map of al the assigned variables
    # Extract variables from the solver
    variables = set()
    for assertion in solver.assertions():
        variables.update(assertion.children())  # Collect sub-expressions

    # Filter only variables (ignoring constants and functions)
    variables = {v for v in variables if z3.is_const(v) and v.decl().kind() == z3.Z3_OP_UNINTERPRETED}

    # Map name of variables used in probabilistic model to their z3 object
    var_choices = dict()
    for var in variables:
        #ignore the alive variables as they are not part of the original probabilistic model
        if not var.decl().name().startswith("alive"):
            var_choices[var.decl().name()] = var

    return var_choices

def is_float(s):
    '''Checks if a string contains a float'''
    try:
        float(s)  # Attempt to convert to float
        return True
    except ValueError:
        return False

def param_in_cp(arg, choice_map, variables):
    '''Returns the object representing the Cp correspondent to the argument,
    can be a float, the value of RC decision variable, or the value of a simple varibale'''
    # Restriction: complex expression for args not allowed due to further parsing requirement at this stage or before.
    if is_float(arg):
        return float(arg)
    else:
        #TODO add another case for simple assignments: a = 2; b ~ bernoulii(a)
        if choice_map.get(arg) is not None:
            return choice_map[arg].RC.value
        return variables[arg]

def create_RC_object(choice_map, distribution_name, distribution_args, var_name, variables, solver, fixed_random_choices):
    ''' Takes the parsed distribution name and parameters and creates a RC decision varibale for the CP model'''
    #TODO: exhaustive
    if distribution_name == "bernoulli":
        choice_map[var_name] = RC_Bernoulli(RC(var_name, discrete=True), param_in_cp(distribution_args[0], choice_map, variables))
    elif distribution_name == "uniform":
        choice_map[var_name] = RC_Uniform(RC(var_name), param_in_cp(distribution_args[0], choice_map, variables), param_in_cp(distribution_args[1], choice_map, variables), solver)
    elif distribution_name == "uniform_discrete":
        choice_map[var_name] = RC_Uniform_Discrete(RC(var_name, discrete=True), param_in_cp(distribution_args[0], choice_map, variables),
                                          param_in_cp(distribution_args[1], choice_map, variables), solver)
    elif distribution_name == "normal":
        mean = param_in_cp(distribution_args[0], choice_map, variables)

        #Special treatment for variance due to difficulties in having it a decision variable in the solving process
        variance = param_in_cp(distribution_args[1], choice_map, variables)
        name = distribution_args[1]
        #if variance is a constant, either defined by value or variable, keep as is

        if choice_map.get(name) is not None:
            #If variance is a sampled RC, fix it to a radnom value (priority decision for CP)
            #Sample a random variable from the bounds given by the sample statement of the variance variable and remember it
            randomSampledDecision = choice_map[name].sample_and_fix()
            #TODO remove it from trace prob compute as an option
            # print(f"Variance {variance} gets fixed value of:  {randomSampledDecision}")
            #TODO: push and pop this random decision in case its not fruitfull instead of doing it at the beginning

            # This is done later if variance does not have an observations alerady: solver.add(variance == randomSampledDecision)


        choice_map[var_name] = RC_Normal(RC(var_name), mean, variance, solver)
    elif distribution_name == "unknown":
        choice_map[var_name] = RC_Unknown(RC(var_name))

    # TODO: do variance special treatment for poisson, beta and gamma
    elif distribution_name == "beta":
        choice_map[var_name] = RC_Beta(RC(var_name), param_in_cp(distribution_args[0], choice_map, variables), param_in_cp(distribution_args[1], choice_map, variables),solver)
    elif distribution_name == "gamma":
        choice_map[var_name] = RC_Gamma(RC(var_name), param_in_cp(distribution_args[0], choice_map, variables),
                                       param_in_cp(distribution_args[1], choice_map, variables), solver)
    elif distribution_name == "poisson":
        choice_map[var_name] = RC_Poisson(RC(var_name, discrete = True), param_in_cp(distribution_args[0], choice_map, variables),solver)

    elif distribution_name == "exponential":
        choice_map[var_name] = RC_Exponential(RC(var_name), param_in_cp(distribution_args[0], choice_map, variables))

    elif distribution_name == "categorical":
        # TODO to allow arrays, each array elem has to be converted to cp object

        #Assumes line is given as x ~ categorical([0.2,0.3, ...])
        probabilities = [eval(part.strip('[] ')) for part in distribution_args]
        choice_map[var_name] = RC_Categorical(RC(var_name, discrete = True), probabilities)

    else:
        raise Exception(f"{distribution_name} distribution not supported")

def parse_sample_line(sample):
    '''Parses a sample line from the variable-dump.txt'''
    var_name = sample.split(" ~ ")[0]
    distribution = sample.split(" ~ ")[1]
    distribution_name = distribution.split("(")[0]
    distribution_args = distribution.split("(")[1].split(")")[0].split(", ")
    return var_name, distribution_name, distribution_args
def read_model_from_dump(solver, var_choices):
    '''Reads the RC variables that are going be added to the CP model'''
    choice_map = dict()

    fixed_random_choices = dict() # will hold a the names of choices that will need to be fixed prior to solving

    with open(config.working_dir + 'parsing_results/vardump.txt', 'r') as file:
        data = file.read().split("\n")
    for line in data:
        if line != "":
            # Parse the RC sample statement
            sample = line.split(" in ")[0]
            var_name, distribution_name, distribution_args = parse_sample_line(sample)

            # Create RC object and add to choice_map
            create_RC_object(choice_map, distribution_name, distribution_args, var_name, var_choices, solver, fixed_random_choices)


    #Set correct likelihooddv: for all RC distributions that are known
    for var in choice_map.keys():
        if not isinstance(choice_map[var], RC_Unknown):
            solver.add(choice_map[var].likelihooddv == choice_map[var].estim_likelihood(choice_map[var].RC.value))
    # For unknown RCs, likelihood depends on the stochastic alternatives


    # Naive scheme for dealing with branch alternatives: collecting and aggregating alternatives for a RC with stchastic existance
    for var in choice_map.keys():
        if isinstance(choice_map[var], RC_Unknown):
            # there are multiple alternatives for the current variable
            alive_unknown = False # main is alive if any of the alternatives are alive
            for alt in choice_map.keys():
                if alt.startswith(f"{var}_" ):
                    # if alternative is alive, main takes likelihood and value of alternative
                    solver.add(z3.If(choice_map[alt].alive == True,
                                     z3.And(choice_map[var].likelihooddv == choice_map[alt].likelihooddv,
                                            choice_map[var].RC.value == choice_map[alt].RC.value), True))

                    # compute maine alive recursively:  if any of the alternatives are alive
                    alive_unknown = z3.Or(alive_unknown, choice_map[alt].alive)

            # main is alive if any of the alternatives are alive
            solver.add(choice_map[var].alive == alive_unknown)

    # print(solver)
    # print("----")

    #TODO not in the order anymore since the order is not maintained in the dictionary, is this necessary??
    #Collect unique names, without their alternatives
    trace = []
    for var in choice_map.keys():
        # if var doesn't contain "_", add it to the trace
        if not "_" in var:
            trace.append(var)

    return choice_map, trace

def save_SMT_LIB_standard_model(solver, file = "smtmodels/simplepp_model_SMTLIB.smt2"):
    """Saves a model in SMT-LIB standard format."""
    with open(file, "w") as f:
        f.write(solver.to_smt2())

# solver = init_solver()
#
# choice_map, trace = transport_data_from_PP_model(solver)


# DEPRECATED
# #IF ENCODINGS - encode simple if statements
# for key in choice_map.keys():
#     if isinstance(choice_map[key], RC_Branch):
#         choice_map[key].introduce_aux_variables(solver)
