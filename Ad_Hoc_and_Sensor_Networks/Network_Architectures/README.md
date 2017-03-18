# Global structure
![Network Architectures](./Network_Architecture_MindMap.png)

# Motivation and applications
## Infrastructure-based Wireless Networks
1. Typical wireless networks have an **infrastructure**:
  * UMTS/LTE/WiFi hotspots, etc., typically base stations(BS) or access points(AP) are connected to wired backbone
  * Infrastructure is exploited for asymmetric protocol design
  * Inter-mobile traffic relayed through backbone, no peer-to-peer communication
![](http://oga6pysjo.bkt.gdipper.com/image/Course-Ad-Hoc/infrastructure.jpg)
2. Crucial property: infrastructure network has nodes which cannot be removed without breaking network operation
  * For example: AP, BS
3. What if:
  * No infrastructure is available?

       Disaster areas
  * It is to expensive / inconvenient to set up?

       At remote areas
  * There is no time to set it up?

       Military operations

## Possible Applications for Infrastructure-free Networks
1. Personal-area networking
  * Connecting devices to computer
  * Monitoring vital functions with body sensor networks
2. Car-to-car communication
3. Disaster recovery
4. Factory automation(e.g. autonomous robots)

# Wireless Ad-hoc Networks
## Definition
1. Try to construct network without infrastructure, using networking capabilities of participants
  * This is an ad-hoc network- a network constructed for a special purpose and for limited time
  * "Without infrastructure" means: without nodes that are indispensable - it is still possible to have role sharing but every node must be able to take over each role
2. Simple example: laptops in a conference/lecture room
![](http://oga6pysjo.bkt.gdipper.com/image/Course-Ad-Hoc/Computers-in-a-room.jpg)
3. Popular acronym: MANET = Mobile Ad hoc NETwork

## Challenges
1. Without central infrastructure things become much more difficult
2. Problems due to:
  * Lack of central entity for organization
  * Limited range of wireless communication
  * Mobility of participants
  * Complexity of participants
3. Solutions
  * No central entity => self-organization
    * Without central entity participants must organize the network themselves
    * Example domains:
      * Medium access control
      * Address allocation
      * Routing
      * Topology control
      * QoS support(e.g. resource reservations)
      * Role and task assignment
    * Stations need possibly more complex software, since no protocol burdens can be shifted to infrastructure stations
  * Limited range => Multi-hopping
    * Limited communication range results e.g. from:
      * Reduced transmit power in attempt to lower power consumption
      * Impact of path loss, fading, interference, etc.
    * In many applications information must be conveyed over distances significantly larger than communication range
      * multi-hop operation
      * routing
    * Potential benefit: communication over intermediate hops can be more energy-efficient

       ![](http://oga6pysjo.bkt.gdipper.com/image/Course-Ad-Hoc/Multi-hopping.jpg)

  * Mobility => Adaptive Protocols
    * In many (not all!) ad hoc network applications participants/nodes can move around
      * Or the whole network can move as a whole (e.g. Body Sensor Networks)
    * Environment can be mobile as well!
    * Consequence: time-varying topology!
      * Rate of topological changes depends on mobile speeds and transmission ranges
      * Typically much higher than for wired networks
      * Routing protocols must be designed to cope with this
      * Additional problem: network scale, especially in WSNs

# Wireless Sensor Networks
## Important conclusions
1. The traffic carried consists of sensor and actuation data instead of web pages, multimedia
2. This leads to significantly different packet size and inter-arrival time statistics
3. The protocols can know the carried data and take it into consideration in their operation

   => **data-centric networking**

## Applications
1. Environmental Monitoring
2. Machine diagnosis and preventive maintenance
3. Monitoring mechanical stress

## Comparison: MANET vs. WSN
1. Commonalities: self-organization, energy-efficiency, multi-hop
2. Differences:

   | Factors         |             WSN |            MANET |
   | :-------------: | :-------------: | :--------------: |
   | Interaction    | with environment| close to humans           |
   | Scale       |     larger   |   smaller   |
   | Equipment       | vise | more powerful and expensive equipment           |
   | Energy | tighter requirement| node recharged after few hours           |
   | Mobility | often static | all nodes can move           |
   | Application-specific | depend much stronger on application specifics | uniform and similar to IP networks            |
   | Centric | data-centric       | node id centric           |
   | Standards | [IEEE 802.15.4](https://github.com/sulxxy/Course_Ad_Hoc_and_Sensor_Networks/tree/master/MAC#ieee-802154) | IEEE 802.11 |

# WSN Network Architectures
