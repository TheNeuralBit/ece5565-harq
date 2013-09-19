function [ equalized_syms ] = equalizer(symbols, rxd_sync, sync_pattern, sync_length, modulation)
% Finite Length MMSE Equalizer
% By:CEC

% Explanation
% This equalizer tries to minimize the mean square error between the
% received symbol and a known symbol.  This practical implementation of the
% MMSE equalizer assumes the form of an FIR filter.  Reduced to a set of
% finte set of linear equations:
%
%                             {  Es*h(u-l)*   l=0,1,...,u
%   Summation{f(i)R_z(l-i)} = {
%                             {   0           l=u+1,u+2,...,M
%
%  
% The received pilot symbols are being compared to the known pilot symbols.  
% Once the equalized pilot symbols are filtered, a ratio is computed 
% between the received pilots and the known pilots.  That value is 
% multiplied by some adjustment factor alpha and the received data packets.



% First mod the rxd_sync with number of syncs and make sure you have correct number of
% symbols

sync_length = length(sync_pattern);

% Initialize Variables
Neq = 8;                % Order of linear equalizer
n_train = sync_length;  % Number of training symbols

% Based off the modulation type, determines our adjustment value
if strcmp(modulation, 'QPSK')
    alpha = 0.1;        % Adjustment value
elseif strcmp(modulation, '16QAM')
    alpha = 1;          % Adjustment value
else
    alpha = 1;
end



% Algorithm for equalization. Compares received pilot symbols to known
% pilot symbols. 
    
% Current pilot symbols
current_pilot = rxd_sync(Neq+1:n_train);
       
% Signal matrix for computing the R vector
Z = toeplitz(current_pilot,rxd_sync(Neq+1:-1:1)); 
        
% Build Training data vector based off the known sync pattern
training_data = sync_pattern(Neq+1:n_train);

% Equalizer tap vector
f_equalizer = pinv(Z'*Z)*Z'*training_data';
       
% After running through filter, return new equalized pilot symbols
equalized_pilots=filter(f_equalizer,1,current_pilot);

% Rotate the equalized pilots
equalized_pilots = equalized_pilots';

% Ratio of equalized syms to known pilot symbols
equalized_ratio = equalized_pilots/sync_pattern(Neq+1:n_train);

% Multiply equalized ratio by symbols in packet for equalization
equalized_syms = equalized_ratio.*alpha.*symbols;


end

