#include <stdio.h>
module Remote_SensingP{
	uses interface Boot;
	uses interface SplitControl as RadioControl;
	uses interface ShellCommand as ReadPar;
	uses interface ReadStream<uint16_t> as LightPar;
	uses interface Leds;
}
implementation{
	int light_intensity = 0;
	enum{
		sample_size = 4,
	};
	int m_par[sample_size];

	event void Boot.booted(){
		call RadioControl.start();		
	} 
	
	event void RadioControl.startDone(error_t e) {}
	
	task void outputvalue(){
		char* ret = call ReadPar.getBuffer(16); 
		int i = 0;
		int sum = 0;
		for(i = 0; i < sample_size; i++)
			sum += m_par[i];
		snprintf(ret, 16, "[Value: %d]\n", sum/sample_size);
	        call ReadPar.write(ret, 16);
	}
	
	event void LightPar.readDone(error_t e, uint32_t val){
		if(e == SUCCESS){
			post outputvalue();
		}
	}

	event void LightPar.bufferDone(error_t ok, uint16_t *buf, uint16_t count) {}

	event void RadioControl.stopDone(error_t e) {}
	
	event char* ReadPar.eval(int argc, char** argv){ 
		char* ret = call ReadPar.getBuffer(16); 
		strcpy(ret, " ");
		call LightPar.postBuffer(m_par, sample_size);
		call LightPar.read(10000);
		return ret;
	}

	
}
