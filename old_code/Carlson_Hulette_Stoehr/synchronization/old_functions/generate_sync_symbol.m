function [ samps ] = generate_sync_symbol( num_samples, q, u )
% Generate Zadoff-Chu with N_zc = num_samples and give q, u
% q can be any integer (usually 0)
% the gcd of num_samples and u should be 1 (easiest to just use 1)
n = 0:num_samples-1;
samps = exp(-1i*pi*u*n.*(n+1+2*q)/num_samples);
end