%% Configuruable Parameters
PACKETIZE = 1;              % Whether or not to insert header bits with packet size
                            % If this is not set only message sizes that
                            % are a multiple of PACKET_SIZE_BITS will work
MODULATION = 'QPSK';        % 16QAM or QPSK
PACKET_SIZE_BITS = 2048;    % Packet size including header bits
HEADER_SIZE_BITS = 16;
GENERATING_POLYS = [15 17];
CONSTRAINT_LENGTH = 4;      % Must be set to the appropriate value based on polys
RC_ROLLOFF = 0.25;          % Adjusts alpha of the RRC pulse shape
PHASE_WINDOW = 256;
COARSE_FFT_SIZE = 2^15;

%% Derived and Fixed Parameters (Do not modify!)
F_S = 1e7;   % given, sample rate = 10 Msps

DATA_SIZE_BITS = PACKET_SIZE_BITS - HEADER_SIZE_BITS;
SAMPLES_PER_SYMBOL = 4;  % given, samp/symbol >= 4
T = SAMPLES_PER_SYMBOL/F_S; % symbol time

CODE_RATE = 1/length(GENERATING_POLYS);

if strcmp(MODULATION, 'QPSK')
    M = 2;
    SYNC_PATTERN = generate_m_sequence(6);
    SYNC_PATTERN = SYNC_PATTERN(1:62);
elseif strcmp(MODULATION, '16QAM')
    M = 4;
    SYNC_PATTERN = generate_m_sequence(7);
    SYNC_PATTERN = SYNC_PATTERN(1:124);
else
    disp('MODULATION must be 16QAM or QPSK!!');
end

PULSE_SHAPE = generate_pulse_shaping_filt(F_S, T, RC_ROLLOFF);

PACKET_SIZE_SAMPLES = PACKET_SIZE_BITS/CODE_RATE*SAMPLES_PER_SYMBOL/M;