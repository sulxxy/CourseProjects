# TinyOS and nesC concepts
Summarize the TinyOS lecture. Describe the basic concept of TinyOS (components, modules, configurations, wiring, commands, signals, signatures, interfaces, generic interfaces, generic components) briefly and using your own words.

# Conclusion
## Components
Components are something like entities. Every component encapsulates its own functions and they can provide other components services through interfaces. 

## Modules
A module are used to define the behaviors of a compoment. That is, modules define functions. 

## Configurations
A configuration shows how components are connected(wired) in a program.

## Wiring
Wiring(->) means connecting providers and users together. For example, module A uses an interface called Leds. However, if we don't declare the provider of the interface Leds, the commands in Leds would be undefined. So we declare a provider called LedsC. Now, we can use 
> A.Leds -> LedsC

to connect LedsC(provider) with A(User).

## Commands
Commands are just like the concept of functions in C programming language.

## Signals
A signal means, when a function goes into some special conditions(e.g. an exception happened or some command is completed), the function can emit a signal(use signal keyword) to its caller.

## Signatures
Signatures are declarations.

## Interfaces
Interfaces list the commands it can excute and the events it can emit(signal).

## Generic Interfaces

## Generic components
Normally a component is an instance which cannot be changed. On the contrast, a generic component can be instantiated within a configuration. While a component can be seen as an object in object oriented language, a generic component can be seen as a non-static class.

