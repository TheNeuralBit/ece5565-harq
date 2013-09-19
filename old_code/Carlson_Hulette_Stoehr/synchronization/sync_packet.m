function [ packet_samps, end_index, sync_output ] = sync_packet( input_samps, sync, packet_size, search_start, search_stop)
% SYNC_PACKET   Search for a synchronization sequence, which marks the
%               beginning of a packet.  Use it to perform phase
%               synchronization.
%   
%   Author: Brian Hulette
%   Searches for the synchronization sequence "sync" in "input_samps", a 
%   sequence of complex samples.  The search is limited by the indices 
%   "search_start" and "search_stop".
%   It extracts the next "packet_size" symbols, which represent a data
%   packet.
%   It measures the phases offset of the synchronization sequence, and uses
%   the measurement to correct the phase offset in the returned packet.

sync_size = length(sync);

% Get sync for first packet
[corr, lags] = xcorr(input_samps(search_start:search_stop), sync);
corr = abs(corr);
[~, sync_loc] = max(corr);
sync_loc = lags(sync_loc)+search_start;

% figure;
% plot(lags, corr);

% The sync location cant be earlier than the beginning of input_samps
if sync_loc < 1
    sync_loc = 1;
end
sync_output = input_samps(sync_loc:sync_loc+sync_size-1);

% Cut off 3 samples from either side (to avoid weirdness from pulse
% shaping)
sync = sync(3:end-3);
sync_samps = sync_output(3:end-3);

% Use the training sequence to measure the frequency offset
% norm_freq = avg_freq_offset(sync_samps, sync);
% sync_samps = correct_freq_offset(sync_samps, norm_freq);

% Use the training sequence to compute the phase offset
phase_offset = avg_phase_offset(sync_samps, sync);

% Cut out the actual packet samples

end_index = sync_loc+sync_size+packet_size-1;

% If there are not enough samples to form the packet - append a tail of
% zeros
if end_index > length(input_samps)
    tail = zeros(1,  end_index - length(input_samps));
    end_index = length(input_samps);
    fprintf('*** Appending a tail of length %d', length(tail))
else
    tail = [];
end

packet_samps = [input_samps(sync_loc+sync_size:end_index) tail];

% Correct phase and frequency offset in the packet
% packet_samps = correct_freq_offset(packet_samps*exp(-1j*phase_offset), norm_freq);
packet_samps = packet_samps*exp(-1j*phase_offset);

end