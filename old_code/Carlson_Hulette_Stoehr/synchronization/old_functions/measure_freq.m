function [ norm_freq ] = measure_freq( samps, technique )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if strcmp(technique, 'QPSK')
    norm_freq = measure_freq_phase_diff(samps, 4);
end

end