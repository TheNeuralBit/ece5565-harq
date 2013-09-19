ECE5654 Final Project
Craig Carlson, Brian Hulette, Ruth Stoehr
5/1/2013

Note that the following directories all need to be in your path to run the
simulation:
- coding
- detection_equalization
- packetizing
- pulse_shaping
- synchronization

Configuration
-------------
Our system was designed to be very configurable.  Various system parameters
can be modified in configuration.m, and that will affect the behavior of
both MyTransmitter and MyReceiver.

Simulating at low Eb/N0 or with fading
--------------------------------------
When simulating in conditions that will likely cause a high BER, it is
probably best to turn packetization OFF and only run the system with an
integer multiple of the packet size in bits.  Packetization can be turned
off by  opening configuration.m and setting:

PACKETIZE = 0;

The default packet size is 2048 bits, so you should be able to transmit any
message of length N*2048 bits without packetization turned on.

Our packetization and depacketization can handle most errors within the
header, but in high BER scenarios it can miss some.  When run with 
packetization turned on at a low Eb/N0, our system may return a message 
with the wrong length due to errors in the header bits.  For this reason,
it is often easier to simulate at low Eb/N0 with packetization turned off.