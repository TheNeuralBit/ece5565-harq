function [ symbols ] = modulate( bits, type, samples_per_symbol )
% MODULATE modulates input bits with a specified modulation type and
% upsamples
%
% Arguments:
% bits - Row vector of bits to modulate
% type - type of modulation to perform (QPSK or 16QAM)
% samples_per_symbol - The number of samples_per_symbol

if strcmp(type, 'QPSK')
    symbols = QPSKmod(bits);
elseif strcmp(type, '16QAM')
    symbols = QAM_16_mod(bits);
else
    symbols = [];
end

symbols = upsample(symbols, samples_per_symbol);

end

