#Install requirements 
run py-req.sh

# Reading results

```
results/
├── Run-XX/ (each run)
│   ├── parsing_results/
│   │   ├── smtdump.txt      - 
│   │   ├── vardump.txt      - 
│   │   └── obs.txt          - Observations observed_var = value
│   │   └── block.txt        - Contains fixed values for latent variables that are not in the current block resimulation. 
│   └── solver_results/
│   │   ├── pymodel.json      - SMT LIB format model of the probabilisti problem
│   │   └── model_solution.jl - Solver solution in the form of variable = value, the solution will assigned values for the latent_variables and observations, fixed trace values. For the later 2 the values will coincide with the ones in the true observations and fixed values for block resimulation.
│   └── figures/
```


