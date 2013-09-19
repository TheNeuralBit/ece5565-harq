function [ output_samps ] = window_phase_sync( input_samps, window_size, mod_type, samps_per_symbol, pulse_shape )
% WINDOW_PHASE_SYNC Perform phase synchronization over a running window to
%                   track phase changes (or remaining frequency offset)
%
%   Author: Brian Hulette
%   Performs phase synchronization over a running window on an complex
%   sample sequence, "input_samps".  The phase synchronization is performed
%   over a window of size "window_size".
%   To determine the phase offset of each window, the samples are
%   demodulated and then remodulated.  The average phase offset is measured
%   between the original samples and the remodulated samples.  The phase
%   offset is then corrected for all remaining samples in the sequence.
output_samps = input_samps;
num_windows = length(input_samps)/window_size;

for i=0:num_windows-1
   start = window_size*i + 1;
   stop = start + window_size - 1;
   
   if stop > length(output_samps)
      stop = length(output_samps); 
   end
   
   window_samps = output_samps(start:stop);
   remod = modulate(demodulate(window_samps, mod_type, samps_per_symbol, pulse_shape), mod_type, samps_per_symbol);
   remod = apply_filt(remod, pulse_shape);
   phase_offset = avg_phase_offset(window_samps, remod);
   
   output_samps(start:end) = output_samps(start:end)*exp(-1j*phase_offset);
end

end