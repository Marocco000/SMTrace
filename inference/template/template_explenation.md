To add a new model copy the template folder and rename 'template' with your model name. 

1. Add the probabilistic model to the 'template_model' file
!Important: The file can only contain the function at it must be named ppmodel, it also cant take any paramters 

2. Use the 'template_model_generator' to generate code that unrolls for loops and arrays and add output to the 'template_model'

3. The 'template_inference' file is where you will write the inference code. 
There is sample code to guide where the use of SMT traces can be included. 

4. The 'template_bench' will run standard benchmarks for the provided model and inference. 