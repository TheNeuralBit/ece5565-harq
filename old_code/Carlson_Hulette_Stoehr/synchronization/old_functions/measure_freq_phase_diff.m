function [ norm_freq ] = measure_freq_phase_diff( samps, M )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
norm_freq = angle(sum((samps(2:end).*conj(samps(1:end-1))).^M))/(2*pi*M);

end