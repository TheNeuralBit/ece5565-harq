%% Configuruable Parameters
MODULATION = 'BPSK';        % 16QAM or QPSK
CODING = 'CONV';            % CONV or RS
PACKET_SIZE_BITS = 2048;    % Packet size including header bits
%HEADER_SIZE_BITS = 16;
RC_ROLLOFF = 0.25;          % Adjusts alpha of the RRC pulse shape
PHASE_WINDOW = 256;
MAX_DOPPLER = 0;

MAX_ATTEMPTS = 4;

if strcmp(MODULATION, 'BPSK')
    M = 2;
    BITS_PER_SYMBOL = 1;
elseif strcmp(MODULATION, 'QPSK')
    M = 4;
    BITS_PER_SYMBOL = 2;
elseif strcmp(MODULATION, '8PSK')
    M = 8;
    BITS_PER_SYMBOL = 3;
elseif strcmp(MODULATION, '16QAM')
    M = 16;
    BITS_PER_SYMBOL = 4;
end

if strcmp(CODING, 'CONV')
    GENERATING_POLYS = [13 15 17];
    CONSTRAINT_LENGTH = 4;      % Must be set to the appropriate value based on polys
    CODE_RATE = 1/length(GENERATING_POLYS);
    CODE_RATE_STR = ['1' num2str(length(GENERATING_POLYS))];
elseif strcmp(CODING, 'RS')
    %Add RS parameters here
    SYMBOL_SIZE = 8;
    GALOIS_FIELD_GENERATOR_POLY = 285;
    REDUNDANT_SYMBOLS = 32;
    RS_CODEWORD_SIZE = 2^SYMBOL_SIZE-1;
    RS_DATA_SIZE = RS_CODEWORD_SIZE - REDUNDANT_SYMBOLS;
    CODE_RATE = (2^SYMBOL_SIZE - REDUNDANT_SYMBOLS - 1)/(2^SYMBOL_SIZE-1);
    CODE_RATE_STR = [num2str(2^SYMBOL_SIZE - REDUNDANT_SYMBOLS - 1) num2str(2^SYMBOL_SIZE-1)];
    HARQ2_NUM_SYMBOLS_RETRANSMIT = 4; % Must be an even number. RS codes require 2 symbols to correct for 1 error.
end


%% Derived and Fixed Parameters (Do not modify!)
F_S = 1e7;   % given, sample rate = 10 Msps

%DATA_SIZE_BITS = PACKET_SIZE_BITS - HEADER_SIZE_BITS;
SAMPLES_PER_SYMBOL = 4;  % given, samp/symbol >= 4
T = SAMPLES_PER_SYMBOL/F_S; % symbol time

PULSE_SHAPE = generate_pulse_shaping_filt(F_S, T, RC_ROLLOFF);

%PACKET_SIZE_SAMPLES = PACKET_SIZE_BITS/CODE_RATE*SAMPLES_PER_SYMBOL/M;
PACKET_SIZE_SAMPLES = PACKET_SIZE_BITS/SAMPLES_PER_SYMBOL/M;
