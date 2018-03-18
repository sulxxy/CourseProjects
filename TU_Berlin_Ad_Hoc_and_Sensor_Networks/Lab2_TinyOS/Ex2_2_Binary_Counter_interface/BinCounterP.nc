module BinCounterP{
	provides interface BinCounter;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer;

}
implementation{
	int current_value = 0;

	void add(int* i){
		(*i)++;
		if((*i)	== 8){
			(*i) = 0;
			signal BinCounter.completed();
		}
	}
	void display(int i){
		if(i%2){
			call Leds.led0On();
		}else{
			call Leds.led0Off();
			i = i / 2;
			if(i%2){
				call Leds.led1On();
			}else{
				call Leds.led1Off();
				i = i / 2;
				if(i%2){
					call Leds.led2On();
				}else{
					call Leds.led2Off();
				}
			}
		}
		
	}
	

	event void Timer.fired(){
		display(current_value);
		add(&current_value);
	}

	command void BinCounter.start(){
		call Timer.startPeriodic(1000);
	}

	command void BinCounter.stop(){
		call Timer.stop();
		call Leds.led0Off();
		call Leds.led1Off();
		call Leds.led2Off();
	}
	

}
