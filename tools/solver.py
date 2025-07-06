import z3
def init_solver():
    goal = z3.Goal()
    goal = z3.Then('purify-arith', 'nlsat')
    solver = z3.Solver()
    # solver = z3.Then('purify-arith', 'nlsat').solver()

    z3.set_param('smt.random_seed', 1)
    # solver.set_option(precision=30) #TODO is5 this ieasier than precision fro printing?

    z3.set_option(max_args=10000000, max_lines=1000000, max_depth=10000000,
                  max_visited=1000000)  # displays5 more assertions

    # for unsat cores TODO check and remove if not good
    # solver.set(auto_config=False)
    solver.set(unsat_core=True)
    # solver.add(0^0 == 0) #TODO Trial
    # solver.add(0 ** 0 == 1)
    return solver