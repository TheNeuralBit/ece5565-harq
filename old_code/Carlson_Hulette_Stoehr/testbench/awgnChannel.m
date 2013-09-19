function [out_samples, gamma] = awgnChannel(in_samples,variance,fs,timeDelay,phaseShift,freqShift,max_doppler)
%awgnChannel:
%
%Input: 
%  in_samples: vector of complex baseband samples
%  variance: desired channel noise variance
%  fs: sampling rate, in Hz 
%  timeDelay: time delay of signal, in seconds
%  phaseShift: phase shift, in radians
%  freqShift: frequency shift, in Hz
%  max_doppler: max doppler for flat Rayleigh channel, in Hz (if negative,
%    no Rayleigh fading and just standard AWGN channel)
%Output:
%  out_samples: vector of complex baseband samples
%
%out_samples are computed by first applying the time delay by appending 
%zeros to the front of the sample, then applying the phase shift in 
%complex baseband, and finally applying the frequency shift in complex 
%baseband.  These samples are then added to zero-mean, complex additive
%Gaussian noise with the specified noise variance. 
%
%Note that all computations occur at complex baseband
%

%Standardize to row vector
if(size(in_samples,2) == 1)
    in_samples = in_samples'; %Change to row vector 
    isColVector = 1;
else
    isColVector = 0; 
end

%Set up parameters using input
numSamples = length(in_samples);
delayedSamples = round(fs*timeDelay);
numTimeShiftedSamples = numSamples + delayedSamples;
sigma = sqrt(variance);
t = 0:(1/fs):((numTimeShiftedSamples-1)/fs); %Is this the correct formulation for t? 

%Perform time, phase, and frequency shifting
time_shifted_samples = [zeros(1,delayedSamples) in_samples]; %Perform time shift 
phase_shifted_samples = time_shifted_samples.*exp(1i.*phaseShift); %Perform phase shift 
freq_shifted_samples = phase_shifted_samples.*exp(1i.*2.*pi.*freqShift.*t); %Perform frequency shift 

%Perform flat Rayleigh fading
gamma = zeros(size(t));
if max_doppler <= 0
    faded_samples = freq_shifted_samples;
else
    N = 100; 
    theta = 2.*pi.*rand(1,N);
    phi = 2.*pi.*rand(1,N);
    f = max_doppler.*cos(phi);
    t = t + rand(1).*10; %Add random time to t so Rayleigh fading channel is not calculated near 0

    for a = 1:length(t)
        gamma(a) = sum(exp(1i.*(2.*pi.*f.*t(a)+theta)))/sqrt(N);   
        
    end
    faded_samples = freq_shifted_samples.*gamma;
end

%Add AWGN
noise = sigma.*randn(1,numTimeShiftedSamples)+1i.*sigma.*randn(1,numTimeShiftedSamples); %Generate white Gaussian noise
out_samples = faded_samples + noise;


if(isColVector)
    out_samples = out_samples'; %Change back to column vector 
end

end




