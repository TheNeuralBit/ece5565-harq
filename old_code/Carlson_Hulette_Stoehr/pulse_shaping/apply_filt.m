function [ output_samps ] = apply_filt( input_samps, filt)
% APPLY_FILT Applies a filter to a complex sample sequence
%
%   Author: Brian Hulete
%   Uses the built in conv function to convolve a filter, "filt", with an
%   input sequence, "input_samps".

output_samps = conv(input_samps, filt, 'same');

end

