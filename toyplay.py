import z3
from z3 import Int, IntSort, Solver, Bools, Ints, Implies

# print (1/3)
# print (z3.RealVal(1)/3)
# print (z3.Q(1,3))
#
# x = z3.Real('x')
# print (x + 1/3)
# print (x + z3.Q(1,3))
# print (x + "1/3")
# print (x + 0.25)
# print(type(x + 0.25))


# x = z3.Real('x')
# z3.solve(3*x == 1)
#
# z3.set_option(rational_to_decimal=True)
# z3.solve(3*x == 1)
#
# z3.set_option(precision=30)
# z3.solve(3*x == 1)

# x = Int('x')
# y = Int('y')
# f = z3.Function('f', IntSort(), IntSort())
# s = Solver()
# s.add(f(f(x)) == x, f(x) == y, x != y)
# print (s.check())
# m = s.model()
# print(m[x])
# print("f(f(x)) =", m.evaluate(f(f(x))))
# print("f(x)    =", m.evaluate(f(x)))

# def unsat_model(solver):
s = Solver()
s.set(unsat_core=True)
# s.set(auto_config=False)
a = z3.Bool('a')
b = z3.Bool('b')
# s.add(a == b)
# s.add(a != b)

s.assert_and_track(a , 'a1')
s.assert_and_track(a != b, 'a2')
s.assert_and_track(a == b , 'a3')
# s.add(a == b, a == b + 1)
print(s.check())
# print(s.model())
core = s.unsat_core()
print(len(core))
# print('a1 ', z3.Bool('a1') in core)
# print('a2 ', z3.Bool('a2') in core)
# print('a3 ', z3.Bool('a3') in core)
print(core)
# print(s.unsat_core())


# p1, p2, p3 = Bools('p1 p2 p3')
# x, y = Ints('x y')
# # We assert Implies(p, C) to track constraint C using p
# s = Solver()
# s.add(Implies(p1, x > 10),
#       Implies(p1, y > x),
#       Implies(p2, y < 5),
#       Implies(p3, y > 0))
# print (s)
# # Check satisfiability assuming p1, p2, p3 are true
# print (s.check(p1, p2, p3))
# print (s.unsat_core())
#
# # Try again retracting p2
# print (s.check(p1, p3))
# print (s.model())

