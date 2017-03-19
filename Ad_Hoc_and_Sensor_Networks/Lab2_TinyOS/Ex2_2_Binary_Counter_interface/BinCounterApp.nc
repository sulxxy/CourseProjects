configuration BinCounterApp{
}
implementation{
	components MainC, LedsC, BinCounterP, BinCounterC;
	components new TimerMilliC() as Timer;
	
	BinCounterC -> MainC.Boot;
	BinCounterP.Leds -> LedsC;
	BinCounterP.Timer -> Timer;
	BinCounterC.BinCounter -> BinCounterP;

}
