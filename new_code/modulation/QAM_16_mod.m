function [ QAM16mod ] = QAM_16_mod(input)
% 16 QAM Modulation
% This function modulates any length bit stream to 16 QaM modulation with.
% The output is a stream of complex symbols with heights -3, -1, 1, 3.
in_length=length(input);

% Check to make sure that the input length is a multiple of 4
if(mod(in_length,4)~=0)
%Append the number of zeros needed to make bit length a multiple of 4
appendbits=4-mod(in_length,4);
for i=1:appendbits
input = [input , 0];
end
%recalculate the new length of bits
in_length=length(input);
end

%Quadrants in this order - 3 3, 2 2, 3 3, 2 2, 4 4, 1 1, 4 4, 1 1
symbolMap=zeros(1,16);
for a=1:16
%4 Quadrants (pi/4, 3pi/4, 5pi/4, 7pi/4)
z=0;
if(a<9)
if(a==1||a==2||a==5||a==6)
n=5;
if(a==1)
z=-2-2i;
end
if(a==2)
z=-2;
end
if(a==5)
z=-2i;
end
end
if(a==3||a==4||a==7||a==8)
n=3;
if(a==3)
z=-2+2i;
end
if(a==4)
z=-2;
end
if(a==7)
z=2i;
end
end
end
if(a>7)
if(a==9||a==10||a==13||a==14)
n=7;
if(a==9)
z=2-2i;
end
if(a==10)
z=2;
end
if(a==13)
z=-2i;
end
end
if(a==11||a==12||a==15||a==16)
n=1;
if(a==11)
z=2+2i;
end
if(a==12)
z=2;
end
if(a==15)
z=2i;
end
end
end
symbolMap(a)=sqrt(2)*exp(1i*n*pi/4)+z;
end

% Now take the input bits and map them to the symbols via Gray Coding - each
% adjacent symbol only differs by one bit. This will acheive the highest BER
% for 16 QAM.  The format will look as follows:
%                        |
%   0010(3)   0110(7)    |    1110(15)   1010(11)
%                        |
%                        |
%   0011(4)   0111(8)    |    1111(16)   1011(12)
%                        |
%   ---------------------------------------------  (Real)
%                        |
%                        |
%   0001(2)   0101(6)    |    1101(14)   1001(10)
%                        |
%                        |
%   0000(1)   0100(5)    |    1100(13)   1000(9)
%                        |
%                      (Imag)


QAM16mod=zeros(1,in_length/4);
a=1; %counter
for i=1:4:in_length

%Grab 4 bits at a time
LSBbits=input(i:i+3);

%Take into consideration MSB and LSB
MSBbits = fliplr(LSBbits);

%How to go from the bits to a location??
indexing=2^3*MSBbits(4)+2^2*MSBbits(3)+2^1*MSBbits(2)+2^0*MSBbits(1);

%Fill the QAM array with the complex samples via indexing from the look
%up table. We have to add 1 because of the 0000 indexing, which starts
%as 1.
QAM16mod(a) = 1/sqrt(10)*symbolMap(indexing+1);
a=a+1;
end

end