# Lab2: TinyOS Basics
## Group Information
1. Group Number: 9
2. Group Members:
  * Hui Yin 
  * JiaPeng Li
  * JiaWen Wang
  * Zhiwei Liu

## Goals
In this lab you will learn the basic concepts of TinyOS programming. After this lab you will be able to write simple TinyOS applications and have deeper understanding of the main TinyOS concepts like components, modules, configurations and interfaces.

# Interfaces, Modules and Configurations
In the previous lab we have already installed the Blink application.  Blink is not part of the additional Lab applications, and resides in tinyos-main/apps/Blink. In the following, this very simple application, will serve as basis for introducing the  most  basic  TinyOS  concepts,  thus  helping  you  to  write  your  own  TinyOS applications:

## Components -- Signature and Implementation
TinyOS applications are written in nesC and built by the nescc compiler.  A nesC application consists of one or more components. A component can be a module (in this example the BlinkC.nc component is module) or a configuration (in this example the BlinkApp.nc is a configuration).  Each component is comprised of two blocks: a signature (first block) and the an implementation (second block).  As an example, let's look at the internal structure of the BlinkC.nc component:
<pre><code>
module BlinkC {
	uses interface Timer<TMilli> as Timer0;
	uses interface Timer<TMilli> as Timer1;
	uses interface Timer<TMilli> as Timer2;
	uses interface Leds;
	uses interface Boot;
}
implementation
{
	event void Boot.booted()  {
		call Timer0.startPeriodic( 250 );
		call Timer1.startPeriodic( 500 );
		call Timer2.startPeriodic( 1000 );
	}
	event void Timer0.fired() {
		call Leds.led0Toggle();
	}
	event void Timer1.fired() {
		call Leds.led1Toggle();
	}
	event void Timer2.fired() {
		call Leds.led2Toggle();
	}
}
</pre></code>
As you were able to see during the previous Lab,  the application implements a 3-bit binary counter.For this, it uses 3 independent timers, each timer toggling a specific LED.

##  Interfaces -- Commands and Events
An interface is a collection of related functions that de nes a given abstraction or a service. Components interact  by using or providing interfaces from other components. Interfaces are typically defined in separate interface files that declare the member functions comprising the particular interface, while the actual implementation of the functions is done elsewhere.

For example, the Leds interface from our Blink application offers some commands to turn LEDs on, off or to toggle them. It also can read out or set the status of the LEDs using an 8-bit integer representation:
<pre><code>
\#include "Leds.h"
interface Leds {
	command void led0On();
	command void led0Off();
	command void led0Toggle();
	command void led1On();
	command void led1Off();
	command void led1Toggle();
	command void led2On();
	command void led2Off();
	command void led2Toggle();
	command uint8_t get();
	command void set(uint8_t val);
}
</pre></code>
The interface  file is typically named as the interface that it de nes, appended by the standard nesC  file extension *.nc*.

The functions comprising an interface can be of two types: *commands* and *events*. A command is a function that is called by the user of the interface and they are very similar to "normal" C functions.  In contrast, events are functions that can be **signaled** by the module providing the interface.  An example is the Boot interface, which only offers one event, the booted event:
<pre><code>
interface Boot {
	event void booted();
}
</pre></code>
This event is triggered when the system is booted successfully and the follow-up services can start to work.  It serves a similar role like the main function in C, and is usually the starting point for the application code. To trigger an event the keyword *signal* is used.  For example a module providing the Boot interface would look like:
<pre><code>
module ExampleBootP {
	provides interface Boot;
}
implementation
{
	void init() {
		doSomethingToInitTheSystem(); signal
		Boot.booted();
	}
}
</pre></code>
The Timer interface, for example, offers three commands and one event:
<pre><code>
\#include "Timer.h"
interface Timer<precision_tag>
{
	command void startPeriodic(uint32_t dt);
	command void startOneShot(uint32_t dt);
	command void stop();
	event void fired();
}
</pre></code>
The Timer interface is a generic interface which is typed with the required precision of the Timer (milliseconds,  microseconds, etc.). You can start a one shot or a periodic timer. Both will trigger the *fired()* event, but the periodic timer will restart and fire every *dt* time units (according to the precision setting). Starting a timer (again) will replace any current timer settings and the stop command will cancel the timer.

The Timer interface offers more functionality, but in this example only these basic functions are needed. You can find many of the predefined system interfaces in TinyOS in the *tinyos-main/tos/interfaces/* folder. Additional interfaces are can be found in dedicated interfaces folders belonging to particular library parts across *tinyos-main/tos/lib*. Sometimes they are not even in an extra interfaces folder. For example the Timer.nc interface is located in tinyos-main/tos/lib/timer/.

When you define your own interface, the providing module has to implement all commands, while all events are implemented by the modules using the interface. As an exception to this rule, a module can also define *default* implementations for the commands it uses and the events it signals.  These implementations will be used as defaults in case the component is not wired or when the other component does not provide own implementation.

##  Using and Providing Interfaces
A module can use or provide an interface.  In the Blink application three di erent interfaces are used:
<pre><code>
uses interface Leds;
uses interface Boot;
</pre></code>

The Leds and Boot interfaces are examples of singleton interfaces, that are pro- vided by singleton components (the component name is a single entity in a global namespace).  If you, for example, extend an application with a module that also uses the Leds interface, the two modules reference the same piece of code and state. 

When declaring the use of a generic interface that is parametrized (like the Timer interface here) we also need to include the parameter value, in this case TMilli (because we want to use timers with millisecond precision). The as keyword  is  used  in  the  signature  to  provide  an  alternative  name  for  an interface.  It can be used to provide a more readable name or,  as in BlinkC, to enable differentiation between multiple instances of the same interface:
<pre><code>
uses interface Timer<TMilli> as Timer0;
uses interface Timer<TMilli> as Timer1;
uses interface Timer<TMilli> as Timer2;
</pre></code>

The  signature  needs  to  ensure  that  every  instance  of  a  particular  interface  has a  unique  name. This  means  that  the  last  Timer  interface  could  have remained unmodified, but the alternative name Timer2 is more readable. If  a  module  is  providing  an  interface,  the provides keyword  is used instead  of uses:
<pre><code>
provides interface MyInterface;
</pre></code>

Every used interface offers commands that can be called and events that have to be  implemented. To call a command the keyword call is used followed by the interface name and finally by the name of the command and the parameters it takes:
<pre><code>
call Leds.led0Toggle();
</pre></code>

Here  the  command led0Toggle() from  the  Leds  interface  is  called.   While a component is not forced to call every command of an used interface, it has  to implement all event handlers (unless the provider offers a default implementation). The  Blink  application  uses  the  Boot  interface,  so  the  booted  event  has  to  be implemented:
<pre><code>
event void Boot.booted()
{
	call Timer0.startPeriodic( 250 );
	call Timer1.startPeriodic( 500 );
	call Timer2.startPeriodic( 1000 );
}
</pre></code>

As a result, when  the boot event is triggered,  all 3 timers  start as a periodic counter. And because three different timer interfaces are used, the red() event has to be implemented for each timer.
## Configurations and Wiring
As we have seen, the module BlinkC uses di erent interfaces in order to perform its functionality.  These interfaces, however, have to be connected to components that actually provide their implementation.  Such wiring is done by a dedicated type of component called configuration. 

In our example application, the wiring of the components is done by the separate BlinkAppC.nc configuration component:
<pre><code>
configuration BlinkAppC {
}
implementation
{
	components MainC, BlinkC, LedsC;
	components new TimerMilliC() as Timer0;
	components new TimerMilliC() as Timer1;
	components new TimerMilliC() as Timer2;
	BlinkC -> MainC.Boot;
	BlinkC.Timer0 -> Timer0;
	BlinkC.Timer1 -> Timer1;
	BlinkC.Timer2 -> Timer2;
	BlinkC.Leds -> LedsC;
}
</pre></code>

As it can be seen, the signature of this con guration does not contain any code as no interfaces are used or provided by the con guration component itself.  In the implementation part of BlinkAppC, the components to be wired are  first listed:
**MainC**: The module providing the Boot interface
**LedsC**: The module providing the Leds interface
**BlinkC**: The module containing the Blink application logic
**Timer0, Timer1, Timer2**:  Three generic configurations for the timers

The last three components are not singletons like MainC, BlinkC and LedsC. They are three instances of the generic component TimerMiliC, that we are instantiating as part of the con guration using the new operator.  Generic components can also take  parameters,  as  indicated  by  the  parentheses  in TimerMilliC() ,  in  this case the component does not take extra parameters.  In contrast to other object- oriented languages,  the instantiation of generic components uses a code-copying approach, each of the resulting Timer components represents an individual copy.

Instantiation of generic components is private to the con guration where they are instantiated, they can only be referred from within the configuration where they were instantiated, unless their interfaces are (re)exported by the configuration (in its signature section, which in case of BlinkAppC is empty). The actual wiring of the components is done using the -> operator.  The Timer0 interface of BlinkC is wired to the instantiated component Timer0.  To be precise, the Timer < TMilli > interface of the component TimerMilliC is used,  nesC is smart enough to guess the correct interface on the right side, even though only the component name has been provided. If a configuration should (re)export a certain interface, the = operator is used:
<pre><code>
MyInterface = MyModuleP;
</pre></code>
This is a more advanced concept, we will see more concrete examples in the later Labs.


