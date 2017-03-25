#define NEW_PRINTF_SEMANTICS

configuration LightC {
}
implementation {

	components MainC, LightP, LedsC;
	LightP -> MainC.Boot;
	LightP.Leds -> LedsC;
	components IPStackC;
	components IPDispatchC;
	components UdpC;
	components UDPShellC;
	components RPLRoutingC;;

	components StaticIPAddressTosIdC;

	LightP.RadioControl -> IPStackC;

	components new ShellCommandC("read") as ReadCmd;
	components new ShellCommandC("stream") as StreamCmd;
	LightP.ReadCmd -> ReadCmd;
	LightP.StreamCmd -> StreamCmd;

	components new TimerMilliC() as SensorReadTimer;
	LightP.SensorReadTimer -> SensorReadTimer;

	components new HamamatsuS1087ParC() as SensorPar;
	LightP.ReadPar -> SensorPar.Read;
	LightP.StreamPar -> SensorPar.ReadStream;

#ifdef PRINTFUART_ENABLED
  components SerialPrintfC;

#endif
}
