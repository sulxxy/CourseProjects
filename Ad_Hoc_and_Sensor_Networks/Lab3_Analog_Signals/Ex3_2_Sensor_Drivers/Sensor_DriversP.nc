#include <stdio.h>
module Sensor_DriversP{
	uses interface Read<uint16_t> as Temperature;
	uses interface Read<uint16_t> as Humidity;
	uses interface Timer<TMilli> as Timer;
	uses interface Boot;
	uses interface ShellCommand as ReadTemp;
	uses interface ShellCommand as ReadHumidity;
	uses interface SplitControl as RadioControl; 
}
implementation{
	int cur_temperature = 0;
	int cur_humidity = 0;
	event void Boot.booted(){
		call RadioControl.start();
		call Timer.startPeriodic(100);		
	}

	event void Timer.fired(){
		call Temperature.read();
		call Humidity.read();
	}	
	
	event void Temperature.readDone(error_t e, uint16_t val){
		if(e == SUCCESS){
			cur_temperature = val;
		}
		else{
			cur_temperature = -100;
		}
	}
	
	event void Humidity.readDone(error_t e, uint16_t val){
		if(e == SUCCESS){
			cur_humidity = val;
		}
		else{
			cur_humidity = -1;
		}
	}

	event char* ReadTemp.eval(int argc, char** argv){
		char* ret = call ReadTemp.getBuffer(32);
		if(ret != NULL)
			snprintf(ret, 32, "[Temperature value %x]\n", cur_temperature);
		return ret;
	}
	event char* ReadHumidity.eval(int argc, char** argv){
		char* ret = call ReadHumidity.getBuffer(32);
		if(ret != NULL)
			snprintf(ret, 32, "[Humidity value %x]\n", cur_humidity);
		return ret;
	}
	
	event void RadioControl.startDone(error_t e) {}
	event void RadioControl.stopDone(error_t e) {}
}
