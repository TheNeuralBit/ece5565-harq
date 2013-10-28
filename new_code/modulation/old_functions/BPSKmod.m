function [ BPSK, time ] = BPSKmod(input, fs)
%BPSK Modulation
% This function modulates any length bit stream to a BPSK modulation with
% two different phases, 0 and pi.  The output is a bit stream of the same
% length modulated 
in_length=length(input);

% Two phases for BPSK
phase1=0;
phase2=pi;

f=2;

%Length of 1 bit.. I believe this needs to be different though cause he
%wants sample rate of 10Msps and 4 Samples per symbol
t= 0:1/fs:1;
time=[];
BPSK=[];
    for i=1:1:in_length
        if (input(i)==0)
            BPSK=[BPSK sin(2*pi*f*t + phase1)];
        elseif (input(i)==1)
            BPSK=[BPSK sin(2*pi*f*t + phase2)];
        else
            error('BPSKmod','Input bit does not equal 0 or 1')
        end
        time = [time t];
        t=t+1;
    end


end

