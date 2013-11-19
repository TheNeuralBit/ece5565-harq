function [ success, output_bits ] = receive( rx_samples, harqtype, txattempt )
%harq_toplevel:
%  Reception of the rx_samples in HARQ scenario
%
%  function [ success, output_bits ] = receive( rx_samples, harqtype, txattempt )
%
%Input: 
%  rx_samples: 
%  harqtype: 0=ARQ, 1=TypeI HARQ, 2=TypeII HARQ
%  txattempt: Denotes the attempt number for the transmission of this set
%    of bits. Each HARQ type and FEC scheme used may use this (along with persistent info)
%    to determine exactly how to process the received bits
%Output:
%  success: indicates of packet passed CRC and does not need retransmission
%  output_bits: decoded output bits
%

    configuration;
    persistent savebits
    
    
    %% Demodulate symbols %%
    [output_bits, softbits] = demodulate(rx_samples, MODULATION, SAMPLES_PER_SYMBOL, PULSE_SHAPE);
    
    
    %% Decode bits %%
    
    %deinterleave -- add this for Rayleigh
    
    %ARQ
    if harqtype == 0
        decoded_bits = output_bits;
    
    %HARQ with Convolutional Coding
    elseif harqtype == 1 && strcmp(CODING,'CONV')
        decoded_bits = soft_viterbi_decode(softbits, 1, GENERATING_POLYS, CONSTRAINT_LENGTH);
    elseif harqtype == 2 && strcmp(CODING,'CONV')
        numpolys = length(GENERATING_POLYS);
        
        if txattempt == 1 %First transmission
            %Populate savebits as a row vector
            if isrow(softbits)
                savebits = softbits;
            else
                savebits = softbits';
            end
            %Decode bits
            decoded_bits = soft_viterbi_decode(savebits, 1, GENERATING_POLYS(1), CONSTRAINT_LENGTH);

        else %Transmission of a subsequent poly
            %Populate savebits as a row vector
            if isrow(softbits)
                savebits = [savebits; softbits];
            else
                savebits = [savebits; softbits'];
            end            

            genpolys = [];
            for a = 1:txattempt
                polyidx = mod(a,numpolys);
                if polyidx == 0
                    polyidx = numpolys;
                end
                genpolys = [genpolys GENERATING_POLYS(polyidx)];
            end
            %Decode bits
            decoded_bits = soft_viterbi_decode(savebits(:), 1, genpolys, CONSTRAINT_LENGTH);
            %Since we send input to soft_viterbi_decode as a column vector,
            %the output will come out a column vector. So we need to change it
            %back to a row vector if needed
            if isrow(softbits)
                decoded_bits = decoded_bits';
            end
        end 

        
        
    % HARQ with Reed-Solomon Coding
    elseif harqtype == 1 && strcmp(CODING,'RS')
        decoded_bits = rs_decoder(output_bits);
    elseif harqtype == 2 && strcmp(CODING,'RS')
        if (txattempt == 1)
            savebits = zeros(1, RS_CODEWORD_SIZE * SYMBOL_SIZE);
            start_pos = 1;
            end_pos   = length(output_bits);
        elseif (txattempt == 2)
            start_pos = RS_DATA_SIZE * SYMBOL_SIZE + 1;
            end_pos   = (RS_DATA_SIZE + (REDUNDANT_SYMBOLS / 2) + HARQ2_NUM_SYMBOLS_RETRANSMIT) * SYMBOL_SIZE;
        else
            start_pos = (RS_DATA_SIZE + (REDUNDANT_SYMBOLS / 2) + ((txattempt - 1) * HARQ2_NUM_SYMBOLS_RETRANSMIT)) * SYMBOL_SIZE + 1;
            end_pos   = (RS_DATA_SIZE + (REDUNDANT_SYMBOLS / 2) + (txattempt * HARQ2_NUM_SYMBOLS_RETRANSMIT)) * SYMBOL_SIZE;
        end
        
        savebits(start_pos:end_pos) = output_bits;
        decoded_bits = rs_decoder(savebits);
    end
    
    
  %% Check CRC %%
  cut_off = length(decoded_bits)-32;
  output_bits = decoded_bits(1:cut_off);
  crc = decoded_bits(cut_off+1:end);
  crc = crc(:);
  
  % Send ACK/NACK
  computed_crc = crc32(output_bits);
  if sum(abs(crc - computed_crc))
      success = false;
  else
      success = true;
  end

  

%Receiver for ARQ
  %Incoming symbols
  %Demodulate symbols
%Receiver for HARQI
  %Incoming symbols
  %Demodulate symbols
  %Decode bits
  %Check CRC for errors
  %Send ACK/NACK

%Transmitter for HARQII
  %Incoming symbols
  %Demodulate symbols
  %Decode bits using previously transmitted bits
  %Check CRC for errors
  %Save decoded bits in state variable
  %Send ACK/NACK

%Add deinterleaving for Rayleigh
  
  
%% MyReceiver takes in a vector N+K length complex samples with unit average
%% power.  The output will be a vector of real valued bits (zeros and ones)
%% labeled OutPutBits.  Value of N will be the same length as transmitter.
%% The value of K will depend on the channel and its length is unknown a
%% priori.
%tic;
%
%%% Load the config file to adjust parameters %%
%configuration;
%
%%% Coarse Frequency Estimation %%
%freq_estimate = measure_freq_fft(input, COARSE_FFT_SIZE);
%input = correct_freq_offset(input, freq_estimate);
%
%fprintf('Coarse Frequency Estimator corrected a %f Hz offset\n', freq_estimate*F_S)
%
%%% Use Sync Symbols to Identify Packets (Time and Phase Synch) %%
%% Find the "ideal" sync
%sync_symbols = modulate(SYNC_PATTERN, MODULATION, SAMPLES_PER_SYMBOL);
%sync_symbols = apply_filt(sync_symbols, PULSE_SHAPE);
%sync_size = length(sync_symbols);
%
%% Find each packet and load into all_packets
%
%% Pre-allocate the packet matrix (estimate number of packets based on message size)
%num_packets_guess = ceil(length(input)/(sync_size+PACKET_SIZE_SAMPLES)) + 1;
%all_packets = zeros(PACKET_SIZE_SAMPLES, num_packets_guess);
%
%packet_count = 1;
%[packet, index, rxd_sync] = sync_packet(input, sync_symbols, PACKET_SIZE_SAMPLES, 1, sync_size+PACKET_SIZE_SAMPLES);
%rxd_sync_syms = rxd_sync';
%all_packets(:, packet_count) = packet;
%while (index+sync_size+PACKET_SIZE_SAMPLES) <= length(input)
%    packet_count = packet_count + 1;
%    [packet, index, rxd_sync] = sync_packet(input, sync_symbols, PACKET_SIZE_SAMPLES, index-sync_size, index+2*sync_size);
%    rxd_sync_syms = horzcat(rxd_sync_syms, rxd_sync');
%    all_packets(:, packet_count) = packet;
%end
%
%% Cut off anything extra that we pre-allocated
%all_packets = all_packets(:, 1:packet_count);
%
%%% Equalize and Fine Frequency Sync each packet %%
%% Pre-allocate all_symbols
%all_symbols = zeros(PACKET_SIZE_SAMPLES, packet_count);
%
%all_symbols = [];
%for i=1:packet_count;
%    %% Equalization %%
%    equalized_packet = equalizer(all_packets(:,i).', rxd_sync_syms(:,i), sync_symbols, sync_size, MODULATION);
%
%    %% Fine Frequency Sync %%
%    all_symbols(:,i) = window_phase_sync(equalized_packet, PHASE_WINDOW, MODULATION, SAMPLES_PER_SYMBOL, PULSE_SHAPE);
%
%end
%
%all_symbols = all_symbols(:).';
%
%%% Demodulation %% 
%[bits,softbits] = demodulate(all_symbols, MODULATION, SAMPLES_PER_SYMBOL, PULSE_SHAPE);
%
%
%%% Viterbi Decoding %%
%% Perform Viterbi decoding of aconvolutional code with defined rate and
%% constraint length
%
%% Hard Decision %
%%decoded_bits = viterbi_decode(bits, 1, GENERATING_POLYS, CONSTRAINT_LENGTH); 
%
%% Soft Decision %
%softbits = interleave(softbits, 64); %Assumes coded packet size of 4096 bits
%decoded_bits = soft_viterbi_decode(softbits, 1, GENERATING_POLYS, CONSTRAINT_LENGTH);
%
%%% Depacketize %%
%if PACKETIZE
%    packets = reshape(decoded_bits, PACKET_SIZE_BITS, length(decoded_bits)/PACKET_SIZE_BITS);
%
%    OutPutBits = unpacketizeBits(packets, HEADER_SIZE_BITS);
%else
%    OutPutBits = decoded_bits;
%end
%
%toc;
%end
