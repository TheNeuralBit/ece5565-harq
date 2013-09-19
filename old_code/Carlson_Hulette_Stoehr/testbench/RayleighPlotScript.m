fs = 1E7;
numbits = 2048*500;
input_bits = randn(1, numbits)<0;
input_bits = input_bits(:)';
% ebno = [0 1 2 3 4];
ebno = 1:5:31;
bitspersymbol = 2;
coderate = 1/2; 
timeshift = 0;
% timeshift = 0:1000/fs:10000/fs;
phaseshift = 0;
freqshift = 0;

maxdoppler = [20, 50, 100, 200, 300]; %For no Rayleigh fading, enter 0 or a negative number
figureson = 0;

ber = zeros(length(ebno), length(maxdoppler));

for i=1:length(maxdoppler)
    fprintf('Max Doppler = %f Hz\n', maxdoppler(i));
    ber(:,i) = TopLevelFcn( fs, numbits, input_bits, ebno, bitspersymbol, coderate, timeshift, phaseshift, freqshift, figureson, maxdoppler(i));
end

semilogy(ebno, ber)

legend('20 Hz', '50 Hz', '100 Hz', '200 Hz', '300 Hz')
% legend('0 dB', '1 dB', '2 dB', '3 dB')