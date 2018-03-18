#include <lib6lowpan/ip.h>
#include <ctype.h>

module EchoP {
	uses {
		interface Boot;
		interface Leds;
		interface SplitControl as RadioControl;

		interface UDP as Echo;
	}
} implementation {

	event void Boot.booted() {
		call RadioControl.start();
		call Echo.bind(7);
		call Leds.led1On();
	}

	uint64_t re_order(uint64_t src){
		int i = 0;
		uint64_t ret;
		uint64_t a[4];
		for(i = 0; i < 8; i++){
			a[i] = src & 0xff;
			src = src >> 8;
		}
		ret = (a[0] << 56) + (a[1] << 40) + (a[2] << 24) + (a[3] << 8)
			+ (a[4] >> 8) + (a[5] >> 24) + (a[6] >> 40) + (a[7] >> 56);
		return ret;
	}

	event void Echo.recvfrom(struct sockaddr_in6 *from, void *data,
			  uint16_t len, struct ip6_metadata *meta) {
		char* str = data ;
		uint64_t i;
		uint64_t i_reverse;
		bool isNumber = TRUE;

		for (i = 0; i < len - 1; i++) {
			if (!isdigit(str[i])) {
				isNumber = FALSE;
				break;
			}
		}

		if (isNumber) {
			i = atoll(str);
			i_reverse = re_order(i);
			call Echo.sendto(from, &i_reverse, sizeof(uint64_t));
		} else { 
			call Echo.sendto(from, data, len);
		}
	}

	event void RadioControl.startDone(error_t e) {}

	event void RadioControl.stopDone(error_t e) {}  
}
