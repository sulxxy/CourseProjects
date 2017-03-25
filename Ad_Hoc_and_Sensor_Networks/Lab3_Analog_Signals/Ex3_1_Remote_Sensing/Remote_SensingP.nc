#include <stdio.h>
module Remote_SensingP{
	uses interface Boot;
	uses interface SplitControl as RadioControl;
	uses interface ShellCommand as ReadPar;
	uses interface Read<uint16_t> as LightPar;
	uses interface Timer<TMilli> as Timer;
}
implementation{
	int light_intensity = 0;
	//char* ret_string = malloc(16*sizeof(char));
	event void Boot.booted(){
		call Timer.startPeriodic(10);
		call RadioControl.start();		
	} 
	
	event void Timer.fired(){
		call LightPar.read();	
	}

	event void RadioControl.startDone(error_t e) {}

	event void RadioControl.stopDone(error_t e) {}
	
	event char* ReadPar.eval(int argc, char** argv){ 
		char* ret = call ReadPar.getBuffer(16); 
		snprintf(ret, 16,  "	[value: %d]\n", light_intensity);
		light_intensity = -1;
		return ret;
	}

	event void LightPar.readDone(error_t e, uint16_t val){
		if(e == SUCCESS){
			light_intensity = val;		
		}
		else{
			light_intensity = -1;
		}
	}
	
}
