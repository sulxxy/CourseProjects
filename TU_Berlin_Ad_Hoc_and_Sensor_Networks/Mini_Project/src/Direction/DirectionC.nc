#include "hardware.h"


configuration DirectionC {
}
implementation {

	components MainC, DirectionP;
    components HplMsp430GeneralIOC;
    components new Msp430GpioC() as Forward;
    components new Msp430GpioC() as Backward;
	DirectionP.Boot -> MainC.Boot;

	components IPStackC;
	components UDPShellC;
	components RPLRoutingC;
	components StaticIPAddressTosIdC;

	DirectionP.RadioControl -> IPStackC;

    DirectionP.Forward -> Forward;
    DirectionP.Backward -> Backward;

    Forward -> HplMsp430GeneralIOC.Port26;
    Backward -> HplMsp430GeneralIOC.Port23;

	components new ShellCommandC("forward") as ForwardCmd;
	DirectionP.ForwardCmd -> ForwardCmd;
	components new ShellCommandC("backward") as BackwardCmd;
	DirectionP.BackwardCmd -> BackwardCmd;
	components new ShellCommandC("stop") as StopCmd;
	DirectionP.StopCmd -> StopCmd;

#ifdef PRINTFUART_ENABLED
  /* This component wires printf directly to the serial port, and does
   * not use any framing.  You can view the output simply by tailing
   * the serial device.  Unlike the old printfUART, this allows us to
   * use PlatformSerialC to provide the serial driver.
   *
   * For instance:
   * $ stty -F /dev/ttyUSB0 115200
   * $ tail -f /dev/ttyUSB0
  */
  components SerialPrintfC;

  /* This is the alternative printf implementation which puts the
   * output in framed tinyos serial messages.  This lets you operate
   * alongside other users of the tinyos serial stack.
   */
  // components PrintfC;
  // components SerialStartC;
#endif
}
