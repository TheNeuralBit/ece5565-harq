function [ output_samps ] = extract_sync_symbols( input_samps, sync, sync_size, symbol_size, packet_size)
full_packet_size = sync_size + symbol_size*packet_size;


% Get sync for first packet
[corr, lags] = xcorr(input_samps(1:full_packet_size), sync);
corr = abs(corr);
[~, sync] = max(corr);
first_packet = lags(sync)+1;

figure;
plot(lags, corr);

% Cut off everything before that sync
input_samps = input_samps(first_packet:end);

num_iter = floor(size(input_samps, 2)/full_packet_size);
packet_starts = ones(1, num_iter);


for i=1:num_iter-1
    start = i*full_packet_size-sync_size;
    stop = start + 3+ sync_size;
    % TODO: If there wont be much drift, use this window
    % start = i*full_packet_size;
    % stop = start + symbol_size;
    [corr, lags] = xcorr(input_samps(start:stop), sync);
    corr = abs(corr);
    figure;
    plot(lags, corr);
    [~, sync] = max(corr);
    packet_starts(i+1) = lags(sync) + start;
end
packet_starts

% TODO: split into packets and sync symbols

% TODO: Measure phase of sync symbols, compensate for phase, frequency
% offset

output_samps = input_samps;
end