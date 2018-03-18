#include "Timer.h"

module PlatIOP {
	uses {
		interface Boot;
		interface Timer<TMilli> as Timer0;
		interface Timer<TMilli> as Timer1;
		interface Timer<TMilli> as Timer2;
		interface GeneralIO as led0;
		interface GeneralIO as led1;
		interface GeneralIO as led2;
	}
}
implementation{
	event void Boot.booted(){
		call Timer0.startPeriodic(100);
		call Timer1.startPeriodic(400);
		call Timer2.startPeriodic(1000);
	}

	event void Timer0.fired(){
		if(call led0.get())
			call led0.clr();
		else
			call led0.set();
	}

	event void Timer1.fired(){
		if(call led1.get())
			call led1.clr();
		else
			call led1.set();
	}

	event void Timer2.fired(){
		if(call led2.get())
			call led2.clr();
		else
			call led2.set();
	}
}
