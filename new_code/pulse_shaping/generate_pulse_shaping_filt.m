function [ filt ] = generate_pulse_shaping_filt( fs, T, rolloff )
% GENERATE_PULSE_SHAPING_FILT Generates a filter to use for pulse shaping
%
%   Author: Brian Hulete
%   Uses the built in firrcos to design an FIR filter of size
%   10*T*fs with a rolloff (alpha) of "rolloff"

filt_size = 10*T*fs;
filt = firrcos(filt_size,1/2/T,rolloff,fs,'rolloff','sqrt');

% filt = [0 0 0 0 1 1 1 1];

% Normalize the filter to unit power
filt = filt/sqrt(sum(filt.*conj(filt)));
% filt = fs*T*filt;

end

