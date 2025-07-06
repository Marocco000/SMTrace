
working_dir = ""
run_option = ""  # "block", "current trace", "restrictions"
block = False
optimize_current_trace = False
restrictions = False
# max_iterations = 1000
# solver_timeout = 10000
# solver_max_time = 10000
optimize = True # if the manual opti loop is runned
soft_latent = False # if the bounds for latent vars are soft or hard
soft_observation = True


def set_run_option(run_option):
    global block, optimize, restrictions, optimize_current_trace
    if run_option == "block":
        block = True
    elif run_option == "current trace":
        optimize_current_trace = True
        # optimize = False # returns first trace > current trace
    elif run_option == "restrictions":
        restrictions = True


# class RunOptions(object):
#     def __init__(self):
#         self.run_option = "" # "block", "current trace", "restrictions"
#         self.block = False
#         self.optimize_current_trace = False
#         self.restrictions = False
#         self.max_iterations = 1000
#         self.solver_timeout = 10000
#         self.solver_max_time = 10000
#         self.optimize = True
#
#     def set_run_option(self, run_option):
#         if run_option == "block":
#             self.block = True
#         elif run_option == "current trace":
#             self.optimize_current_trace = True
#             # self.optimize = False # returns first trace > current trace
#         elif run_option == "restrictions":
#             self.restrictions = True