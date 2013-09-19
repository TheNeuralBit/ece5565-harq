function [ QPSKbits, softbits ] = QPSK_demod(input_samp)
%QPSK Demodulation
% This function demodulates the QPSK complex samples into a bit stream.
% The output is a stream of bits.  The number of bits should be twice the
% length of the input, which is in complex samples.


%plot the received symbols
%plot(input_samp,'o')
%title('Received Symbols after Synchronization');

%variables
symbol_length=length(input_samp);    %Length of complex symbols
qpskbits=zeros(1,symbol_length*2);


%Because the modulation was done via Gray Coding, we can determine the bits
%via demodulation by examining the sign of the real and imaginary parts of
%the complex symbols.
bits_real = real(input_samp)<0;
bits_imag = imag(input_samp)<0;
qpskbits= [bits_real;bits_imag];
qpskbits=qpskbits(:)';
QPSKbits=qpskbits;
softbits = [real(input_samp);imag(input_samp)];
softbits = softbits(:)';



