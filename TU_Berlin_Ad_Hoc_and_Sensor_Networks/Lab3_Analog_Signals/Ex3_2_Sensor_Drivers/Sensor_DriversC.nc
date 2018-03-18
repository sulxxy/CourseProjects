configuration Sensor_DriversC{
}
implementation{
	components MainC, Sensor_DriversP;
	components new SensirionSht11C() as SensirionSht11C;
	components new TimerMilliC() as Timer;

	Sensor_DriversP -> MainC.Boot;

	components IPStackC;
	components UDPShellC;
	components RPLRoutingC;
	components StaticIPAddressTosIdC;
	
	Sensor_DriversP.Timer -> Timer;
	Sensor_DriversP.RadioControl -> IPStackC;
	Sensor_DriversP.Temperature -> SensirionSht11C.Temperature;
	Sensor_DriversP.Humidity -> SensirionSht11C.Humidity;
	components new ShellCommandC("read-temp") as ReadTemp;
	components new ShellCommandC("read-humidity") as ReadHumidity;
	Sensor_DriversP.ReadTemp -> ReadTemp; 
	Sensor_DriversP.ReadHumidity -> ReadHumidity; 

#ifdef PRINTFUART_ENABLED
	components SerialPrintfC;
#endif
}
