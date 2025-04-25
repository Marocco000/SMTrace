"""File containing toy probabilistic models manualy transformed into SMT models"""
#DEPRECATED
import z3

from data_transport import add_bounds_to_latent_RC_vars
from distributions.RC import RC
from distributions.RC_Branch import Branch, RC_Branch
from distributions.RC_Unknown import RC_Unknown
from distributions.RC_bernoulli import RC_Bernoulli
from distributions.RC_unifrom import RC_Uniform
from distributions.RC_normal import RC_Normal
from tools.symbolic import sym_or, sym_and

def play_model(solver):
    return simple_if_model_like_var2(solver)

def noise_model(solver):
    """TODO: fix noise as decision var
    noise ~ Normal(10, 1)
    gauss ~ Normal(100, noise)"""
    choice_map = dict()

    choice_map['noise'] = RC_Normal(RC('noise'), 10, 1, solver)
    noise = choice_map['noise'].RC.value
    choice_map['gauss'] = RC_Normal(RC('gauss'), 100, noise, solver)
    solver.add(noise != 0)

    add_bounds_to_latent_RC_vars(solver, choice_map)

    for var in choice_map.keys():
        if not isinstance(choice_map[var], RC_Unknown):
            solver.add(choice_map[var].likelihooddv == choice_map[var].estim_likelihood(choice_map[var].RC.value))

    print(solver)

    trace = [choice_map['noise'].RC.name, choice_map['gauss'].RC.name]
    return choice_map, trace

def dependent_model(solver):
    '''Models the following probbailistic prgoam:
    A~Unif(0.5, 0.7)
    B~Ber(A)
    OBS(B == 1)'''
    # MODEL
    choice_map = dict()
    # decision vars = latent RCs
    # choice_map['A'] = RC_Bernoulli(RC('A'), 0.5)
    choice_map['A'] = RC_Uniform(RC('A'), 0.5, 0.7)
    A = choice_map['A'].RC.value
    # likelihood_A = z3.Real('likelihood_A')
    # solver.add(likelihood_A == choice_map['A'].estim_likelihood(A))
    likelihood_A = choice_map['A'].estim_likelihood(A)
    choice_map['B'] = RC_Bernoulli(RC('B', 1), A)
    B = choice_map['B'].RC.value
    # likelihood_B = z3.Real('likelihood_B')
    # solver.add(likelihood_B == choice_map['B'].estim_likelihood(B))
    likelihood_B = choice_map['B'].estim_likelihood(B)

    trace = []
    return choice_map, trace, likelihood_A, likelihood_B, 1, 1# alive_A, alive_B

def simple_if_model_like_var2(solver):
    '''Models the following probailistic prgoam with likelihood variables:
    A~Ber(0.5)
    If (A)
        B ~ Ber(0.1)
    else
        C ~ Unif(0.7, 0.9)
        B ~ Ber(C)
    OBS(B == 1)'''
    # MODEL

    # Pass 1: collect unique addresses from PP, all possible components that could take part in the trace probability compuation
    trace = ['A', 'B', 'C']


    choice_map = dict()
    # decision vars = latent RCs
    choice_map['A'] = RC_Bernoulli(RC('A'), 0.5)
    likelihood_A = choice_map['A'].estim_likelihood(choice_map['A'].RC.value)
    choice_map['A'].likelihooddv = likelihood_A


    # Pass 2: Identify forever alive variables and
    # 3 types of variables: forever alive + same distr, forever alive+ differnt distro, brtanches; maybe not alie, dif distr
    # types 2 and 3 are treated the same, where alive variable is determined by branch; type 1 gets alive = 1 set
    for adr in forever_alive_addresses():
        choice_map[adr].alive = 1
        solver.add(choice_map[adr].alive == 1)

    #Branch encoding
    B1 = RC_Bernoulli(RC('B1', 1), 0.1)
    likelihood_B1 = B1.estim_likelihood(B1.RC.value)

    C2 = RC_Uniform(RC('C2'), 0.7, 0.9)
    likelihood_C2 = C2.estim_likelihood(C2.RC.value)
    B2 = RC_Bernoulli(RC('B2', 1), C2.RC.value)
    # B2 = RC_Bernoulli(RC('B2', 1), 0.9)
    likelihood_B2 = B2.estim_likelihood(B2.RC.value)

    A = choice_map['A'].RC.value  # TODO references are needed to write conditionals, so these should be extracted
    # branch_collection = []  # TODO find a way to collect conditionals and their corresponding RC assignment
    # branch_collection.append(Branch(A == 1, B1))
    # branch_collection.append(Branch(A == 0, B2))

    B = RC_Unknown(RC('B',1))
    C = RC_Unknown(RC('C'))
    # B = RC_Branch(RC('B', 1), branch_collection)
    # likelihood_B = z3.Real('likelihood_B')
    # likelihood_C = z3.Real('likelihood_C')
    # B.likelihooddv = likelihood_B
    # C.likelihooddv = likelihood_C
    likelihood_B = B.likelihooddv
    likelihood_C = C.likelihooddv


    # solver.add(z3.If(A == 1,
    #                  z3.And(likelihood_B == likelihood_B1, B.RC.value == B1.RC.value),
    #                  z3.And(likelihood_C == likelihood_C2,
    #                             C.RC.value == C2.RC.value,
    #                             likelihood_B == likelihood_B2,
    #                             B.RC.value == B2.RC.value)))
    # solver.add(z3.If(A == 1,
    #                  z3.And(likelihood_B == likelihood_B1,
    #                         B.RC.value == B1.RC.value),
    #                  z3.And(
    #                      # likelihood_C == likelihood_C2,
    #                      #        C.RC.value == C2.RC.value,
    #                             likelihood_B == likelihood_B2,
    #                             B.RC.value == B2.RC.value)))

    solver.add(z3.If(A == 1,
                     z3.And(B.likelihooddv == B1.estim_likelihood(B1.RC.value),
                            B.RC.value == B1.RC.value),
                     z3.And(
                         # likelihood_C == likelihood_C2,
                         #        C.RC.value == C2.RC.value,
                                likelihood_B == B2.estim_likelihood(B2.RC.value),
                                B.RC.value == B2.RC.value)))


    solver.add(z3.And(likelihood_C == likelihood_C2,
                                C.RC.value == C2.RC.value))
    # alive_B = z3.Bool('alive_B')
    solver.add(B.alive == z3.Or((A == 1 , A == 0)) )
    # B.alive = alive_B
    # alive_B = A == 1 or A == 0


    # alive_C = z3.Int('alive_C')
    solver.add(C.alive == (A==0))
    # C.alive = alive_C

    choice_map['B'] = B
    choice_map['B1'] = B1
    choice_map['B2'] = B2
    choice_map['C'] = C
    choice_map['C2'] = C2

    # Trace -  this should be similar to the PP trace, maintains order of sample statements
    # TODO do we have a use for this?
    # TODO make auto (maybe at same time as choice map addition)
    # TODO: trace doesnt give branch information or alternatives..
    trace = []
    trace.append('B')
    trace.append('A')

    trace.append('C')
    print(solver)
    print("--------")
    #TODO remove after automated
    return choice_map, trace#, likelihood_A, likelihood_B, likelihood_C, alive_A, alive_B, alive_C



def simple_if_model_like_var(solver):
    '''Models the following probbailistic prgoam with likelihood variables:
    A~Ber(0.5)
    If (A)
        B ~ Ber(0.1)
    else
        B ~ Ber(0.9)
    OBS(B == 1)'''
    # MODEL
    choice_map = dict()
    # decision vars = latent RCs
    choice_map['A'] = RC_Bernoulli(RC('A'), 0.5)
    likelihood_A = choice_map['A'].estim_likelihood(choice_map['A'].RC.value)

    #Branch encoding
    B1 = RC_Bernoulli(RC('B1', 1), 0.1)
    likelihood_B1 = B1.estim_likelihood(B1.RC.value)
    B2 = RC_Bernoulli(RC('B2', 1), 0.9)
    likelihood_B2 = B2.estim_likelihood(B2.RC.value)

    A = choice_map['A'].RC.value  # TODO references are needed to write conditionals, so these should be extracted
    branch_collection = []  # TODO find a way to collect conditionals and their corresponding RC assignment
    branch_collection.append(Branch(A == 1, B1))
    branch_collection.append(Branch(A == 0, B2))

    B = RC_Unknown(RC('B',1))
    # B = RC_Branch(RC('B', 1), branch_collection)
    likelihood_B = z3.Real('likelihood_B')
    solver.add(z3.If(A == 1, #TODO is the second equation needed?
                     likelihood_B == likelihood_B1 and B.RC.value == B1.RC.value,
                     likelihood_B == likelihood_B2 and B.RC.value == B2.RC.value))
    choice_map['B'] = B

    # Trace -  this should be similar to the PP trace, maintains order of sample statements
    # TODO do we have a use for this?
    # TODO make auto (maybe at same time as choice map addition)
    # TODO: trace doesnt give branch information or alternatioves..
    trace = []
    trace.append('A')
    trace.append('B')

    #TODO remove after automated
    return choice_map, trace, likelihood_A, likelihood_B


def simple_if_model(solver):
    '''Models the following probbailistic prgoam:
    A~Ber(0.5)
    If (A)
        B ~ Ber(0.1)
    else
        B ~ Ber(0.9)
    OBS(B == 1)'''
    # MODEL
    choice_map = dict()
    # decision vars = latent RCs
    choice_map['A'] = RC_Bernoulli(RC('A'), 0.5)

    #Branch encoding
    B1 = RC_Bernoulli(RC('B1', 1), 0.1)
    B2 = RC_Bernoulli(RC('B2', 1), 0.9)
    A = choice_map['A'].RC.value  # TODO references are needed to write conditionals, so these should be extracted
    branch_collection = []  # TODO find a way to collect conditionals and their corresponding RC assignment
    branch_collection.append(Branch(A == 1, B1))
    branch_collection.append(Branch(A == 0, B2))


    B = RC_Branch(RC('B', 1), branch_collection)
    choice_map['B'] = B

    # Trace -  this should be similar to the PP trace, maintains order of sample statements
    # TODO do we have a use for this?
    # TODO make auto (maybe at same time as choice map addition)
    # TODO: trace doesnt give branch information or alternatioves..
    trace = []
    trace.append('A')
    trace.append('B')

    return choice_map, trace


    return 1
def burglar_model(solver):
    '''Models following burglar model:
    earthquake = Bernoulli(0.001);
    3: burglary = Bernoulli(0.01);
    4: alarm = earthquake || burglary;
    5: if (earthquake)
    6: phoneWorking = Bernoulli(0.6);
    7: else
    8: phoneWorking = Bernoulli(0.99);
    9: if (alarm && earthquake)
    10: maryWakes = Bernoulli(0.8);
    11: else if (alarm)
    12: maryWakes = Bernoulli(0.6);
    13: else
    14: maryWakes = Bernoulli(0.2);
    15: called = maryWakes && phoneWorking;
    16: observe(called);'''
    # MODEL
    choice_map = dict()
    # decision vars = latent RCs
    choice_map['earthquake'] = RC_Bernoulli(RC('earthquake'), 0.001)
    choice_map['burglary'] = RC_Bernoulli(RC('burglary'), 0.01)
    earthquake = choice_map['earthquake'].RC.value
    burglary = choice_map['burglary'].RC.value

    alarm = sym_or([earthquake, burglary]) #TDOO decision var ??

    #first if statement
    phoneworking1 = RC_Bernoulli(RC('phoneworking1', 1), 0.6)
    phoneworking2 = RC_Bernoulli(RC('phoneworking2', 1), 0.99)
    phoneworking = RC_Branch(RC('phoneworking', 1),
                             [Branch(earthquake == 1, phoneworking1),
                                        Branch(earthquake == 0, phoneworking2)])
    choice_map['phoneworking'] = phoneworking

    #second if statement
    marywakes1 = RC_Bernoulli(RC('marywakes1', 1), 0.8)
    marywakes2 = RC_Bernoulli(RC('marywakes2', 1), 0.6)
    marywakes3 = RC_Bernoulli(RC('marywakes3', 1), 0.2)
    marywakes = RC_Branch(RC('marywakes', 1),
                          [Branch((earthquake== 1 or burglary==1) and earthquake == 1, marywakes1),
                                    Branch((earthquake== 1 or burglary==1) and earthquake == 0, marywakes2),
                                    Branch((earthquake== 0 and burglary==0), marywakes3)])
    choice_map['marywakes'] = marywakes

    # called = sym_and([marywakes.RC.value , phoneworking.RC.value]) #TODO THIS IS NOT CORRECT SYNCED WITH BRANCH VAL
    # solver.add(mary) #observation #TODO has to be handeled diff

    # Trace -  this should be similar to the PP trace, maintains order of sample statements
    # TODO do we have a use for this?
    # TODO make auto (maybe at same time as choice map addition)
    # TODO: trace doesnt give branch information or alternatioves..

    trace = []
    trace.append('earthquake')
    trace.append('burglary')
    trace.append('phoneworking')
    trace.append('marywakes')

    return choice_map, trace

def forever_alive_addresses():
    '''Parses the PP program and return of list of unique address names that are forever alive
    (are not defined within if-else brances)'''
    return ['A']