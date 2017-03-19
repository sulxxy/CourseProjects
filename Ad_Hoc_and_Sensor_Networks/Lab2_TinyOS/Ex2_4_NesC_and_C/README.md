# nesC and C
What are the main differences between nesC and the C language? Provide short examples from the blinking LED application to illustrate your answers.

# Solution
1. The configuration component

   In C, there's no configuration part to connect different part. This is because nesC uses local namespace which means in addition to declaring the functions that it implements, a component also needs to declare the functions it calls. On the contrary, C programming language uses global namespace for functions and variables.
2. How functions to be executed is selected

   In C the function to be executed at a function call is selected by its name. In nesC when a command or event should be executed the programmer explicitly selects with the wiring in configurations which component’s implementation of the command or event should be used.
