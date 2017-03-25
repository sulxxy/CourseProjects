# Global Structure
![](./Routing_MindMap.png)

# Introduction
## Unicast, ID-centric Routing
1. Given: a network
2. Each node has a unique identifier
3. Goal: find a mechanism that allows a packet sent from an arbitrary node to arrive at some arbitrary destination node
    1. The routing and forwarding problem
    2. Routing: construct data structures(e.g. tables) that contain information how a given destination can be reached
    3. Forwarding: consult these data structures to forward a given packet to its next hop
4. Challenges in MANETs and WSNs:
    1. Nodes can move, topology can change
    2. Optimization metrics more complicated than "smallest hop count", they could include energy, delay, ...

## Ad-hoc Routing Protocols
1. Internet routing schemes(link state / distance vector algorithms) not really applicable
    1. Both construct a full network map in each router
    2. Distance vector algorithms(based on Bellman-Ford algorithm) use periodic beacons broadcasting a nodes routing table, additionally updates are sent upon changes
    3. Link state algorithms(based on Dijkstra algorithm) flood the network upon link status changes
    3. Both behave poorly under highly variable topologies, both are too slow in reacting to changes
2. One solution: **flooding**
    1. Does not need any information(routing tables) -- simple
    2. Packets are pretty reliably delivered to destination
    3. When nodes are highly mobile, might be the only solution
3. We need specific ad-hoc routing protocols
4. When does the routing protocol operate?
    1. Option 1: Routing protocol *always* tries to keep the routing tables up to date
        1. Routing tables are set up before first data is transmitted
        2. Benefit: all data packets have short delay
        3. Called **proactive** or **table-driven** routing
    2. Option 2: Route is only determined when actually needed
        1. Transmission of first packet triggers a **route discovery**
        2. Called **reactive** or **on-demand** routing
        3. Useful when always only a few stations communicate
        3. Typically coupled with soft-state mechanism to remove state / unused routes
    3. Option 3: Hybrids
    3. Best option depends on traffic patterns
4. Classifications
    1. According to underlying network topology
        1. **Flat routing**: in flat networks all nodes have the same role and participate in the same way in routing protocols
        2. **Hierarchical routing**: applicable in networks with a hierarchy among nodes, e.g. clustered networks
    2. According to the addressing scheme
        1. Arbitrary node-id? => id-centric routing
        2. Position of a node? => geographic routing
        3. Data-centric addressing => data-centric routing

# Flat routing
## Classical ad-hoc routing schemes
### Proactive Schemes -- OLSR
1. OLSR = Optimized Link State Routing Protocol
2. Optimization of the *classical* link state algorithm
    1. *multipoint relays*(MPRs)
    2. in OLSR, only MPRs can broadcast messages during flooding process
    3. Link-state information is generated only by the nodes elected to be MPRs
    3. Supports dissemination of partial link-sate information: An MPR can choose to report only the links between itself and the MPR selectors
3. MPRs
    1. The objective of MPR selection is for a node to select a subset of its neighbors such that a broadcast message retransmitted by these selected neighbors, will be received by all nodes 2 hops away

       [todo]figure page 12
    2. The neighbors of node N which are NOT in its MPR set, receive and process broadcast messages but do not retransmit broadcast messages received from the node N

       [todo]figure page 13
4. Topology Discovery
    1. [todo]figure page 16

### Reactive Schemes -- DSR
1. DSR = Dynamic Source Routing
2. Source-routing approach:
    1. Source knows a path towards destination
    2. Source writes this path(source route) into the packet, packet is forwarded along this path, each intermediate hop removes its address from the source route
    3. Strict source routing: path contains all nodes
    3. Loose source routing: path is incompletely specified
3. All nodes maintain a **route cache**:
    1. Here a node stores routes it has learned
    3. Soft state
2. A source wishing to transmit a packet proceeds as follows:
    1. Check cache for a route towards destination
    2. If a route is found, it is taken
    2. Otherwise, **route discovery** is triggered and packet is sent when this has been successfully completed
2. Source node *s* broadcast RREQ(route request) packet
    1. Contains source and destination address
    2. Contains a **request-id** unique to the source
    3. Contains a list of addresses, the **route record**, specifying the node sequence the RREQ packet has already taken
    4. Route record initialized to include only source address
4. Route Discovery
    1. Any node *x* receiving a RREQ performs:
        1. If *x* has already processed the request, packet is dropped
        2. If x's address is found in route record, packet is dropped
        3. If the target address is x, then a RREP(route reply) packet is returned, in which the(reversed) route record is included
        4. Otherwise, x appends his own address to the route record and re-broadcasts the packet
5. Route Maintenance
    1. Routes can be invalidated, e.g. due to mobility
    2. [todo]

### Reactive Schemes -- AODV
1. AODV = Ad-hoc On-demand Distance Vector routing
1. Similar approach as DR for discovery procedure
1. No source routing, but nodes maintain tables instead
    1. Makes packets shorter, at expense of buffer space in nodes
    3. Route table entries have soft state
    3. Table entry contains for a destination address:
        1. Next-hop node
        1. Destination sequence number
        3. Number of hops towards destination
3. Route Discovery
    1. Discovery triggered when source *s* wants to send packet to destination *d*, but has no entry for *d* in local routing table.
    2. Every node maintains 2 numbers:
        1. A node sequence number(seqno)
        2. A broadcast-id(B-ID)
    3. Source broadcasts RREQ including following fields:
        1. Source address, destination address
        2. Source seqno, destination seqno
        3. B-ID
        4. A hop counter
    4. A RREQ is identified by (SrcAddr, B-ID)
    5. Any node *x1* receiving a RREQ packet from predecessor *x0*:
        1. Checks whether it has already processed this, if so, packet is dropped
        2. When *x1* does not have any information about *d* in its routing table, it re-broadcasts RREQ after incrementing hop count
        4. *x1* notes the reverse path to *s* in his routing table, using the first predecessor *x0* from which this RREQ was received, together with source sequence number
    4. When RREQ from *x0* arrives at x1 = d or *x1* has a route towards d in its route table, then:
        1. *x1* checks whether RREQ was received over bi-directional link - if not, the RREQ is silently dropped
        2. if x1 != d, then x1 checks whether its route is fresh enough by comparing its stored seqno for *d* with destination seqno contained in RREQ
            1. if x1's seqno is lower than the one in the packet, x1 mush not use its route, but re-broadcast the RREQ
            2. Otherwise x1 unicasts a RREP back to x0, which includes SrcAddr, DstAddr, dest seqno, hop count, lifetime
        2. If x1 = d, then x1 increases its local seqno and returns RREP with the new seqno
    4. If a node x0 received an RREP from x1, it checks:
        1. If this is the first one for the given RREQ, it is forwarded unconditionally along the reverse route
        2. Any further RREP for a given RREQ  is forwarded only when its destination seqno is strictly larger than the one it last forwarded, or, in case both have the same sequence number, the new RREP contains route with smaller hop count
        3. When a RREP is forwarded, node x0 knows that x1 is the next hop to d and adds / modifies routing table entry
        3. This procedure sets up the forward path
3. Route Maintenance[todo]

### DSR vs. AODV
1. Both are reactive
2. Both are not energy-aware
4. Both require a certain amount of state:
    1. In DSR a node must keep state proportional to the number of its destination nodes
    1. In AODV a node must keep state proportional to the number of routes going through it

## Tree routing
### Introduction
1. In an often-found WSN architecture there is a single(or very few) sink node to which all sensors deliver their data
2. Natural approach:
  3. Construct a tree rooted at the sink
  3. Let all sensors forward their data along the Tree
  4. Sensors need only to know how to reach parent nodes, i.e. nodes "higher" in the tree
3. Example
  4. Layered-tree scheme
  5. CTR
  6. RPL

### CTP
#### Intro
1. CTP=Collection Tree Protocol
2. CTP is the default routing protocol used in TinyOS
3. Only covers the convergecast case
3. One or a few nodes(called **roots**) construct trees
5. Assumptions:
  6. A node possesses link-quality estimates towards its neighbors, providing an estimated number of transmission trials required to successfully receive ACK
    7. EXT=Expected Transmission Count
    8. Reflects link quality and energy effort required on a link
  7. Broadcast and unicast are available
  8. MAC/link layer uses immediate ACKs and retransmissions

#### EXT Values
7. A node x maintains for all its neighbors a table, a table entry for neighbor y contains:
  8. The address of y
  9. The ETX value of x towards y, ETX(x,y)
  10. The ETX value of y, ETX(y)
11. A ode x maintains an own ETX value ETX(x), which is the minimum over all neighbors y of ETX(x,y)+ETX(y)
12. Forwarding data packets, node x should choose the neighbor y minimizing ETX(x,y) + ETX(y)

#### Tree construction and Maintenance
1. **Data frames** are unicast, they contain among others:
  2. The ETX(x) value of the current sender x
  3. The address of the next hop node y
  4. A hop-count field is used to deal with routing loops
2. **Routing frames** are broadcast, they contain:
  3. The address of the current parent
  4. The own ETX(x) value of the sender x
3. If a node x receives a routing frame from neighbor y, it:
  4. updates its neighborhood table with y's new ETX(y) value
  5. computes its own new ETX(x) = min(y)ETX(x,y) + ETX(y)
  6. checks whether ETX(x) has changed(significantly) and, if so, broadcasts a routing frame with his new ETX(x) value
  7. If x is the parent of y and y has ETX(y) < ETX(x), then x broadcasts a routing frame
4. A node x can request transmission of routing frames by its neighbors, when it has not heard from them for long time

## Energy-efficient unicast
[todo]

### Goals

# Flat Data-centric Routing
## Publish/Subscribe
1. Desirable properties for WSNs
  2. **Decoupling in space**: neither sender nor receiver need to know the identity of their partner
    3. your current partner can sleep or die of energy depletion
    4. but a close-by node can give almost the same data
  5. **Decoupling in time**: "answer" not necessarily directly triggered by "question", asynchronous communication.
2. Publish/subscribe-paradigm
  3. **Publishers** publish data under certain names
  4. **Subscribers** can subscribe to such **named data**
  5. **Software bus** matches publishers with subscribers

## Directed Diffusion
### Basic idea
1. A sink disseminates **interest message**
2. This interest is stored in the network to let sources with matching data find a way to the sink
3. Avoid network-wide unique identifiers, only rely on data

### Phase1: Interest Dissemination
1. Nodes distribute interests in network, using flooding or scoped flooding like geocast
2. A node x remembers **all** neighbors from which it received the interest, sets up a gradient towards each one of them
3. A node that has matching data starts to transmit at a low rate along all its gradients
4. so for:
  5. sink floods the interest
  6. source node floods the data
5. A second phase is needed in which the number of paths that source data takes is reduced(**reinforcement**)

### Phase2: Gradient Reinforcement
1. As soon as the sink receives first data, it picks one of the neighbors delivering this data(e.g. the one that sent the first packet) and increases its gradient towards the sink by sending a *reinforcement* message, asking for data at higher retransmitted
2. This neighbor repeats the process by identifying a neighbor which can contribute new data(again, could be the one form which he received first fresh data) and forwards the *reinforcement* message
3. When the source receives the reinforcement, it also increases the respective gradient and sends data at increased rate along this gradient
4. This way, the *reinforcement* propagates to the source, nodes along this path have increased gradients
5. This mechanism is coupled with a soft-state mechanism for removing low-gradient paths
6. Result: a good path from source to sink is found

# Geographical Routing
## Dead Ends
Endless circle, cannot access destination.

## GPSR -- Greedy Perimeter Stateless Routing
1. Stateless means: nodes do not need more state than concerning their neighborhood, further state needed for routing is carried in  the packets
2. Greedy Forwarding
    1. if y-D < x- D, then x select y as next hop
    2. Maxpower graph
3. Perimeter Mode
    1. Planar graph
    2. right-hand rule
    3. as soon as find a node y, h - D < x - D, switch to greedy mode
