function [ OutPutBits ] = MyReceiver( input )
% MyReceiver takes in a vector N+K length complex samples with unit average
% power.  The output will be a vector of real valued bits (zeros and ones)
% labeled OutPutBits.  Value of N will be the same length as transmitter.
% The value of K will depend on the channel and its length is unknown a
% priori.
tic;

%% Load the config file to adjust parameters %%
configuration;

%% Coarse Frequency Estimation %%
freq_estimate = measure_freq_fft(input, COARSE_FFT_SIZE);
input = correct_freq_offset(input, freq_estimate);

fprintf('Coarse Frequency Estimator corrected a %f Hz offset\n', freq_estimate*F_S)

%% Use Sync Symbols to Identify Packets (Time and Phase Synch) %%
% Find the "ideal" sync
sync_symbols = modulate(SYNC_PATTERN, MODULATION, SAMPLES_PER_SYMBOL);
sync_symbols = apply_filt(sync_symbols, PULSE_SHAPE);
sync_size = length(sync_symbols);

% Find each packet and load into all_packets

% Pre-allocate the packet matrix (estimate number of packets based on message size)
num_packets_guess = ceil(length(input)/(sync_size+PACKET_SIZE_SAMPLES)) + 1;
all_packets = zeros(PACKET_SIZE_SAMPLES, num_packets_guess);

packet_count = 1;
[packet, index, rxd_sync] = sync_packet(input, sync_symbols, PACKET_SIZE_SAMPLES, 1, sync_size+PACKET_SIZE_SAMPLES);
rxd_sync_syms = rxd_sync';
all_packets(:, packet_count) = packet;
while (index+sync_size+PACKET_SIZE_SAMPLES) <= length(input)
    packet_count = packet_count + 1;
    [packet, index, rxd_sync] = sync_packet(input, sync_symbols, PACKET_SIZE_SAMPLES, index-sync_size, index+2*sync_size);
    rxd_sync_syms = horzcat(rxd_sync_syms, rxd_sync');
    all_packets(:, packet_count) = packet;
end

% Cut off anything extra that we pre-allocated
all_packets = all_packets(:, 1:packet_count);

%% Equalize and Fine Frequency Sync each packet %%
% Pre-allocate all_symbols
all_symbols = zeros(PACKET_SIZE_SAMPLES, packet_count);

all_symbols = [];
for i=1:packet_count;
    %% Equalization %%
    equalized_packet = equalizer(all_packets(:,i).', rxd_sync_syms(:,i), sync_symbols, sync_size, MODULATION);

    %% Fine Frequency Sync %%
    all_symbols(:,i) = window_phase_sync(equalized_packet, PHASE_WINDOW, MODULATION, SAMPLES_PER_SYMBOL, PULSE_SHAPE);

end

all_symbols = all_symbols(:).';

%% Demodulation %% 
[bits,softbits] = demodulate(all_symbols, MODULATION, SAMPLES_PER_SYMBOL, PULSE_SHAPE);


%% Viterbi Decoding %%
% Perform Viterbi decoding of aconvolutional code with defined rate and
% constraint length

% Hard Decision %
%decoded_bits = viterbi_decode(bits, 1, GENERATING_POLYS, CONSTRAINT_LENGTH); 

% Soft Decision %
softbits = interleave(softbits, 64); %Assumes coded packet size of 4096 bits
decoded_bits = soft_viterbi_decode(softbits, 1, GENERATING_POLYS, CONSTRAINT_LENGTH);

%% Depacketize %%
if PACKETIZE
    packets = reshape(decoded_bits, PACKET_SIZE_BITS, length(decoded_bits)/PACKET_SIZE_BITS);

    OutPutBits = unpacketizeBits(packets, HEADER_SIZE_BITS);
else
    OutPutBits = decoded_bits;
end

toc;
end