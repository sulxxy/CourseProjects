#include <lib6lowpan/ip.h>
#include "sensing.h"

module SensingP {
	uses {
		interface Boot;
		interface Leds;
		interface SplitControl as RadioControl;
		interface UDP as SenseSend;
                interface UDP as SenseSend_Light;
		interface Timer<TMilli> as SenseTimer;
                interface Timer<TMilli> as SenseTimer_Light;
		interface Read<uint16_t> as Humidity;
                interface Read<uint16_t> as Light;
	}

} implementation {

	enum {
		SENSE_PERIOD = 500, // ms
                SENSE_PERIOD_LIGHT=128,
	};

	nx_struct sensing_report_Humidity stats;
        nx_struct sensing_report_Light stats_light;
	struct sockaddr_in6 route_dest;
        struct sockaddr_in6 route_dest_light;
	m_humidity = 0;
        m_light=0;
	event void Boot.booted() {
		call RadioControl.start();
	}

	event void RadioControl.startDone(error_t e) {
		route_dest.sin6_port = htons(8000);
                route_dest_light.sin6_port = htons(7000);
		inet_pton6(REPORT_DEST, &route_dest.sin6_addr);
                inet_pton6(REPORT_DEST, &route_dest_light.sin6_addr);
		call SenseTimer.startPeriodic(SENSE_PERIOD);
                call SenseTimer_Light.startPeriodic(SENSE_PERIOD_LIGHT);
	}

	task void report_humidity() {
		stats.seqno++;
		stats.sender = TOS_NODE_ID;//
		stats.humidity = m_humidity;
		call SenseSend.sendto(&route_dest, &stats, sizeof(stats));
	}
        task void report_light()  {
                stats_light.seqno++;
                stats_light.sender = TOS_NODE_ID;//
		stats_light.light = m_light;
		call SenseSend_Light.sendto(&route_dest_light, &stats_light, sizeof(stats_light));
        }
	event void SenseSend.recvfrom(struct sockaddr_in6 *from, 
			void *data, uint16_t len, struct ip6_metadata *meta) {}
        event void SenseSend_Light.recvfrom(struct sockaddr_in6 *from, 
			void *data, uint16_t len, struct ip6_metadata *meta) {}

	event void SenseTimer.fired() {
		call Humidity.read();
	}
        event void SenseTimer_Light.fired() {
		call Light.read();
	}
	event void Humidity.readDone(error_t ok, uint16_t val) {
		if (ok == SUCCESS) {
			m_humidity = val;
			post report_humidity();
		}
	}
        event void Light.readDone(error_t ok, uint16_t val) {
		if (ok == SUCCESS) {
			m_light = val;
			post report_light();
		}
	}
	event void RadioControl.stopDone(error_t e) {}
}
