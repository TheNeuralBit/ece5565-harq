function [ out_bits ] = interleave(in_bits,block_size)
%packetizeBits:
%
%Input: 
%  in_bits: vector of real-valued bits (ones and zeros)
%  block_size: interleaver block will be of size block_size x block_size
%
%Output:
%  out_bits: vector of real-valued, interleaved bits
%
%  NOTE: Performs block interleaving and outputs vector of same size as
%   input. Note that this assumes that length(in_bits) is some multiple of 
%   block_size^2.  For uncoded packet size of 2048 bits, coded packets will
%   be 4096 bits, so block_size should be sqrt(4096)= 64.
%

%Set up initial variables
num_bits = length(in_bits);
numBitsInBlock = block_size^2;
numBlocks = floor(num_bits/numBitsInBlock);

%Interleave bits
block_bits = zeros(block_size,block_size);
out_bits = zeros(size(in_bits));
for a = 1:numBlocks
    bits = in_bits((a-1)*numBitsInBlock+1:a*numBitsInBlock);
    block_bits = reshape(bits,block_size,block_size);
    block_bits = block_bits.';
    block_bits = reshape(block_bits,size(bits));
    out_bits((a-1)*numBitsInBlock+1:a*numBitsInBlock) = block_bits;

end


end