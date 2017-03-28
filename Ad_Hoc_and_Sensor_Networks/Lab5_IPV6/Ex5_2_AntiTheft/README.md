# AntiTheft Application
Using your AntiTheft application as basis, develop a networked “Smoke alarm” application that not only displays the alarm as a message on a host PC via UDPShell, but also disseminates this alarm to all other nodes in the network, who should generate a visual alert by flashing their LEDs.

You first need to define formats for settings and alarm report messages which must be understood by all nodes in the network. Then you should extend your application with the feature of dissemination and interpretation of smoke alarm reports, dissemination of settings to all nodes if the settings of one node are changed, and request settings from all nodes when a node boots:

1. *Setting type format* Define a settings type with sample period, sample time and threshold and a settings report with the format:
   
   ```
       typedef nx_struct settings {
           nx_uint16_t threshold;
           nx_uint32_t sample_time;
           nx_uint32_t sample_period;
       }settings_t;
   
       nx_struct settings_report {
           nx_uint16_t sender;
           nx_uint8_t type;
           settings_t settings;
       };
   ```
   **Sample_period** is the time for the read stream interface and sample time the time for the timer which will start the streaming. So with a sample period of 256 and sample time set to 10000, every 10 s the streaming will be started and every 256 µs a sample is taken. The settings report contains the sender’s node ID. For the type field an enum with the following values should be defined:
   ```
       enum {
           SETTINGS_REQUEST = 1,
           SETTINGS_RESPONSE = 2,
           SETTINGS_USER = 4,
       };
   ```

2. *Alarm type format* Define an alarm report struct with the format:
   
   ```
       nx_struct alarm_report {
           nx_uint16_t source;
       };
   ```
   Here source is the ID of the sensor detecting the smoke.

3. *Alarm report dissemination* Modify your application so that a alarm report is sent out to all nodes on port 7000 if the calculated variance is above the threshold.

4. *Visual alarm* When receiving a message on port 7000, the LEDs should display the node’s ID of the alarm generating node. Think of a scheme how you can effectively display the ID of a node even for node IDs that are larger than 7, using only the 3 LEDs at your disposal.

5. *Dissemination of settings* The settings should also be sent out to all nodes if they were changed on one node (port 4000). In this case the type for the **settings_report** is **SETTINGS_USER**. If your node receives a message with this type you have to save the new settings to your node.

6. *Settings request* When a new node connects to the network it should ask the network for the settings. In this case a **SETTINGS_REQUEST** has to be sent and all nodes receiving a request have to respond with the current settings in a **SETTINGS_RESPONSE**.
