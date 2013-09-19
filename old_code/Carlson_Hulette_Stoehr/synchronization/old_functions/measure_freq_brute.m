function [ norm_freq ] = measure_freq_brute( samps, filt, coarseness, curr_estimate, range )
% MEASURE_FREQ_BRUTE Measure the frequency offset of the input sequence
%                    using a "brute force" approach
%
%   Author: Brian Hulette
%   This function tries to apply various frequency offsets to the input
%   sequence, "samps", then applies the pulse shaping filter, "filt", and
%   measures the signal power.  The frequency offset that yields the
%   highest output power is the estimate.
%   The frequencies that get tried are specified by "coarseness",
%   "curr_estimate", and "range".  Note that all values are specified as
%   normalized frequency.
%       coarseness -    The spacing between frequency offsets that will be
%                       tried
%       curr_estimate - The current best guess for frequency offset
%       range -         The range of frequency offsets to try
%   The searched freqncies range from curr_estimate - range to
%   curr_estimate + range with a spacing of coarseness

min_f = curr_estimate - range;
max_f = curr_estimate + range;
if min_f < -0.5
    min_f = -0.5;
end
if max_f > 0.5
    max_f = 0.5;
end

freqs = min_f:coarseness:max_f;
measurements = zeros(size(freqs));

parfor i=1:length(freqs)
    offset_samps = correct_freq_offset(samps, freqs(i));
    filt_samps = apply_filt(offset_samps, filt);
    measurements(i) = sum(abs(filt_samps));
end

[~, max_idx] = max(measurements);
norm_freq = freqs(max_idx);

end