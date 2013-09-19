%% Adjustable Parameters
NUM_BITS = 10000;
EBNO = 0:10;         % Desired Ratio of Bit Energy to Noise Power in dB
BITS_PER_SYMBOL = 4; %2 for QPSK, 4 for 16QAM
CODE_RATE = 1/2; 
GENERATING_POLYS = [15 17]; %Rate 1/2
CONSTRAINT_LENGTH = 4;

SAMPLES_PER_SYMBOL = 1;  % given, samp/symbol >= 4
MODULATION = '16QAM';%'16QAM';


%% Other Parameters
EsNo = CODE_RATE.*BITS_PER_SYMBOL.*10.^(0.1.*EBNO); %Power ratio (not dB)
noise_variance = 1./(2.*EsNo); % Convert Es_No to variance
TIME_SHIFT = 0;
PHASE_SHIFT = 0;
FREQ_SHIFT = 0;
fs = 1E7;


%%Run Code
input_bits = randn(1, NUM_BITS)<0;
input_bits = input_bits(:)';

%Encode
encoded_bits = conv_encode(input_bits, 1, GENERATING_POLYS, CONSTRAINT_LENGTH);

%Modulate
%symbols = QPSKmod(encoded_bits);
symbols = modulate(encoded_bits, MODULATION, SAMPLES_PER_SYMBOL);

ber = zeros(1,length(EBNO));
ber_hard = zeros(1,length(EBNO));
for a = 1:length(noise_variance)
    %Channel
    rx = awgnChannel(symbols, noise_variance(a), fs, TIME_SHIFT, PHASE_SHIFT, FREQ_SHIFT);

    %Demodulate
    %[hardbits,softbits] = QPSK_demod(rx);
    [hardbits,softbits] = QAM_16_demod(rx);
    softbits = -softbits;
    %bits = demodulate(rx, MODULATION, SAMPLES_PER_SYMBOL);

    %Decode
    output_hard_bits = viterbi_decode(hardbits, 1, GENERATING_POLYS, CONSTRAINT_LENGTH); 
    output_bits = soft_viterbi_decode(softbits, 1, GENERATING_POLYS, CONSTRAINT_LENGTH); 

    num_errors = sum(abs(input_bits-output_bits));
    ber(a) = num_errors/NUM_BITS;
    fprintf('At %d dB Eb/No soft,  BER = %E (%d/%d)\n', EBNO(a), ber(a), num_errors, NUM_BITS);
    
    num_errors = sum(abs(input_bits-output_hard_bits));
    ber_hard(a) = num_errors/NUM_BITS;
    fprintf('At %d dB Eb/No hard,  BER = %E (%d/%d)\n', EBNO(a), ber_hard(a), num_errors, NUM_BITS);
end


%Plot on log scale
figure;
semilogy(EBNO,ber,'-bo',EBNO,ber_hard,'-rx')
axis([0 12 10^(-8) 10^0])
legend('Soft','Hard')
xlabel('Eb/No (dB)')
ylabel('BER')
title('Probability of bit error for transceiver system')














