function [ BFSK, time ] = BFSKmod(input, fs)
%BFSK Modulation
% This function modulates any length bit stream to a BFSK modulation with
% two different frequencies.  The output is a bit stream of the same
% length modulated 
in_length=length(input);

% Two phases for BFSK
freq1=45;
freq2=135;

%Length of 1 bit.. I believe this needs to be different though cause he
%wants sample rate of 10Msps and 4 Samples per symbol
t= 0:1/fs:1;
time=[];
BFSK=[];
    for i=1:1:in_length
        if (input(i)==0)
            BFSK=[BFSK sin(2*pi*freq1*t)];
        elseif (input(i)==1)
            BFSK=[BFSK sin(2*pi*freq2*t)];
        else
            error('BFSKmod','Input bit does not equal 0 or 1')
        end
        time = [time t];
        t=t+1;
    end


end
