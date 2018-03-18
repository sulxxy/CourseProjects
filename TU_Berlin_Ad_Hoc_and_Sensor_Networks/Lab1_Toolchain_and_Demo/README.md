# Installation of TinyOS
According to the project website: “ TinyOS is an open-source operating system designed  for  wireless  embedded  sensor  networks.   It  features  a  component-based architecture which enables rapid innovation and implementation while minimizing code size as required by the severe memory constraints inherent in sensor networks. TinyOS’s component library includes network protocols, distributed services, sensor drivers, and data acquisition tools - all of which can be used as-is or be further refined for a custom application.  TinyOS’s event-driven execution model enables fine-grained power management yet allows the scheduling flexibility made necessary by the unpredictable nature of wireless  communication and physical world interfaces. “

This Lab is comprised of the following activities.  In section 1.1 we will install TinyOS, utilizing a custom install script that simplifies th e task. In section 1.2 we will compile and install software on 1) a border router nod e that is connected via cable with the PC and 2) a wireless node, which can be acces sed through the border router. Utilizing a simple shell-like interface o n the node we will then explore the network connectivity and the services that are offered by the wireless node.

## Installation of TinyOS
1. First download the install script from the course ISIS website.
2. Make the script executable by running the following in a terminal:
   > $ chmod +x ./tos-install-v2.sh
3. Execute it like this
   > $ ./tos-install-v2.sh <channel number>
   The script has one parameter, which is the channel that will b e used for the radio. We will allocate a channel number for every group in th e class, in order to avoid accidental cross-group packets.
4. Test your installation by navigating to <home>/wsnpr/tinyos-main/apps/Blink and executing make telosb . If everything is set up correctly, you should see output similar to
   <pre><code>
   [INFO] script
   2538 bytes in ROM
   56 bytes in RAM
   [INFO] size (toolchain):
   text    data     bss     dec     hex filename
   2596       2      56    2654     a5e build/telosb/main.exe
   [INFO] generating symbol table
   [INFO] generating listing
   [INFO] creating ihex file
   [INFO] writing TOS image
   [INFO] writing TOS buildinfo
   [INFO] running the wiring check
   </pre></code>
5. In order to finish the installation, you will have to log out and log in again. This step is needed for the group settings to be updated (your user joined the group dialout to have access to the serial ports for programming the nodes) .
   The installation process also created a folder <home>/wsnpr/util , which was added to PATH . Every executable/script (with executable flag set) placed in this folder can be executed in a similar way to the executables pla ced in /usr/bin ).
   Some scripts are already provided, which handle for example the PPP daemon used for communication betwen the PC and the TinyOS border ro uter. Place any additional executable utilities you might need in the later Labs here. 1.1.1  General instructions Before installing an image on a sensor node, you have to build the application for the target you are using. Targets tell the Make system which h ardware platform you are intending to build the application for.  Targets repr esent the complete hardware system one wants to compile software for. Platform s represent the base hardware and the microcontroller. Extras allow for further configuration about how an application is built or for running additional comman ds after compilation is complete. You can install an image on a mote via USB. When installing and/o r building an image you have the options shown in table 1.
   Typing:
   > $ make target install
   
   actually leads to:
   > $ make target install bsl,auto
   
   The commands above do not specify on which node the image will b e installed.
   In this case the bootstrap loader (bsl) will install the image on the first node it discovers. If you have several different nodes connected via USB, you should use the bsl option to define on which one you want to install. Typing:
   > $ make target install bsl,usbdevice
   
   will install the image on the sensor node that is connected to the USB as the device usbdevice , e.g. /dev/ttyUSB0.
   
   All of those commands have to be run from the directory where th e application Makefile is located. To show which USB port your mote is connected to, type
   > $ motelist
   
   This will list all nodes currently connected via USB and their corresponding device names.

##  Hands-On with PppRouter and Showcase
###  PppRouter and Showcase installation
We are going to set up a small IPv6 network compromised of one b order router and one sensor node. Install the PppRouter (the TinyOS borde r router) and the Showcase application on the sensor nodes 2 : a) Install the PppRouter application in <home>/wsnpr/apps/PppRouter on your first node with
> $ make telosb install

This command does not specify an explicit Node ID, which is assumed to be 1. The PppRo uter always need a Node ID=1! If more than one node is connected modify the commands according to Sec tion 1.1.1 b) Now install the Showcase application in <home>/wsnpr/apps/Showcase on your second node with a Node ID different from 1. Do this by put ting the Node ID after the install extra like this
> $ make telosb install,2 bsl,/dev/ttyUSB1

This will install the app and the Node ID will be 2.

###  Ping and UDP-shell
1. Now start a PPP tunnel between the host PC and the PppRouter a pplication on the border router node by typing:
   > $ tos-pppd start 0 
   (if the PppRouter node is connected to /dev/ttyUSB0 ).
   This script can be found in the <home>/wsnpr/util folder. It wraps the calls to start pppd and to configure the interface. By default only link local addresses are available (fe80::). So it adds the fec0:: (sit e local addresses) to the ppp0 interface. You can stop pppd by executing
   > $ tos-pppd kill
   The output of pppd can be found in /var/log/pppd-tos .
2. Use the command
   > $ ifconfig ppp0
   to see that the above command has created a new network interface on the host system called ppp0 .
3. Try to connect to the Showcase node (if your network addres s is fec0 (default) and the interface ID is the Node ID of the node, in this case 2):
   **ping6 fec0::2** pings the node
   **nc6 -u fec0::2 7** starts a simple UDP Echo application: enter any text and it will be echoed back to you by the remote node.
   **nc6 -u fec0::2 2000** starts a UDP-shell: enter ”help” for more informa- tion and try the different functions provided by the UDP-shell .
4. You can also use
   > sudo wireshark
   and capture the traffic on the interface ppp0 to understand the exchange of the messages behind the ab ove commands. “ netcat is a unix utility which reads and writes data across network connections, using TCP or UDP protocol over IPv4 or IPv6 networks. ”
   The basic syntax is
   > nc6 host port
   to open a TCP connection, to use UDP the optional pa- rameter -u has to be added (see netcat6 manpage for more information).

