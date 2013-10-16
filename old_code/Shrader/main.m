clear all;
close all;
tic;
snrdB_min=0;
snrdB_max=15;
snrdB=snrdB_min:1:snrdB_max;
snr=10.^(snrdB/10);
error_prob=zeros(1,length(snr));

figures_on=1;

theoretical=(3/8)*erfc(sqrt(4*snr/10));

for k=1:length(snr)

close all;

disp(['Starting ' num2str(snrdB(k)) ' dB']);

bits=10000;
bitsPerSymbol = 4;
symbols = round(bits/4);

data=randi([0,1],1,bits);
decimal_data=convertToDec(data);

redundantSymbols = 4;
encodedData = encoder(decimal_data, redundantSymbols);
disp('Encoding complete');

encodedData=convertToBin(encodedData);
[interleavedData,interleaver_padding]=interleaver(encodedData);
interleavedData=convertToDec(interleavedData);
disp('Interleaving complete');

mapped_data=mapping_16QAM(interleavedData);

disp('Mapping complete');

if figures_on
    figure();
    scatter(real(mapped_data),imag(mapped_data)); axis([-4,4,-4,4]);
    title('Scatter Plot of 16-QAM Mapping');
    xlabel('In-Phase'); ylabel('Quadrature');
end

modulated_data=modulator(mapped_data);

disp('Modulation complete');

if figures_on
    figure();
    subplot(2,1,1);
    plot(real(modulated_data(1:200)));
    title('Modulated Data - In-Phase Component - First 200 samples');
    subplot(2,1,2);
    plot(imag(modulated_data(1:200)));
    title('Modulated Data - Quadrature Component - First 200 samples');

    spectrum=10*log10(abs(fftshift(fft(modulated_data))));
    figure();
    plot(real(spectrum));
    
    title('Spectrum Plot of Baseband Signal');

    figure();   
    scatter(real(modulated_data(5:8:length(modulated_data))),imag(modulated_data(5:8:length(modulated_data))));
    title('Scatter Plot of Every 8th sample');
end

sentSignal=modulated_data; %sent signal
n=zeros(1,length(sentSignal)); %noise vector
sigma = sqrt(1/(2*snr(k))); %Noise standard deviation
noise = sigma*randn(1,length(sentSignal)) + j*sigma*randn(1,length(sentSignal)); %Noise signal
receivedSignal=sentSignal + noise; %received vector
channel_shift=randi([0,6],1,1);
shift_value(k)=channel_shift;
receivedSignal=circshift(receivedSignal,[0,channel_shift]);

disp('Channel complete');

if figures_on
    figure();
    scatter(real(receivedSignal(5:8:length(receivedSignal))),imag(receivedSignal(5:8:length(receivedSignal))));
    title('Noise Added - Scatter Plot of Every 8th sample');
end

[demodulated_data, shiftindex]=demodulator(receivedSignal);

disp('Demod complete');


demapped_data=demapping_16QAM(demodulated_data);
disp('Demapping complete');

demapped_data=convertToBin(demapped_data);
deinterleavedData=deinterleaver(demapped_data,interleaver_padding);
deinterleavedData=convertToDec(deinterleavedData);
disp('De-interleaving complete');


decodedData = decoder(deinterleavedData, redundantSymbols);
% Remove padding that was added to complete a codeword
decodedData = decodedData(1:length(decimal_data));

disp('Decoding complete');

binary_data=convertToBin(decodedData);

if figures_on
    figure();
    subplot(2,1,1);
    stem(data(1:50));
    title('Original Data - First 50 bits');
    subplot(2,1,2);
    stem(binary_data(1:50));
    title('Final Data - First 50 bits');
end

numberOfBitErrors = nnz( data - binary_data);

ber = numberOfBitErrors / bits; % bit error rate

disp(['SNR: ' num2str(snrdB(k)) ' dB']);
disp(['Bit error rate (BER): ' num2str(ber)]);
disp(['Theoretical BER: ' num2str(theoretical(k))]);
disp(['Channel shift: ' num2str(channel_shift)]);
disp(['Demod shift: ' num2str(shiftindex-1)]);
disp(' ');
error_prob(k)=ber;
end


figure();
semilogy(snrdB, theoretical);
hold on;
semilogy(snrdB, error_prob, 'o');
axis([snrdB_min snrdB_max 10^-6 10^0])
set(gca, 'XTick', snrdB_min:1:snrdB_max)
legend('Theoretical','Simulated');
grid on;
hold off;
time=toc