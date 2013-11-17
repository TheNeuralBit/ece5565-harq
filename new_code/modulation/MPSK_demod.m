function [ bits, softbits ] = MPSK_demod(input_samp, N, offset)
%QPSK Demodulation
% This function demodulates the QPSK complex samples into a bit stream.
% The output is a stream of bits.  The number of bits should be twice the
% length of the input, which is in complex samples.


%plot the received symbols
%plot(input_samp,'o')
%title('Received Symbols after Synchronization');

%variables
M = 2^N;
symbol_length=length(input_samp);    %Length of complex symbols
bits=zeros(1,symbol_length*N);


%Because the modulation was done via Gray Coding, we can determine the bits
%via demodulation by examining the sign of the real and imaginary parts of
%the complex symbols.
for idx=1:length(input_samp)
    value = round(angle(input_samp(idx))*M/(2*pi));
    bits((idx-1)*N + 1:idx*N) = decimalToBinaryVector(value, N);
end
