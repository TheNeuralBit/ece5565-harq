function [ dec2parity, dec2sum ] = create_dec2parity_vect( K )
%create_dec2parity_vect:
%
%Input: 
%  K: input designating the largest number for which to return parity. This
%     largest number will be 2^K - 1
%
%Output:
%  dec2parity: vector that gives the parity of the decimal numbers from 0 up
%     to 2^K - 1
%  dec2sum: vector that gives the sum of the binary digits making up the
%     decimal number, for numbers 0 up to 2^K-1
% 

dec2parity = zeros(1,2^K);
dec2sum = zeros(1,2^K);
for a = 1:2^K
    bin_str = dec2bin(a-1);
    bitSum = 0;
    for b=1:length(bin_str)
        bitSum = bitSum + str2double(bin_str(b));
    end
    dec2sum(a) = bitSum;
    dec2parity(a) = mod(bitSum,2);
end

end

