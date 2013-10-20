fs = 1E7;
numbits = 2048*50;
input_bits = randn(1, numbits)<0;
input_bits = input_bits(:)';
ebno = 1:5:30;
% ebno = 20;
bitspersymbol = 2;
coderate = 1/2; 
timeshift = 0;
% timeshift = 0:1000/fs:10000/fs;
phaseshift = 0;
% phaseshift = -pi:pi/10:pi;
freqshift = 0;
% freqshift = -2000:250:2000;
figureson = 0;
maxdoppler = 20; %For no Rayleigh fading, enter 0 or a negative number
tic
ber = TopLevelFcn( fs, numbits, input_bits, ebno, bitspersymbol, coderate, timeshift, phaseshift, freqshift, figureson, maxdoppler);
toc
%FS = 1E7;
%NUM_BITS = 5000;
%ES_N0 = 5;         % Desired Ratio of Symbol Energy to Noise Power in dB
%TIME_SHIFT = 5/FS;     % seconds
%PHASE_SHIFT = pi/3; % radians
%FREQ_SHIFT = 1200;  % Hz

figure;
semilogy(ebno,ber,'-bo')
axis([0 20 10^(-8) 10^0])
xlabel('Eb/No (dB)')
ylabel('BER')
title('Probability of Bit Error For Tranceiver with Rayleigh Fading')

