function [ out_samps ] = correct_freq_offset( in_samps, norm_freq )
% CORRECT_FREQ_OFFSET   Corrects the given frequency offset in a complex
%                       sequence
%   
%   Author: Brian Hulette
%   Corrects the frequency offset "norm_freq" (measured in normalized
%   frequency) in the complex symbol sequence "in_samps".

n = 0:(length(in_samps)-1);
out_samps = in_samps.*exp(-1j*2*pi*norm_freq*n);

end