module DirectionP {
	uses {
		interface Boot;
		interface SplitControl as RadioControl;
        interface GeneralIO as Forward;
        interface GeneralIO as Backward;

		interface ShellCommand as ForwardCmd;   
		interface ShellCommand as BackwardCmd;   
		interface ShellCommand as StopCmd;
	}
} implementation {

	event void Boot.booted() {
		call RadioControl.start();
	}

	event char* ForwardCmd.eval(int argc, char* argv[]) {
            call Backward.clr();
            call Forward.set();
		return NULL;
	}

	event char* BackwardCmd.eval(int argc, char* argv[]) {
            call Forward.clr();
            call Backward.set();
		return NULL;
	}

	event char* StopCmd.eval(int argc, char* argv[]) {
            call Backward.clr();
            call Forward.clr();
		return NULL;
	}

	event void RadioControl.startDone(error_t e) {}
	event void RadioControl.stopDone(error_t e) {}
}
