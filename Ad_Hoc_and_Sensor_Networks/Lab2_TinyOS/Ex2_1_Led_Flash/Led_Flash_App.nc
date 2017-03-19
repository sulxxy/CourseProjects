configuration Led_Flash_App{
}
implementation{
	components Led_Flash, MainC, LedsC;
	components new TimerMilliC() as Timer0;
	
	Led_Flash -> MainC.Boot;
	Led_Flash.Timer0 -> Timer0;
	Led_Flash.Leds -> LedsC;

}
