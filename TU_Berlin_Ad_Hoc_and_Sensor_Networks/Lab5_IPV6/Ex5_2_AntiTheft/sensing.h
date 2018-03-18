#ifndef SENSING_H_
#define SENSING_H_

#include <IPDispatch.h>

enum {
  AM_SENSING_REPORT = -1
};


typedef nx_struct settings {
  nx_uint16_t sample_period;
  nx_uint16_t sample_time;
  nx_uint16_t light_threshold;
} settings_t;

nx_struct setting_report {
  nx_uint16_t sender;
  nx_uint8_t type;
  settings_t settings;
} ;

nx_struct sensing_report {
  nx_uint16_t seqno;
  nx_uint16_t sender;
  nx_uint16_t light;
};

#define REPORT_DEST "fec0::100"
#define MULTICAST "ff02::1"

#endif
