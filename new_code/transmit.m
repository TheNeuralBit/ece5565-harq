function [ tx_samples, num_bits_txed ] = transmit( input_bits, harqtype, txattempt )
%harq_toplevel:
%  Transmission of the input bits in HARQ scenario
%
%  function [ tx_samples, num_bits_txed ] = transmit( input_bits, harqtype, txattempt )
%
%Input: 
%  input_bits: 
%  harqtype: 0=ARQ, 1=TypeI HARQ, 2=TypeII HARQ
%  txattempt: Denotes the attempt number for the transmission of this set
%    of bits. Each HARQ type and FEC scheme used may use this number to 
%    determine exactly what to transmit (along with persistent info)
%
%Output:
%  tx_samples: samples to be passed into channel 
%  num_bits_txed: total number of bits transmitted (to be used for
%    throughput measurements)
%
    configuration;
    input_bits = input_bits(:);
    persistent savebits

    %% Add CRC %%
    
    %crc32_input_bits = crc32(input_bits)'
    bitswithcrc = [input_bits; crc32(input_bits);];
    
    %% Encode bits %%
    
    %ARQ
    if harqtype == 0
        encoded_bits = bitswithcrc;
    
    %HARQ with Convolutional Coding
    elseif (harqtype == 1) && strcmp(CODING,'CONV')
        bitswithcrc = [bitswithcrc; zeros(CONSTRAINT_LENGTH,1)]; %Zero-tail bits
        encoded_bits = conv_encode(bitswithcrc, 1, GENERATING_POLYS, CONSTRAINT_LENGTH);
        %Interleave - Must be modified depending on number of input bits
        tmp = interleave(encoded_bits(12:2036), 45); %encoded_bits=2036
        encoded_bits = [encoded_bits(1:11); tmp];
        
    elseif harqtype == 2 && strcmp(CODING,'CONV')
        bitswithcrc = [bitswithcrc; zeros(CONSTRAINT_LENGTH,1)]; %Zero-tail bits
        numpolys = length(GENERATING_POLYS);
        if mod(txattempt,numpolys) == 1 %First transmission (or another transmission of first poly)
            savebits = conv_encode(bitswithcrc, 1, GENERATING_POLYS, CONSTRAINT_LENGTH);
            encoded_bits = savebits(1:numpolys:end);
        elseif mod(txattempt,numpolys) == 0 %Transmission of last poly
            firstbit = numpolys;
            encoded_bits = savebits(firstbit:numpolys:end);
        else %Transmission of some middle poly
            encoded_bits = savebits(mod(txattempt,numpolys):numpolys:end);
        end
        %Interleave - Must be modified depending on number of input bits
        encoded_bits = interleave([encoded_bits; zeros(6,1)], 32); %encoded_bits=1018
        
    %HARQ with Reed-Solomon Coding
    elseif harqtype == 1 && strcmp(CODING,'RS')
        encoded_bits = rs_encoder(bitswithcrc);
    elseif harqtype == 2 && strcmp(CODING,'RS')
        transmissionCount = (mod(txattempt, PARITY_TRANMISSIONS));
        if (transmissionCount == 0)
            transmissionCount = PARITY_TRANMISSIONS;
        end
        
        if (transmissionCount == 1) 
            start_pos = 1;
            end_pos   = RS_DATA_SIZE * SYMBOL_SIZE;
            savebits = rs_encoder(bitswithcrc);
        elseif (transmissionCount == 2)
            start_pos = RS_DATA_SIZE * SYMBOL_SIZE + 1;
            end_pos   = (RS_DATA_SIZE + (REDUNDANT_SYMBOLS / 2) + HARQ2_NUM_SYMBOLS_RETRANSMIT) * SYMBOL_SIZE;
        else
            start_pos = (RS_DATA_SIZE + (REDUNDANT_SYMBOLS / 2) + ((transmissionCount - 2) * HARQ2_NUM_SYMBOLS_RETRANSMIT)) * SYMBOL_SIZE + 1;
            end_pos   = (RS_DATA_SIZE + (REDUNDANT_SYMBOLS / 2) + ((transmissionCount - 1) * HARQ2_NUM_SYMBOLS_RETRANSMIT)) * SYMBOL_SIZE;
        end
        encoded_bits = savebits(start_pos:end_pos);
    end

    %interleave -- add this for Rayleigh 

    %Set number of bits that are transmitted
    num_bits_txed = length( encoded_bits );
    
    %% Modulate bits %%
    tx_samples = modulate(encoded_bits, MODULATION, SAMPLES_PER_SYMBOL);
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
