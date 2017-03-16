# Introduction
## What is TinyOS?
1. TinyOS is an open source operating system for embedded, low power, wireless devices.

   ![alt tag]()

2. Component-based
3. Event-driven
4. Portable
5. Robust

## Why use TinyOS?
1. Great performance under limited resources
2. Broad platform coverage
3. Rich protocol library
4. Powerful PC-side tools

## TinyOS Design Goals
### Performance
1. Single-stack execution
2. Direct reaction to events
3. Many contexts in limited resources

### Flexibility
1. Flexible hardware/software boundary
2. Portable and platform-specific services
3. Adaptable to the application needs

### Robustness
1. Static allocation
2. Static binding

# Structural Model
## The nesC Programming Language
1. TinyOS and its applications are written in nesC
  * Dialect of C
  * Pre-processor
2. Components are basic unit of nesC code
  * Programs are assemblies of components
  * Components connect via interfaces

## Component Structure
1. Signature

   List of interfaces used to connect to other components. Signatures are declarations.
   ![alt tag]()
2. Implementation

   Defines the internal workings of the component

## Components
1. Components are something like entities. Every component encapsulates its own functions and they can provide other components services through interfaces.
2. Modules

   A module are used to define the behaviors of a component. That is, modules define functions.
3. Configurations

   A configuration shows how components are connected(wired) in a program.

## Interfaces
1. Interfaces list the commands it can execute and the events it can emit(signal).

   ![alt tag]()
2. Users and providers
  * Component A **uses** the interface I
  * Component B **provides** the interface I
3. Commands and events
  * Commands are just like the concept of functions in C programming language.
  * An **event** means, when a function goes into some special conditions(e.g. an exception happened or some command is completed), the function can emit a signal(use signal keyword) to its caller.
  * A **calls commands** on B
  * B **signals events** to A

## Wiring
Wiring(->) means connecting providers and users together. For example, module A uses an interface called Leds. However, if we don't declare the provider of the interface Leds, the commands in Leds would be undefined. So we declare a provider called LedsC. Now, we can use
```C
A.Leds -> LedsC
```

to connect LedsC(provider) with A(User).

## Generic Interfaces

## Generic components
Normally a component is an instance which cannot be changed. On the contrast, a generic component can be instantiated within a configuration. While a component can be seen as an object in object oriented language, a generic component can be seen as a non-static class.

## Example
