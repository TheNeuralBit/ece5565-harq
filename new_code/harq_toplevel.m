function [ throughput, ber ] = harq_toplevel( NUM_PACKETS, DATA_BITS_PER_PACKET, SNR_RANGE )
    configuration;

    % Pre-allocate return arrays
    throughput = zeros( 1, length(SNR_RANGE) );
    ber = zeros( 1, length(SNR_RANGE) );

    %Generate packets with random bits to send
    PACKET_DATA = randn( NUM_PACKETS, DATA_BITS_PER_PACKET ) < 1;

    %Loop over SNR
    for snr_idx = 1:length( SNR_RANGE )
        %snr = SNR_RANGE(snr_idx);
        %variance = TODO
        tx_attempts = zeros(1, NUM_PACKETS);
        num_tx_bits = zeros(1, NUM_PACKETS);
        num_errors = zeros(1, NUM_PACKETS);
        %Loop over total number of packets to transmit
        for packet_idx = 1:NUM_PACKETS
            fprintf('Packet #%d\n', packet_idx)
            %While loop over transmit/receive until no error is detected in packet
            attempt_counter = 0;
            tx_bit_counter = 0;
            error_counter = 0;
            while 1
                %Increment tx_num and tx_symbols
                attempt_counter = attempt_counter + 1;

                %Transmit
                input_bits = PACKET_DATA(packet_idx,:);
                [tx_samples, bit_count] = transmit( input_bits );
                tx_bit_counter = tx_bit_counter + bit_count;
                
                %Channel
                rx_samples = awgnChannel(tx_samples, .05, F_S, 0, 0, 0, 0);
                %rx_samples = tx_samples;
                %figure;
                plot(rx_samples, 'o');
                
                %Receive
                [success, output_bits] = receive( rx_samples );
                if ~success
                    disp 'Oh no! Failed Packet! Retry'
                end
                %"Send feedback on return channel" (assume perfect feedback)
                %If no error detected
                if success || attempt_counter >= MAX_ATTEMPTS
                    if attempt_counter >= MAX_ATTEMPTS
                        disp 'Transmission failed too many times, bailing out!'
                    end
                    % add up any actual errors that were made
                    error_counter = error_counter + sum( abs( input_bits(:)-output_bits(:) ) );
                    % break out of loop
                    break;
                end
            end
            tx_attempts(packet_idx) = attempt_counter;
            num_tx_bits(packet_idx) = tx_bit_counter;
            num_errors(packet_idx) = error_counter;

          %Record packet_size/tx_symbols (throughput efficiency) and tx_num (number
          %of transmissions) for this packet
        end
        % TODO: Do we want to keep tx_attemps, num_tx_bits, num_errors around for more analysis?
        throughput(snr_idx) = (NUM_PACKETS*DATA_BITS_PER_PACKET) / sum( num_tx_bits );
        ber(snr_idx) = sum( num_errors ) / (NUM_PACKETS*DATA_BITS_PER_PACKET);
        %Record total results averaging over all packets
    end
end

%%TopLevel:
%%
%%Input: 
%%  FS: Implied sampling rate, in Hz
%%  NUM_BITS: number of bits to transmit at each Eb/No
%%  EBNO: vector of Eb/No (bit energy to noise power), in dB 
%%  BITS_PER_SYMBOL: number of bits per symbol
%%  CODE_RATE: code rate of k/n (currently only support 1/n)
%%  TIME_SHIFT: time delay of signal, in seconds
%%  PHASE_SHIFT: phase shift, in radians
%%  FREQ_SHIFT: frequency shift, in Hz
%%  FIGURES_ON: boolean value indicating whether to make all plots
%%  MAX_DOPPLER: max doppler for flat Rayleigh channel, in Hz (if negative,
%%    no Rayleigh fading and just standard AWGN channel)
%%  
%%Output:
%%  BER: vector of overall BER for each EbNo
%%
%%  NOTE ON PLOTS: The input variable FIGURES_ON should really only be set 
%%    to TRUE if only one EBNO value is passed in.  Regardless of the value  
%%    of FIGURES_ON, the final BER plot will always be produced. By default, 
%%    the axis will be from 0-12 dB on the x-axis, and 10^(-8) to 10^0 on 
%%    the y-axis
%%
%
%
%
%
%%% Adjustable Parameters
%%FS = 1E7;
%%NUM_BITS = 5000;
%%ES_N0 = 5;         % Desired Ratio of Symbol Energy to Noise Power in dB
%%TIME_SHIFT = 5/FS;     % seconds
%%PHASE_SHIFT = pi/3; % radians
%%FREQ_SHIFT = 1200;  % Hz
%
%%% Other Parameters
%SAMPLES_PER_SYMBOL = 4;  % given, samp/symbol >= 4
%EsNo = CODE_RATE.*BITS_PER_SYMBOL.*10.^(0.1.*EBNO);
%% EsNo = CODE_RATE.*BITS_PER_SYMBOL.*10.^(0.1.*EBNO);
%noise_variance = 1./(2.*EsNo); % Convert Es_No to variance
%
%close all
%
%%% Run the Transmitter
%tx = MyTransmitter(input_bits);
% 
%
%
%%% Vary EbN0
%if length(EBNO) >= 1
%    ber = zeros(1,length(EBNO));
%    for a = 1:length(noise_variance)
%        rx = awgnChannel(tx, noise_variance(a), FS, TIME_SHIFT, PHASE_SHIFT, FREQ_SHIFT, MAX_DOPPLER);
%
%        %Plot transmitted and received signal 
%        if FIGURES_ON 
%            plot_figures(tx, rx, FS)
%        end
%
%        num_errors = run_receiver(rx, input_bits);
%        ber(a) = num_errors*1.0/NUM_BITS;
%        
%        fprintf('At %d dB Eb/No,  BER = %E (%d/%d)\n', EBNO(a), ber(a), num_errors, NUM_BITS);
%        save(sprintf('results%d_ber.mat', a), 'ber')
%    end
%    
%    save('results.mat')
%
%    %Plot on log scale
%    figure;
%    semilogy(EBNO,ber,'-bo')
%    axis([0 12 10^(-8) 10^0])
%    %legend('Simulation results','Theoretical')
%    xlabel('Eb/No (dB)')
%    ylabel('BER')
%    title('Probability of bit error for transceiver system')
%
%%% Vary Time Shift
%elseif length(TIME_SHIFT) > 1
%    ber = zeros(1,length(TIME_SHIFT));
%    for a = 1:length(TIME_SHIFT)
%        rx = awgnChannel(tx, noise_variance, FS, TIME_SHIFT(a), PHASE_SHIFT, FREQ_SHIFT);
%
%        %Plot transmitted and received signal 
%        if FIGURES_ON 
%            plot_figures(tx, rx, FS)
%        end
%
%        num_errors = run_receiver(rx, input_bits);
%        ber(a) = num_errors*1.0/NUM_BITS;
%
%        fprintf('At %s seconds,  BER = %E (%d/%d)\n', TIME_SHIFT(a), ber(a), num_errors, NUM_BITS);
%        save(sprintf('results%d_ber.mat', a), 'ber')
%        close all;
%    end
%    
%    save('results.mat')
%
%    %Plot on log scale
%    figure;
%    semilogy(TIME_SHIFT,ber,'-bo')
%    axis([min(TIME_SHIFT) max(TIME_SHIFT) 10^(-8) 10^0])
%    %legend('Simulation results','Theoretical')
%    xlabel('Time Shift (s)')
%    ylabel('BER')
%    title('Probability of bit error for transceiver system')
%
%%% Vary Phase Shift
%elseif length(PHASE_SHIFT) > 1
%    ber = zeros(1,length(PHASE_SHIFT));
%    for a = 1:length(PHASE_SHIFT)
%        rx = awgnChannel(tx, noise_variance, FS, TIME_SHIFT, PHASE_SHIFT(a), FREQ_SHIFT);
%
%        %Plot transmitted and received signal 
%        if FIGURES_ON 
%            plot_figures(tx, rx, FS)
%        end
%
%        num_errors = run_receiver(rx, input_bits);
%        ber(a) = num_errors*1.0/NUM_BITS;
%
%        fprintf('At %f radians,  BER = %E (%d/%d)\n', PHASE_SHIFT(a), ber(a), num_errors, NUM_BITS);
%        save(sprintf('results%d_ber.mat', a), 'ber')
%        close all;
%    end
%    
%    save('results.mat')
%
%    %Plot on log scale
%    figure;
%    semilogy(PHASE_SHIFT,ber,'-bo')
%    axis([min(PHASE_SHIFT) max(PHASE_SHIFT) 10^(-8) 10^0])
%    %legend('Simulation results','Theoretical')
%    xlabel('Phase Shift (rad)')
%    ylabel('BER')
%    title('Probability of bit error for transceiver system')
%
%%% Vary Frequency Shift
%elseif length(FREQ_SHIFT) > 1
%    ber = zeros(1,length(FREQ_SHIFT));
%    for a = 1:length(FREQ_SHIFT)
%        rx = awgnChannel(tx, noise_variance, FS, TIME_SHIFT, PHASE_SHIFT, FREQ_SHIFT(a));
%
%        %Plot transmitted and received signal 
%        if FIGURES_ON 
%            plot_figures(tx, rx, FS)
%        end
%
%        num_errors = run_receiver(rx, input_bits);
%        ber(a) = num_errors*1.0/NUM_BITS;
%
%        fprintf('At %f Hz,  BER = %E (%d/%d)\n', FREQ_SHIFT(a), ber(a), num_errors, NUM_BITS);
%        save(sprintf('results%d_ber.mat', a), 'ber')
%        close all;
%    end
%    
%    save('results.mat')
%
%    %Plot on log scale
%    figure;
%    semilogy(FREQ_SHIFT,ber,'-bo')
%    axis([min(FREQ_SHIFT) max(FREQ_SHIFT) 10^(-8) 10^0])
%    %legend('Simulation results','Theoretical')
%    xlabel('Frequency Offset (Hz)')
%    ylabel('BER')
%    title('Probability of bit error for transceiver system')
%end
%    
%
%%%%%%%%%%%%%%%%%%%%%%
%
%BER = ber;
%%%%
%
%end
%
%function plot_figures(tx, rx, FS)
%    figure;
%    plot(tx, 'o')
%    title('Transmitted Sample Constellation')
%
%    figure;
%    plot_spectrum(tx, FS);
%    title('Transmitted Spectrum')
%
%    figure;
%    plot(rx, 'o');
%    title('Received Sample Constellation')
%
%    figure;
%    plot_spectrum(rx, FS);
%    title('Received Spectrum')
%end
%
%function num_errors = run_receiver(rx, input_bits)
%    %Receive Signal
%    output_bits = MyReceiver(rx);
%    
%    %Calculate BER - with no channel and no change to transmitted signal,
%    %input and output should be the same yielding a 0 BER
%    if(length(input_bits) ~= length(output_bits))
%        length(input_bits)
%        length(output_bits)
%        num_errors = length(input_bits);
%    else
%        num_errors = sum(abs(input_bits-output_bits));
%    end
%end
