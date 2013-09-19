function [ output_samps ] = add_sync_symbols( input_samps, sync_symbol, packet_size )
% Generate Zadoff-Chu with N_zc = num_samples and give q, u
% q can be any integer (usually 0)
% the gcd of num_samples and u should be 1 (easiest to just use 1)

% Add some zeroes so we have an even number of packets
size_offset = packet_size - mod(length(input_samps), packet_size);
if size_offset < packet_size
    input_samps = padarray(input_samps, [0 size_offset], 'post');
else
    size_offset = 0;
end

% reshape into an array of packet samples
output_samps = reshape(input_samps, packet_size, []);

% insert some sync symbols
sync_symbs = repmat(sync_symbol', 1, size(output_samps, 2));
output_samps = [sync_symbs; output_samps];
output_samps = output_samps(:)';

% cut off the zeros that we added
output_samps = output_samps(1:end-size_offset);
end