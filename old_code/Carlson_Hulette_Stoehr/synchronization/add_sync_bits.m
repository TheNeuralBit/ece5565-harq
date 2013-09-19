function [ output_bits ] = add_sync_bits( input_bits, sync_bits, packet_size )
% ADD_SYNC_BITS Adds sync bits to a bit stream
%
%   Author: Brian Hulete
%   Inserts the bit sequence "sync_bits" every "packet_size" bits into the
%   bit sequence "input_bit".
input_bits = reshape(input_bits, packet_size, []);
output_bits = vertcat(repmat(sync_bits', 1, size(input_bits, 2)), input_bits);
output_bits = output_bits(:)';

end

