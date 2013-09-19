function [ symbols ] = extract_symbols( samples, samps_per_symbol, pulse_shape )
% extract_symbols   Downsample a sequence of complex samples into one
%                   sample per symbol
%
%   Author: Brian Hulette
%   For each symbol, this function pulls out one sample representing that
%   symbol.  For an odd "samps_per_symbol" it just takes the middle sample
%   of each symbol.  For an even "samps_per_symbol" it averages the middle
%   two samples of each symbol.

filt_samples = apply_filt(samples, pulse_shape);

% samples = samples(1:samps_per_symbol*floor(length(samples)/samps_per_symbol));
symbols = reshape(filt_samples, samps_per_symbol, []);

% If there are an odd number of samples in each symbol, just pull out the
% middle sample
% if mod(samps_per_symbol, 2) == 1
%     symbols = symbols(ceil(samps_per_symbol/2),:);
% else
%     mid = samps_per_symbol/2;
%     symbols = mean(symbols(mid:mid+1,:), 1);
% end

symbols = symbols(1,:);

end