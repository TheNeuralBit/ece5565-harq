function [ symbols ] = extract_symbols( samples, samps_per_symbol )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
symbols = reshape(samples, samps_per_symbol, []);

% If there are an odd number of samples in each symbol, just pull out the
% middle sample
if mod(samps_per_symbol, 2) == 1
    symbols = symbols(ceil(samps_per_symbol/2),:);
else
    mid = samps_per_symbol/2;
    symbols = mean(symbols(mid:mid+1,:), 1);
end

end

