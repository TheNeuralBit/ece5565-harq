headerSize = 16;
packetSize = 2048;
NUM_BITS = 4000;
input_bits = randn(NUM_BITS, 1)<0;
packets = packetizeBits(input_bits,headerSize,packetSize);

%Insert a header error
%if packets(1,1)== 0
%    packets(1,1) = 1;
%else
%    packets(1,1) = 0;
%end

output_bits = unpacketizeBits(packets,headerSize);

num_errors = sum(abs(input_bits-output_bits))