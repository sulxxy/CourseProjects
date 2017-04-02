configuration SensingC {
} implementation {
	components MainC, LedsC, SensingP;
	SensingP.Boot -> MainC;
	SensingP.Leds -> LedsC;

	components IPStackC;
	components RPLRoutingC;
    components UDPShellC;
	components StaticIPAddressTosIdC;
	SensingP.RadioControl -> IPStackC;

    components new ShellCommandC("th_set") as ThresholdSet;
    SensingP.Set_Light_Threshold -> ThresholdSet;

	components new TimerMilliC() as Humidity_SenseTimer;
	SensingP.Humidity_SenseTimer -> Humidity_SenseTimer;

	components new TimerMilliC() as Light_SenseTimer;
	SensingP.Light_SenseTimer -> Light_SenseTimer;

	components new SensirionSht11C() as HumiditySensor;
	SensingP.Humidity -> HumiditySensor.Humidity;
	components new HamamatsuS1087ParC() as LightSensor;
	SensingP.Light -> LightSensor.Read;

	components new UdpSocketC() as SenseSend;
	SensingP.SenseSend -> SenseSend;


#ifdef PRINTFUART_ENABLED

  components SerialPrintfC;

#endif
}
