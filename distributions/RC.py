from abc import ABC, abstractmethod
import z3

class RC(object):
    def __init__(self, name, observation = None, discrete = False):
        self.name = name
        if observation is None:  # its a decision variable
            if discrete:
                self.value = z3.Int(name)
            else:
                self.value = z3.Real(name)  # TODO choose type based on distribution
        if observation is None:
            self.is_observation = False
        else:
            self.value = observation #TODO remove this line after obs incoporation
            self.is_observation = True

class RC_Distribution(ABC):
    def __init__(self, RC):
        self.RC = RC
        self.alive = z3.Bool(f'alive{RC.name}')  # Alive for trace probability computation in the objective function #TODO is this a z3 val?
        self.selected = True  # Selected for trace probability computation in the objective function
        self.likelihooddv = z3.Real(f'likelihood{RC.name}')  # Likelihood for trace probability computation in the objective function

        self.fixed_sample = None # used for fixing values before CP solving (e.g. in the case of normal distribution variance)


    @abstractmethod
    def true_likelihood(self, x):
        """Compute the likelihood of the data given the distribution parameters."""
        pass

    @abstractmethod
    def estim_likelihood(self, x):
        """Compute the likelihood of the data given the distribution parameters."""
        pass

    @abstractmethod
    def solver_bounds(self, solver, is_observation):
        """Compute the likelihood of the data given the distribution parameters."""
        print("all is abstr")
        pass

    @abstractmethod
    def sample(self):
        """Samples a value from the distribution,
        but within the [restricted] bounds used for the CP model of the distribution"""
        # Important: the sample should be within the bounds of the CP model given in the solver_bounds method
        pass

    def sample_and_fix(self):
        """Samples a value from the distribution,
        and saves it for later use to constrain a RC decision variable in the CP model"""
        if self.fixed_sample is None:
            self.fixed_sample = self.sample()
        return self.fixed_sample

    # @abstractmethod TODO
    # def distribution_support_constraints(self, solver):
    #     """Adds distribution support constraints to the solver
    #     in case the parameters are decision variables."""
        #TODO warning that variance is a decision variable which may impact solving for distr like normal, or that use gaussian mixture approximamtion
    #     pass
