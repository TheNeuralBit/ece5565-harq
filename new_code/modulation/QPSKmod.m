function [ QPSKmod ] = QPSKmod(input)
%QPSK Modulation
% This function modulates any length bit stream to QPSK modulation with
% four different phases.  The output is a stream of symbols.

% First need to check if we have an odd number of input bits. If so append
% with a 0 since QPSK groups via pairs.
if(mod(length(input),2)~=0)
input = [input, 0];
end

%variables
in_length=length(input);    %Length of bits
qpsk=zeros(1,in_length/2);

%The QPSK symbols will be mapped via Gray Coding to achieve the highest BER
%rate. One bit difference in every adjacent quadrant.  Here we must also
%normalize the output power by multiplying it the symbol by 1/sqrt(2).
for i=1:in_length/2
bits1=input(2*i);
bits2=input(2*i-1);
if (bits1==0)&&(bits2==0)
qpsk(i)=(1/sqrt(2))*(1+1i);
end
if (bits1==0)&&(bits2==1)
qpsk(i)=(1/sqrt(2))*(-1+1i);
end
if (bits1==1)&&(bits2==1)
qpsk(i)=(1/sqrt(2))*(-1-1i);
end
if (bits1==1)&&(bits2==0)
qpsk(i)=(1/sqrt(2))*(1-1i);
end

end

QPSKmod=qpsk;







