N  = 1000; % number of symbols
random_data = 2*(rand(1,N)>0.5)-1 + 1j*(2*(rand(1,N)>0.5)-1); % generating random binary sequence

fs = 1E6; % sampling frequency in Hz
T = 1E-5; % symbol time
symbol_samps = fs*T;

symbol_filter = ones(1, symbol_samps);

% upsampling the transmit sequence 
random_data_upsamp = upsample(random_data, symbol_samps);

% Create the actual transmit sequence
tx_samples = conv(random_data_upsamp, symbol_filter);

%%% DO THE PULSE SHAPING %%%
pulse_shaping_filt = generate_pulse_shaping_filt(fs, T, 0.2);
tx_pulse_shaped = conv(tx_samples, pulse_shaping_filt);

% Cutoff the extra piece from the end of the filter
tx_pulse_shaped = tx_pulse_shaped(1:N*symbol_samps);

% Reshape into an eye diagram
tx_reshape = reshape(tx_pulse_shaped,symbol_samps*2, []).';

close all
figure;
plot(linspace(0,2,symbol_samps*2),real(tx_reshape).','b');   
title('Eye Diagram');
xlabel('Time (symbols)')
ylabel('Amplitude') 
axis([0 2 -1.5 1.5])
grid on

figure;
plot(linspace(-fs/2,fs/2,2^13),20*log10(abs(fftshift(fft(tx_samples, 2^13)))));
title('Original Spectrum');
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)') 
axis([-5E5 5E5 -20 60]);

figure;
plot(linspace(-fs/2,fs/2,2^13),20*log10(abs(fftshift(fft(tx_pulse_shaped, 2^13)))));
title('Pulse Shaped Spectrum');
xlabel('Frequency (Hz)')
ylabel('Magnitude (dB)') 
axis([-5E5 5E5 -20 60]);
