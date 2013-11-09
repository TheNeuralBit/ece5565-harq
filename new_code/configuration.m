%% Configuruable Parameters
MODULATION = 'QPSK';        % 16QAM or QPSK
CODING = 'CONV';            % CONV or RS
PACKET_SIZE_BITS = 2048;    % Packet size including header bits
%HEADER_SIZE_BITS = 16;
RC_ROLLOFF = 0.25;          % Adjusts alpha of the RRC pulse shape
PHASE_WINDOW = 256;

if strcmp(CODING,'CONV')
    GENERATING_POLYS = [13 15 17];
    CONSTRAINT_LENGTH = 4;      % Must be set to the appropriate value based on polys
    CODE_RATE = 1/length(GENERATING_POLYS);
elseif strcmp(CODING,'RS')
    %Add RS parameters here
    CODE_RATE = 1
end


%% Derived and Fixed Parameters (Do not modify!)
F_S = 1e7;   % given, sample rate = 10 Msps

%DATA_SIZE_BITS = PACKET_SIZE_BITS - HEADER_SIZE_BITS;
SAMPLES_PER_SYMBOL = 4;  % given, samp/symbol >= 4
T = SAMPLES_PER_SYMBOL/F_S; % symbol time



if strcmp(MODULATION,'QPSK')
    M = 4;
    BITS_PER_SYMBOL = 2;
elseif strcmp(MODULATION,'16QAM')
    M = 16;
    BITS_PER_SYMBOL = 4;
end

PULSE_SHAPE = generate_pulse_shaping_filt(F_S, T, RC_ROLLOFF);

%PACKET_SIZE_SAMPLES = PACKET_SIZE_BITS/CODE_RATE*SAMPLES_PER_SYMBOL/M;
PACKET_SIZE_SAMPLES = PACKET_SIZE_BITS/SAMPLES_PER_SYMBOL/M;
