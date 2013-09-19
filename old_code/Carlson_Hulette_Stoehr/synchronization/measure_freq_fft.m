function [ norm_freq ] = measure_freq_fft( samps, fft_size )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if length(samps) < fft_size
    disp('Not enough samples to do coarse frequency synch - Skipping!');
    norm_freq = 0;
    return;
end
reshape_samps = reshape(samps(1:floor(length(samps)/fft_size)*fft_size), fft_size, []);

f = fftshift(mean(abs(fft(reshape_samps.^4, fft_size, 1)), 2)');

[max_val, idx] = max(f);
% [~, idx] = max(abs(fftshift(fft(samps.^4, fft_size))));

if max_val - mean(f) < 6*std(f)
   disp('Coarse Frequency estimate peak is within six standard deviations of the mean - ignoring!');
   norm_freq = 0;
else
    norm_freq = ((idx-1)/(fft_size-1) - 0.5)/4;
end
    
end