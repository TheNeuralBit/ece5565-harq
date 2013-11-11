function [ tx_samples, num_bits_txed ] = transmit( input_bits )
    configuration;
    input_bits = input_bits(:);
    
    % BS Test Function
    %tx_samples = input_bits;
    %num_bits_txed = length( input_bits );

%Transmitter for ARQ
  %Incoming bits
    %Add CRC
    tx_bits = [input_bits; crc32(input_bits);];
    num_bits_txed = length( tx_bits );

    %Modulate all bits
    tx_samples = modulate(tx_bits, MODULATION, SAMPLES_PER_SYMBOL);
    tx_samples = apply_filt(tx_samples, PULSE_SHAPE);

  %Send all bits

%Transmitter for HARQI
  %Incoming bits
  %Add CRC
  %Encode all bits (incoming and crc)
  %Modulate all bits
  %Send all bits

%Transmitter for HARQII
  %Incoming bits
  %Add CRC
  %Encode all bits (incoming and crc)
  %Modulate some part of bits (TBD)
    %Send data and crc, then parity (?) 
  %Send some part of bits (TBD) 

%Add interleaving for Rayleigh





%% MyTransmitter takes in a vector bits b of real valued bits (zeros and
%% ones) of unknown length and outputs a vector of complex samples labeled
%% as OutPutSamples of length N with unit average power. The data in input
%% will be given in terms of real numbers.
%tic;
%
%%% Load the config file to adjust parameters %%
%configuration;
%
%%% Place bits into packets of specified size %%
%if PACKETIZE
%    packets = packetizeBits(input, HEADER_SIZE_BITS, PACKET_SIZE_BITS); 
%    input = packets(:)';
%end
%
%%% Convolutional Encoding %%
%encoded_bits = conv_encode(input, 1, GENERATING_POLYS, CONSTRAINT_LENGTH);
%
%encoded_bits = interleave(encoded_bits, 64); %Assumes coded packet size of 4096 bits
%
%%% Add pilot/sync bits
%bits_with_sync = add_sync_bits(encoded_bits, SYNC_PATTERN, PACKET_SIZE_BITS/CODE_RATE);
%
%%% Convert the encoded bits to symbols (at complex baseband) %%
%modulated_samples = modulate(bits_with_sync, MODULATION, SAMPLES_PER_SYMBOL);
%
%%% Apply the pulse shaping %%
%OutPutSamples = apply_filt(modulated_samples, PULSE_SHAPE);
%
%toc;
%
%end
%
