#include <lib6lowpan/ip.h>

#include <Timer.h>
#include "blip_printf.h"

module LightP {
	uses {
		interface Boot;
		interface Leds;
		interface Timer<TMilli> as Timer1;
		interface SplitControl as RadioControl;
		interface Timer<TMilli> as SensorReadTimer;

		interface Read<uint16_t> as ReadPar;
		interface ReadStream<uint16_t> as StreamPar;

		interface ShellCommand as ReadCmd;
		interface ShellCommand as StreamCmd;
		interface ShellCommand as ChangeThresholdCmd;
	}
} implementation {

	enum {
		SAMPLE_RATE = 250,
		SAMPLE_SIZE = 10,
		NUM_SENSORS = 1,
	};

	bool timerStarted = FALSE;
	uint8_t m_remaining = NUM_SENSORS;
	uint32_t m_seq = 0;
	uint16_t m_par,m_tsr,m_hum,m_temp;
	uint16_t m_parSamples[SAMPLE_SIZE];
	uint16_t sample_period = 10000; // us -> 100 Hz
	int threshold = 10;


	event void Boot.booted() {
		call RadioControl.start();
	}

	error_t checkDone() {
		int len;
		char *reply_buf = call ReadCmd.getBuffer(128); 
		if (--m_remaining == 0) {
			len = sprintf(reply_buf, "%ld %d %d %d %d\r\n", m_seq, m_par,m_tsr,m_hum,m_temp);
			m_remaining = NUM_SENSORS;
			m_seq++;
			call ReadCmd.write(reply_buf, len);
		}
		return SUCCESS;
	}

	task void checkStreamPar() {
		uint8_t i;
		char *reply_buf = call StreamCmd.getBuffer(128);
		int len = 0;
		int sum = 0;

		if (reply_buf != NULL) {
			for (i = 0; i < SAMPLE_SIZE; i++) {
				sum += m_parSamples[i];
			}  
			len = sprintf(reply_buf, "[average: %d]\n", sum/SAMPLE_SIZE);
		}
		if (sum/SAMPLE_SIZE < threshold){
			call Leds.led0On();
		}else{
			call Leds.led0Off();
		}
		call StreamCmd.write(reply_buf, len+1);
	}

	event void SensorReadTimer.fired() {
		call ReadPar.read();
	}

	event void ReadPar.readDone(error_t e, uint16_t data) {
		m_par = data;
		checkDone();
	}

	event void StreamPar.readDone(error_t ok, uint32_t usActualPeriod) {
		if (ok == SUCCESS) {
			post checkStreamPar();
		}
	}
	
	event void Timer1.fired(){
		call StreamPar.postBuffer(m_parSamples, SAMPLE_SIZE);
		call StreamPar.read(sample_period);
	}

	event void StreamPar.bufferDone(error_t ok, uint16_t *buf,uint16_t count) {}

	event char* ReadCmd.eval(int argc, char** argv) {
		char* reply_buf = call ReadCmd.getBuffer(18);
		if (timerStarted == FALSE) {
			strcpy(reply_buf, ">>>Start sampling\n");
			call SensorReadTimer.startPeriodic(SAMPLE_RATE);
			timerStarted = TRUE;
		} else {
			strcpy(reply_buf, ">>>Stop sampling\n");
			call SensorReadTimer.stop();
			timerStarted = FALSE;
		}
		return reply_buf;
	}

	event char* StreamCmd.eval(int argc, char* argv[]) {
		char* reply_buf = call StreamCmd.getBuffer(35);
		call Timer1.startPeriodic(SAMPLE_RATE);
		switch (argc) {
			case 2:
				sample_period = atoi(argv[1]);
			case 1: 
				sprintf(reply_buf, "sampleperiod of %d\n", sample_period);
				break;
			default:
				strcpy(reply_buf, "Usage: stream <sampleperiod/in us>\n");
		}
		return reply_buf;
	}

	event char* ChangeThresholdCmd.eval(int argc, char* argv[]){
		char* ret = call ChangeThresholdCmd.getBuffer(32);
		threshold = atoi(argv[1]);
		snprintf(ret, 32, "Changed threshold to %d\n", threshold);
		return ret;
	}

	event void RadioControl.startDone(error_t e) {}
	event void RadioControl.stopDone(error_t e) {}
}
