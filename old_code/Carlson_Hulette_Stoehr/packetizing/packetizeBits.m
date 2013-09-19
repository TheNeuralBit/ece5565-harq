function [ out_bits ] = packetizeBits(in_bits, headerSize, packetSize)
%packetizeBits:
%
%Input: 
%  in_bits: vector of real-valued bits (ones and zeros)
%  headerSize: Size of header denoting data size
%  packetSize: Size of each packet (max size of 2^16-1+headerSize)
%
%Output:
%  out_bits: matrix of real-valued bits (ones and zeros) where each column
%    column gives one packet of bits.  
%
%  NOTE: Each packet will consist of headerSize bits of overhead, that give 
%    the size of the actual data content.  The remaining part of the packet 
%    (packetSize - headerSize bits) will consist of the data and (possibly)
%    zero padding.  The output matrix will be of size
%    packetSize x ceil(length(in_bits)/packetSize). Note that the last 
%    packet will be zero-padded so the total size is packetSize.
%    

%Standardize to column vector
if(size(in_bits,1) == 1)
    in_bits = in_bits';
end


%Set up initial variables
paritySize = 3;
dataSizeHeader = headerSize - paritySize;
numBits = length(in_bits);
maxDataSize = packetSize - headerSize;
numPackets = ceil(numBits/maxDataSize);
out_bits = zeros(packetSize,numPackets);
dataSizeBits = zeros(dataSizeHeader,1);
parityBits = zeros(paritySize,1);
dec2vect = create_dec2vect(dataSizeHeader);

%Check packet size
if packetSize > 2^headerSize-1+headerSize
    error('Specified packet size is too large for the given header size')
end


startBit = 1;
for a = 1:numPackets
    dataSize = length(in_bits(startBit:end));
    if(dataSize > maxDataSize)
        dataSize = maxDataSize;
    end
    paddingSize = maxDataSize - dataSize;
    paddingBits = zeros(paddingSize,1);

    dataSizeBits = dec2vect(dataSize+1,:)';
    parity = mod(sum(dataSizeBits),2);
    parityBits = zeros(paritySize,1)+parity;
    out_bits(:,a) = [dataSizeBits; parityBits; in_bits(startBit:startBit+dataSize-1); paddingBits];
    startBit = startBit + dataSize;
end

end

