function [ bits, softbits ] = demodulate( symbols, type, samples_per_symbol, pulse_shape )
% DEMODULATE demodulates input bits with a specified modulation type
%
% Arguments:
% symbols - Row vector of bits to modulate
% type - type of modulation to perform (QPSK or 16QAM)
symbols = extract_symbols(symbols, samples_per_symbol, pulse_shape);
if strcmp(type, 'QPSK')
    [bits, softbits] = QPSK_demod(symbols);
elseif strcmp(type, '16QAM')
    [bits, softbits] = QAM_16_demod(symbols);
else
    bits = [];
    softbits = [];
end

end