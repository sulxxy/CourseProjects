#include "Timer.h"
#define P56_OUT() P5DIR |= BV(6)
#define P56_IN() P5DIR &= ~BV(6)
#define P56_SEL() P5SEL &= ~BV(6)
#define P56_IS_1  (P5OUT & BV(6))
#define P56_WAIT_FOR_1() do{}while (!P56_IS_1)
#define P56_IS_0  (P5OUT & ~BV(6))
#define P56_WAIT_FOR_0() do{}while (!P56_IS_0)
#define P56_1() P5OUT |= BV(6)
#define P56_0() P5OUT &= ~BV(6)

module GPIO_LedsC{
	uses interface Boot;
	uses interface Timer<TMilli> as Timer;
}
implementation{
	int flag = 0;
	event void Boot.booted(){
		call Timer.startPeriodic(1000);
	}
	event void Timer.fired(){
		if(flag){
			flag = 0;
			P56_0();
		}else{
			flag = 1;
			P56_1();
		}
	}
}
