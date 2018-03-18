configuration GPIO_LedsApp{
}
implementation{
	components MainC, GPIO_LedsC;
	components new TimerMilliC() as Timer;
	
	GPIO_LedsC -> MainC.Boot;
	GPIO_LedsC.Timer -> Timer;
}
