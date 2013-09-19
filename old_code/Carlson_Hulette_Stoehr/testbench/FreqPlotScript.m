fs = 1E7;
numbits = 2048*50;
% ebno = [0 1 2 3 4];
ebno = [0 1];
bitspersymbol = 2;
coderate = 1/2; 
timeshift = 0;
% timeshift = 0:1000/fs:10000/fs;
phaseshift = 0;
% phaseshift = -pi:pi/10:pi;
% freqshift = [-1.3E6 -1.2E6 -1.1E6 -1E6 -8E5 -6E5 -4E5 -2E5 0 ...
%               2E5 4E5 6E5 8E5 1E6 1.1E6 1.2E6 1.3E6];

freqshift = [-1000:200:1000];
figureson = 0;

ber = zeros(length(ebno), length(freqshift));

for i=1:length(freqshift)
    fprintf('Frequency = %f Hz\n', freqshift(i));
    ber(:,i) = TopLevelFcn( fs, numbits, ebno, bitspersymbol, coderate, timeshift, phaseshift, freqshift(i), figureson);
end

semilogy(freqshift, ber, 'b-')

% save('freq_results.mat')
save('freq_results_narrow.mat')
% legend('0 dB', '1 dB', '2 dB', '3 dB', '4 dB')
legend('0 dB', '1 dB', '2 dB', '3 dB')