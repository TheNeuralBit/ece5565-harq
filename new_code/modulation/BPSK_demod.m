function [ bits, softbits ] = BPSK_demod(input_samp)
%BPSK Demodulation
% This function demodulates the BPSK complex samples into a bit stream.
% The output is a stream of bits.  The number of bits should be twice the
% length of the input, which is in complex samples.


%plot the received symbols
%plot(input_samp,'o')
%title('Received Symbols after Synchronization');

%variables

%Because the modulation was done via Gray Coding, we can determine the bits
%via demodulation by examining the sign of the real and imaginary parts of
%the complex symbols.
bits = real(input_samp)<0;
softbits = real(input_samp);
softbits = softbits(:)';
