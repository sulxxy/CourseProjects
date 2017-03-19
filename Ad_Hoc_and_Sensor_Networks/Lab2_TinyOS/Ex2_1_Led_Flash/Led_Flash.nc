module Led_Flash{
  	uses interface Timer<TMilli> as Timer0;
	uses interface Leds;
	uses interface Boot;
}
implementation{
	int flag = 0;
	
	event void Boot.booted(){
		call Timer0.startPeriodic(100);		
	}

  	event void Timer0.fired()
  	{
    		dbg("BlinkC", "Timer 0 fired @ %s.\n", sim_time_string());
		if(flag%15)
    			call Leds.led0Off();
		else
			call Leds.led0On();
		flag++;
  	}

}
