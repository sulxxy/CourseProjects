#include "hardware.h"

configuration PlatIOC{
}
implementation{
	components HplMsp430GeneralIOC;
	components PlatIOP, MainC;
	components new Msp430GpioC() as Led0;
	components new Msp430GpioC() as Led1;
	components new Msp430GpioC() as Led2;
	components new TimerMilliC() as Timer0;
	components new TimerMilliC() as Timer1;
	components new TimerMilliC() as Timer2;
	PlatIOP.Boot -> MainC;
	PlatIOP.Timer0 -> Timer0;
	PlatIOP.Timer1 -> Timer1;
	PlatIOP.Timer2 -> Timer2;
	PlatIOP.led0 -> Led0;
	PlatIOP.led1 -> Led1;
	PlatIOP.led2 -> Led2;
	Led0 -> HplMsp430GeneralIOC.Port54;
	Led1 -> HplMsp430GeneralIOC.Port55;
	Led2 -> HplMsp430GeneralIOC.Port56;
}
