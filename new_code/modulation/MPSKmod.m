function [ samples ] = MPSKmod(input_bits, N, offset)
%QPSK Modulation
% This function modulates any length bit stream to QPSK modulation with
% four different phases.  The output is a stream of symbols.

% First need to check if we have an odd number of input bits. If so append
% with a 0 since QPSK groups via pairs.
M = 2^N;
mod_N = mod(length(input_bits), N);
if ( mod_N ~=0 )
    input = [input_bits, zeros(1, mod_N)];
end

%variables
in_length = length(input_bits);    %Length of bits
samples = zeros(1, in_length/N);

%The QPSK symbols will be mapped via Gray Coding to achieve the highest BER
%rate. One bit difference in every adjacent quadrant.  Here we must also
%normalize the output power by multiplying it the symbol by 1/sqrt(2).
for i=1:length(samples)
    value_bits = input_bits((i-1)*N + 1:i*N);
    value = binaryVectorToDecimal(value_bits);
    phase = value*2*pi/M + offset;
    samples(i) = 1/sqrt(2)*exp(j*phase);
end
