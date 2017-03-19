module BinCounterC{
	uses interface BinCounter;
	uses interface Boot;
}
implementation{
	int times = 0;	

	event void Boot.booted(){
		call BinCounter.start();
	}

	event void BinCounter.completed(){
		times++;
		if(times == 4){
			call BinCounter.stop();
		}
	}
	
}
