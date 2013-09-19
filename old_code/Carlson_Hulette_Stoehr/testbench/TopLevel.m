%% Adjustable Parameters
fs = 1E7;
NUM_BITS = 6000;
EB_N0 = 20;         % Desired Ratio of Bit Energy to Noise Power in dB
TIME_SHIFT = 0;     % seconds
PHASE_SHIFT = 0; % radians
FREQ_SHIFT = 5E3;  % Hz
BITS_PER_SYMBOL = 2; %2 for QPSK, 4 for 16QAM
CODE_RATE = 1/2; 
SAMPLES_PER_SYMBOL = 4;  % given, samp/symbol >= 4
MAX_DOPPLER = 0;

%% Other Parameters
% Convert Es_N0 to 
EsNo = CODE_RATE.*BITS_PER_SYMBOL.*10.^(0.1.*EB_N0);
noise_variance = 1./(2.*EsNo); % Convert Es_No to variance

close all

%% Run the Transmitter
input_bits = randn(1, NUM_BITS)<0;
input_bits = input_bits(:)';
tx = MyTransmitter(input_bits);

figure;
plot(tx, 'o')
title('Transmitted Sample Constellation')

figure;
plot_spectrum(tx, fs);
title('Transmitted Spectrum')


%% Apply the Channel Model
rx = awgnChannel(tx, noise_variance, fs, TIME_SHIFT, PHASE_SHIFT, FREQ_SHIFT, MAX_DOPPLER);

figure;
plot(rx, 'o');
title('Received Sample Constellation')

figure;
plot_spectrum(rx, fs);
title('Received Spectrum')


%% Receiver Section %%
output_bits = MyReceiver(rx);




%%%%%%%%%%%%%%%%%%%%%




%% Comparing INput bits to Output bits by REceiver %%
% I.E. -> If we run this without the channel (or any change to the transmitted signal), our input and output should be the same
% THis will ensure MyTransmitter and MyReceiver are working properly.
if length(input_bits) ~= length(output_bits)
   fprintf('input: %d, output: %d\n', length(input_bits), length(output_bits))
end
num_errors = sum(abs(input_bits-output_bits));
ber = num_errors*100.0/NUM_BITS;
fprintf('BER = %f%% (%d/%d)\n', ber, num_errors, NUM_BITS);
%%%