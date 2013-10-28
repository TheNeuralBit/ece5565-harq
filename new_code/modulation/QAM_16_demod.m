function [qam16bits,softbit] = QAM_16_demod(input_samp)
%16 QAM Demodulation
% This function demodulates the 16 QAM complex samples into a bit stream.
% The output is a stream of bits.  The number of bits should be four times
% the length of the input, which is in complex samples.

%Quadrants in this order - 3 3, 2 2, 3 3, 2 2, 4 4, 1 1, 4 4, 1 1
dec2vect = create_dec2vect(4);

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


% Initialization
soft = [];
softbit= [];

% Unnormalize symbols
input_samp=sqrt(10)*input_samp;

% Determining decision and demapping of data
symbol_length=length(input_samp);    %Length of complex symbols
qam16bits=zeros(1,symbol_length*4);

for i=1:symbol_length
% Find the minimum distance between received symbol and symbol map to
% determine the actual recevied symbol
[df, index]=min(input_samp(i)-symbolMap);

%plot(df,'o')

% Subtract 1 since it has a 0th index
symindex=index - 1;

% Soft decisions for 16 QAM
bit0 = real(input_samp(i));
bit1 = -1*abs(real(input_samp(i)))+2;
bit2 = imag(input_samp(i));
bit3 = -1*abs(imag(input_samp(i)))+2;
soft = [bit0;bit1;bit2;bit3];
softbit = [softbit; soft];

%Convert decimal number to binary vector bits 
qam16bits((i-1)*4+1:(i-1)*4+4) = dec2vect(symindex+1,:);


end

softbit=softbit(:)';

%For the Viterbi coding, need to make softbits negative
softbit=-softbit;

