module Shell_LedP{
	uses interface ShellCommand as Digit0;
	uses interface ShellCommand as Digit1;
	uses interface ShellCommand as Digit2;
	uses interface ShellCommand as Digit3;
	uses interface ShellCommand as Digit4;
	uses interface ShellCommand as Digit5;
	uses interface ShellCommand as Digit6;
	uses interface ShellCommand as Digit7;
	uses interface Boot;
	uses interface Leds;
	uses interface SplitControl as RadioControl;
}
implementation{
	event void Boot.booted(){
		call RadioControl.start();
	}

	event void RadioControl.startDone(error_t e) {}

	event void RadioControl.stopDone(error_t e) {}

        void Show_Digit_Using_Leds(int digit){
		switch(digit){
			case 0:
				call Leds.led0Off();
				call Leds.led1Off();
				call Leds.led2Off();
				break;
			case 1:
				call Leds.led0On();
				call Leds.led1Off();
				call Leds.led2Off();
				break;
			case 2:
				call Leds.led0Off();
				call Leds.led1On();
				call Leds.led2Off();
				break;
			case 3:
				call Leds.led0On();
				call Leds.led1On();
				call Leds.led2Off();
				break;
			case 4:
				call Leds.led0Off();
				call Leds.led1Off();
				call Leds.led2On();
				break;
			case 5:
				call Leds.led0On();
				call Leds.led1Off();
				call Leds.led2On();
				break;
			case 6:
				call Leds.led0Off();
				call Leds.led1On();
				call Leds.led2On();
				break;
			case 7:
				call Leds.led0On();
				call Leds.led1On();
				call Leds.led2On();
				break;

		}
	}

	event char* Digit0.eval(int args, char **argv){
		char *ret = call Digit0.getBuffer(32);
		Show_Digit_Using_Leds(0);
		if(ret != NULL){
			strncpy(ret, "Digit 0\n", 32);
		}
		return ret;
	}

	event char* Digit1.eval(int args, char **argv){
		char *ret = call Digit1.getBuffer(32);
		Show_Digit_Using_Leds(1);
		if(ret != NULL){
			strncpy(ret, "Digit 1\n", 32);
		}
		return ret;
	}

	event char* Digit2.eval(int args, char **argv){
		char *ret = call Digit2.getBuffer(32);
		Show_Digit_Using_Leds(2);
		if(ret != NULL){
			strncpy(ret, "Digit 2\n", 32);
		}
		return ret;
	}

	event char* Digit3.eval(int args, char **argv){
		char *ret = call Digit3.getBuffer(32);
		Show_Digit_Using_Leds(3);
		if(ret != NULL){
			strncpy(ret, "Digit 3\n", 32);
		}
		return ret;
	}

	event char* Digit4.eval(int args, char **argv){
		char *ret = call Digit4.getBuffer(32);
		Show_Digit_Using_Leds(4);
		if(ret != NULL){
			strncpy(ret, "Digit 4\n", 32);
		}
		return ret;
	}

	event char* Digit5.eval(int args, char **argv){
		char *ret = call Digit5.getBuffer(32);
		Show_Digit_Using_Leds(5);
		if(ret != NULL){
			strncpy(ret, "Digit 5\n", 32);
		}
		return ret;
	}

	event char* Digit6.eval(int args, char **argv){
		char *ret = call Digit6.getBuffer(32);
		Show_Digit_Using_Leds(6);
		if(ret != NULL){
			strncpy(ret, "Digit 6\n", 32);
		}
		return ret;
	}

	event char* Digit7.eval(int args, char **argv){
		char *ret = call Digit7.getBuffer(32);
		Show_Digit_Using_Leds(7);
		if(ret != NULL){
			strncpy(ret, "Digit 7\n", 32);
		}
		return ret;
	}
}
