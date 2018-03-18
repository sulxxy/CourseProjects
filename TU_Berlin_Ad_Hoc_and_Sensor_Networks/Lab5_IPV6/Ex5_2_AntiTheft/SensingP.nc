#include <lib6lowpan/ip.h>
#include "sensing.h"
#include "blip_printf.h"

module SensingP {
	uses {
		interface Boot;
		interface Leds;
		interface SplitControl as RadioControl;

		interface UDP as LightSend;
		interface UDP as Settings;

		interface ShellCommand as GetCmd;
		interface ShellCommand as SetCmd;

		interface Timer<TMilli> as LightTimer;
		interface Read<uint16_t> as Light;

		interface Mount as ConfigMount;
		interface ConfigStorage;

		interface Timer<TMilli> as Led0Timer;
		interface Timer<TMilli> as Led1Timer;
		interface Timer<TMilli> as Led2Timer;
	}
} implementation {

	enum {
		SAMPLE_PERIOD = 1000, // ms
		LOW_LIGHT_THRESHOLD = 100,
	};

	enum{
		SETTINGS_REQUEST = 1,
		SETTINGS_RESPONSE = 2,
		SETTINGS_USER = 4,
	};
	settings_t settings;
	nx_struct setting_report node_setting_report;
	uint16_t m_light;
	nx_struct sensing_report stats;
	struct sockaddr_in6 route_dest;
	struct sockaddr_in6 multicast;

	event void Boot.booted() {
		settings.sample_period = SAMPLE_PERIOD;
		settings.light_threshold = LOW_LIGHT_THRESHOLD;
		node_setting_report.settings = settings;
		node_setting_report.sender = TOS_NODE_ID;
		node_setting_report.type = 1;

		route_dest.sin6_port = htons(7000);
		//inet_pton6(REPORT_DEST, &route_dest.sin6_addr);
		inet_pton6(MULTICAST, &route_dest.sin6_addr);
		call LightSend.bind(7000);

		multicast.sin6_port = htons(4000);
		inet_pton6(MULTICAST, &multicast.sin6_addr);
		call Settings.bind(4000);

		//call ConfigMount.mount();

		call RadioControl.start();
	}

	//radio
	event void RadioControl.startDone(error_t e) {
		call Settings.sendto(&multicast, &node_setting_report, sizeof(node_setting_report));
		call LightTimer.startPeriodic(settings.sample_period);
	}
	event void RadioControl.stopDone(error_t e) {}



	//config
	
	event void ConfigMount.mountDone(error_t e) {
		if (e != SUCCESS) {
			call Leds.led2On();
			call RadioControl.start();
		} else {
			if (call ConfigStorage.valid()) {
				call ConfigStorage.read(0, &node_setting_report, sizeof(node_setting_report));
			} else {
				settings.sample_period = SAMPLE_PERIOD;
				settings.light_threshold = LOW_LIGHT_THRESHOLD;
				node_setting_report.settings = settings;
				node_setting_report.sender = TOS_NODE_ID;
				node_setting_report.type = 1;
				call RadioControl.start();
			}
		}
	}

	event void ConfigStorage.readDone(storage_addr_t addr, void* buf, storage_len_t len, error_t e) {
		call RadioControl.start();
	}

	event void ConfigStorage.writeDone(storage_addr_t addr, void* buf, storage_len_t len, error_t e) {
		call ConfigStorage.commit();
	}

	event void ConfigStorage.commitDone(error_t error) {}




	//udp interfaces
	
	void led_flashing(int i){
		switch(i){
			case 0:
				call Leds.led0Off();
				call Led0Timer.startPeriodic(100);
				break;
			case 1:
				call Leds.led1Off();
				call Led1Timer.startPeriodic(100);
				break;
			case 2:
				call Leds.led2Off();
				call Led2Timer.startPeriodic(100);
				break;
		}
	}

	event void Led0Timer.fired(){
		call Leds.led0Toggle();
	}

	event void Led1Timer.fired(){
		call Leds.led1Toggle();
	}

	event void Led2Timer.fired(){
		call Leds.led2Toggle();
	}

	void digit_to_leds(int n){
		//ternary
		int t0, t1, t2;
		t0 = n%3;
		t1 = (n/3)%3;
		t2 = ((n/3)/3)%3;
		switch(t0){
			case 0:
				call Led0Timer.stop();
				call Leds.led0Off();
				break;
			case 1:
				call Led0Timer.stop();
				call Leds.led0On();
				break;
			case 2:
				led_flashing(0);
				break;
		}
		switch(t1){
			case 0:
				call Led1Timer.stop();
				call Leds.led1Off();
				break;
			case 1:
				call Led1Timer.stop();
				call Leds.led1On();
				break;
			case 2:
				led_flashing(1);
				break;
		}
		switch(t2){
			case 0:
				call Led2Timer.stop();
				call Leds.led2Off();
				break;
			case 1:
				call Led2Timer.stop();
				call Leds.led2On();
				break;
			case 2:
				led_flashing(2);
				break;
		}
	}

	event void LightSend.recvfrom(struct sockaddr_in6 *from, void *data, uint16_t len, struct ip6_metadata *meta) {
			memcpy(&stats, data, sizeof(nx_struct sensing_report));
			call ConfigStorage.write(0, &stats, sizeof(stats));
			if(stats.light < settings.light_threshold){
					digit_to_leds(stats.sender);
			}
	}

	event void Settings.recvfrom(struct sockaddr_in6 *from, void *data, uint16_t len, struct ip6_metadata *meta) {
			nx_struct setting_report received_setting;
			memcpy(&received_setting, data, sizeof(nx_struct setting_report));
			if(received_setting.type == 4){
				//user
				memcpy(&node_setting_report, data, sizeof(nx_struct setting_report));
				call ConfigStorage.write(0, &node_setting_report, sizeof(node_setting_report));
			}else if(received_setting.type == 1){
				// request 	
				received_setting.settings = node_setting_report.settings;
				received_setting.type = 2;
				call Settings.sendto(from, &received_setting, sizeof(received_setting));
			}
			else if(received_setting.type == 2){
				// response 	
				if(received_setting.sender == TOS_NODE_ID){
					node_setting_report.settings = received_setting.settings;	
					node_setting_report.type = 4;
				}
				
			}
	}

	//udp shell

	event char *GetCmd.eval(int argc, char **argv) {
		char *ret = call GetCmd.getBuffer(40);
		if (ret != NULL) {
			switch (argc) {
				case 1:
					sprintf(ret, "\t[Period: %u]\n\t[Threshold: %u]\n", node_setting_report.settings.sample_period, node_setting_report.settings.light_threshold);
					break;
				case 2: 
					if (!strcmp("per",argv[1])) {
						sprintf(ret, "\t[Period: %u]\n", node_setting_report.settings.sample_period);
					} else if (!strcmp("th", argv[1])) {
						sprintf(ret, "\t[Threshold: %u]\n",node_setting_report.settings.light_threshold);
					} else {
						strcpy(ret, "Usage: get [per|th]\n");
					}
					break;
				default:
					strcpy(ret, "Usage: get [per|th]\n");
			}
		}
		return ret;
	}

	task void report_settings() {
		call Settings.sendto(&multicast, &node_setting_report, sizeof(node_setting_report));
		call ConfigStorage.write(0, &node_setting_report, sizeof(node_setting_report));
	}

	task void report_settings_router() {
		call Settings.sendto(&route_dest, &node_setting_report, sizeof(node_setting_report));
		call ConfigStorage.write(0, &node_setting_report, sizeof(node_setting_report));
	}

	event char *SetCmd.eval(int argc, char **argv) {
		char *ret = call SetCmd.getBuffer(40);
		if (ret != NULL) {
			if (argc == 3) { 
				node_setting_report.sender = TOS_NODE_ID;
				node_setting_report.type = 4;
				if (!strcmp("per",argv[1])) {
					node_setting_report.settings.sample_period = atoi(argv[2]);
					sprintf(ret, ">>>Period changed to %u, Node ID is %u, setting type is %u\n",node_setting_report.settings.sample_period, node_setting_report.sender, node_setting_report.type);
					post report_settings();
				} else if (!strcmp("th", argv[1])) {
					node_setting_report.settings.light_threshold = atoi(argv[2]);
					sprintf(ret, ">>>Threshold changed to %u, Node ID is %u, setting type is %u\n",node_setting_report.settings.light_threshold, node_setting_report.sender, node_setting_report.type);
					post report_settings();
				} else {
					strcpy(ret,"Usage: set per|th [<sampleperiod in ms>|<threshold>]\n");
				}
			}
			else if (argc == 4) { 
				node_setting_report.sender = TOS_NODE_ID;
				node_setting_report.type = 4;
				if (!strcmp("per",argv[1]) && !strcmp("local", argv[3])) {
					node_setting_report.settings.sample_period = atoi(argv[2]);
					sprintf(ret, ">>>Period changed to %u, Node ID is %u, setting type is %u\n",node_setting_report.settings.sample_period, node_setting_report.sender, node_setting_report.type);
					post report_settings_router();
				} else if (!strcmp("th", argv[1]) && !strcmp("local", argv[3])) {
					node_setting_report.settings.light_threshold = atoi(argv[2]);
					sprintf(ret, ">>>Threshold changed to %u, Node ID is %u, setting type is %u\n",node_setting_report.settings.light_threshold, node_setting_report.sender, node_setting_report.type);
					post report_settings_router();
				} else {
					strcpy(ret,"Usage: set per|th [<sampleperiod in ms>|<threshold>] local\n");
				}
			} else {
				strcpy(ret,"Usage: set per|th [<sampleperiod in ms>|<threshold>] [local] \n");
			}
		}
		return ret;
	}


	//light report loop	

	event void LightTimer.fired() {
		call Light.read();
	}

	task void report_light() {
		stats.seqno++;
		stats.sender = TOS_NODE_ID;
		stats.light = m_light;
		call LightSend.sendto(&route_dest, &stats, sizeof(stats));
	}

	event void Light.readDone(error_t ok, uint16_t val) {
		if (ok == SUCCESS) {
			m_light = val;    
			if (val < node_setting_report.settings.light_threshold) {
				call Leds.led0On();
			} else { 
				call Leds.led0Off();
			}
			post report_light();
		}
	}
}
