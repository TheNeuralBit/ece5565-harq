function [ out_bits ] = unpacketizeBits(in_bits, headerSize)
%unpacketizeBits:
%
%Input: 
%  in_bits: matrix of real-valued bits (ones and zeros) where each column
%    column gives one packet of bits.
%  headerSize: Size of header denoting data size
%
%Output:
%  out_bits: vector of real-valued bits (ones and zeros)
%
%  NOTE: Each packet will consist of headerSize bits of overhead, that give 
%    the size of the actual data content.  The remaining part of the packet 
%    (packetSize - headerSize bits) will consist of the data and (possibly)
%    zero padding.  The input matrix will be of size
%    packetSize x ceil(length(in_bits)/packetSize). Note that the last 
%    packet will be zero-padded so the total size is packetSize.
%       


%Set up initial variables
numPackets = size(in_bits,2);
paritySize = 3;
dataSizeHeader = headerSize - paritySize;
maxDataSize = size(in_bits,1)-headerSize;
out_bits = [];

for a = 1:numPackets
    dataSizeBits = in_bits(1:dataSizeHeader,a);
    parity = mod(sum(dataSizeBits),2);
    parityBits = in_bits(dataSizeHeader+1:headerSize,a);
    unmatchingParity = nnz(parityBits-parity); %Number of parity bits that do not match 
    dataSize = sum(dataSizeBits'.*2.^(numel(dataSizeBits)-1:-1:0));
    if (dataSize > maxDataSize) || (unmatchingParity > 1)
        dataSize = maxDataSize;
        if a == numPackets
            fprintf('Warning: Possible error in header of last packet. Using full packet size, but may end up with too many bits.\n')
        else
            fprintf('Warning: Possible error in header of middle packet #%d. Using full packet size.\n', a)
        end    
    end
    out_bits = [out_bits; in_bits(headerSize+1:headerSize+dataSize,a)];
end
out_bits = out_bits';


end

