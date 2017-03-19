# Link Layer Tasks in General
1. **Framing**: Group sequence of bits into packets/frames
2. **Error control**: make sure that transmitted bits arrive and no others
3. **Flow control**: ensure that a faster sender does not overrun a slower receiver
4. **Link management**: discover/manage links to meighbors 

# Error Control
## Overview
1. ensure that the data transfer is:
    1. Error-free:
    2. In-sequence:
    3. Duplication-free:
    4. Loss-free:
    5. Energy-efficiency
2. Reasons for bit errors or packet losses:
    1. interference
    2. fading
    3. loss of synchronization
3. Approaches:
    1. Open-loop: Forward Error Correction(FEC)
    2. Close-loop: ARQ(Automatic Repeat Request) schemes, retransmissions
    3. Hybrid approaches

## ARQ Design Aspects
1. Basic procedure:
    1. Transmitter prepares packet
    2. Transmitter sends packet and sets timer
    3. Receiver provides **feedback** to transmitter
    4. If sender infers that packet has not been received correctly, it will retransmits
2. Standard-ARQ protocols:
    1. alternating-bit (stop-wait)
    2. goback-N
    3. selective repeat
    4. for WSNs alternating bit is often sufficient,[todo]since the bitrates in WSN are always low

## How to Use ACK(Acknowledgments)?
1. Be careful about ACKs from different layers
2. Do not necessarily acknowledge every packet -- use cumulative ACKs
    1. Example scheme: send ACK every *W* packets, after timeout or after duplicate packet -- ACK contains information about packets since lask ACK
    2. Tradeoff against buffer space
3. ACKs: wasteful over excellent links
4. NACKs: additional mechanisms
5. Implicit ACKs: useful with multi-hop forwarding

   "I send you a packet and I hear you forwarding the same packet, so I don't need an extra ACK"

## When to Retransmit?
1. For stationary BSC: any time
2. For fading channel: postpone until deep fade ends( > coherence time )
3. How long to wait: 
    1. probing protocol
        1. two protocol modes, "normal" and "probing"
        2. when error occurs, switch to probing mode
        3. In probing mode, periodically send short packets until sucessful go to normal mode
    2. wait for some fixed time, e.g. the coherence time plus some safety margin

# Framing
## Packet Size
1. Small packets: lower error rate, highter packetzation overhead
2. Large packets: higher error rate, lower packetzation overhead
3. Depends on BER(bit error rate), energy consumption

