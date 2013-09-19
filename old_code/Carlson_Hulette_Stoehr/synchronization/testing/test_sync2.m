close all;
fs = 1E6; % sampling frequency in Hz
symbol_samps = 4;
T = symbol_samps/fs; % symbol time
sync_pattern = [ 0 1 0 0 1 1 0 0 0 1 ...
                 1 1 0 0 0 0 1 1 1 1 ... 
                 0 0 0 0 0 1 1 1 1 0 ... 
                 0 0 0 1 1 1 0 0 0 1 ...
                 1 0 0 1 ];
sync_size = size(sync_pattern, 2)*symbol_samps;
bits_per_packet = 1024;
PHASE_WINDOW = 64;
num_packets = 10;
rc_rolloff = 0.5;
M = 2;
packet_size = bits_per_packet*symbol_samps/M;
MODULATION = 'QPSK';
PULSE_SHAPE = generate_pulse_shaping_filt(fs, T, rc_rolloff);

packets = (randn(1, bits_per_packet*num_packets) > 0);

bits = add_sync_bits(packets, sync_pattern, bits_per_packet);

tx = modulate(bits, MODULATION, symbol_samps);

% TX Pulse shape
tx = pulse_shaping(tx, fs, T, rc_rolloff);

% Channel model
%NOTE: The correlation is unaffected by phase offset
rx = awgnChannel(tx,0.05,fs,20/fs,pi/3,123456);
% rx = tx;

% RX Pulse shape

figure;
plot(rx, 'o');

freq_estimate = measure_freq_brute(rx, PULSE_SHAPE, 0.1, 0, 0.5);
% rx = correct_freq_offset(rx, freq_estimate);

freq_estimate = measure_freq_brute(rx, PULSE_SHAPE, 0.001, freq_estimate, 0.05);
% rx = correct_freq_offset(rx, freq_estimate);

freq_estimate = measure_freq_brute(rx, PULSE_SHAPE, 0.00001, freq_estimate, 0.0005);
% rx = correct_freq_offset(rx, freq_estimate);

% freq_estimate = measure_freq_brute(rx, PULSE_SHAPE, 0.0000001, freq_estimate, 0.000005);
rx = correct_freq_offset(rx, freq_estimate);


figure;
plot(rx, 'o');

% Pull out dem symbols
sync_symbols = modulate(sync_pattern, MODULATION, symbol_samps);
% symbol = pulse_shaping(symbol, fs, T, rc_rolloff, 'normal');
sync_symbols = apply_filt(sync_symbols, PULSE_SHAPE);
% sync_symbols = pulse_shaping(sync_symbols, fs, T, rc_rolloff, 'sqrt');

sync_size = size(sync_symbols, 2);


[packet, index] = sync_packet(rx, sync_symbols, packet_size, 1, sync_size+packet_size);
all_packets = packet.'; % TODO: Pre-allocate this (estimate number of packets based on message size, then remove any extras?)
while (index+sync_size+packet_size) <= length(rx)
    [packet, index] = sync_packet(rx, sync_symbols, packet_size, index-sync_size, index+2*sync_size);
    all_packets = [all_packets packet.'];
end

%% Do some work on each packet
num_packets = size(all_packets, 2);
% all_symbols = zeros(...  % TODO: Pre-allocate this
all_symbols = [];
for i=1:num_packets;
    shaped_packet = apply_filt(all_packets(:,i).', PULSE_SHAPE);
    phase_synced_packet = window_phase_sync(shaped_packet, PHASE_WINDOW, MODULATION, symbol_samps);
    all_symbols = [all_symbols phase_synced_packet.'];
end
all_symbols = all_symbols(:).';
figure;
plot(all_symbols, 'o');
out_bits = demodulate(all_symbols, MODULATION, symbol_samps);

% packets = extract_sync_symbols(rx, symbol, sync_size, symbol_samps, symbols_per_packet);