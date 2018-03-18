#include <lib6lowpan/ip.h>
#include "sensing.h"

module SensingP {
	uses {
		interface Boot;
		interface Leds;
		interface SplitControl as RadioControl;
		interface UDP as SenseSend;
		interface Timer<TMilli> as Humidity_SenseTimer;
		interface Timer<TMilli> as Light_SenseTimer;
		interface Read<uint16_t> as Humidity;
		interface Read<uint16_t> as Light;
	}

} implementation {

	enum {
		Humidity_SENSE_PERIOD = 500, // ms
		Light_SENSE_PERIOD = 128, // ms
	};

	nx_struct sensing_report stats;
	struct sockaddr_in6 route_dest;
	m_humidity = 0;
	m_light = 0;
	uint16_t flag_hum = 0;
	uint16_t flag_light = 0;

	event void Boot.booted() {
		call RadioControl.start();
	}

	event void RadioControl.startDone(error_t e) {
		route_dest.sin6_port = htons(7000);
		inet_pton6(REPORT_DEST, &route_dest.sin6_addr);
		call Humidity_SenseTimer.startPeriodic(Humidity_SENSE_PERIOD);
		call Light_SenseTimer.startPeriodic(Light_SENSE_PERIOD);
	}

	task void report_humidity() {
		stats.sender = TOS_NODE_ID;
		stats.humidity = m_humidity;
		if(flag_light >= 1){
			stats.seqno++;
			flag_light = 0;
			flag_hum = 0;
			call SenseSend.sendto(&route_dest, &stats, sizeof(stats));
		}
	}
	task void report_light() {
		stats.sender = TOS_NODE_ID;
		stats.light = m_light;
		if(flag_hum >= 1 ){
			stats.seqno++;
			flag_light = 0;
			flag_hum = 0;
			call SenseSend.sendto(&route_dest, &stats, sizeof(stats));
		}
	}

	event void SenseSend.recvfrom(struct sockaddr_in6 *from, 
			void *data, uint16_t len, struct ip6_metadata *meta) {}

	event void Humidity_SenseTimer.fired() {
		call Humidity.read();
	}

	event void Light_SenseTimer.fired() {
		call Light.read();
	}

	event void Humidity.readDone(error_t ok, uint16_t val) {
		if (ok == SUCCESS) {
			m_humidity = val;
			flag_hum++;
			post report_humidity();
		}
	}
	event void Light.readDone(error_t ok, uint16_t val) {
		if (ok == SUCCESS) {
			m_light = val;
			flag_light++;
			post report_light();
		}
	}

	event void RadioControl.stopDone(error_t e) {}
}
