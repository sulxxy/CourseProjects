# Binary Counter Interface
Declare an interface called BinCounter, which offers the following commands and events:
<pre><code>
interface BinCounter {
	command void start();
	command void stop();
	event void completed();
}
</pre></code>
When start() is called the counter should start, and the (binary)value should be displayed using the LEDs (like in the Blink application).  With stop() , the counter should be stopped and all LEDs have to be off.  The completed() event should signal every time the counter overruns and becomes zero again.

Write a module which provides this interface and then write a second module to test your interface. The testing module should start the counting when the node booted successfully and stop it after the counter  nishes counting 4 times.
