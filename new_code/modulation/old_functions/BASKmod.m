function [ BASK, time ] = BASKmod(input, fs)
%BASK Modulation
% This function modulates any length bit stream to a BASK modulation with
% two different amplitudes.  The output is a bit stream of the same
% length modulated 
in_length=length(input);

% Two phases for BASK
amplitude1=0;
amplitude2=3;

f=2;

%Length of 1 bit.. I believe this needs to be different though cause he
%wants sample rate of 10Msps and 4 Samples per symbol
t= 0:1/fs:1;

time=[];
BASK=[];
    for i=1:1:in_length
        if (input(i)==0)
            BASK=[BASK amplitude1.*sin(2*pi*f*t)];
        elseif (input(i)==1)
            BASK=[BASK amplitude2.*sin(2*pi*f*t)];
        else
            error('BASKmod','Input bit does not equal 0 or 1')
        end
        time = [time t];
        t=t+1;
    end


end


