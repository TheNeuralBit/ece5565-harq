function [ dec2vect ] = create_dec2vect( K )
%create_dec2vect:
%
%Input: 
%  K: input designating the largest number for which to return a vector.
%     This largest number will be 2^K - 1
%
%Output:
%  dec2vect: matrix that gives the binary vector representation for each 
%     decimal number from 0 up to 2^K - 1. Each row will give the vector
%     representation for that number, with K digits.
%     

dec2vect = zeros(2^K,K);
for a = 1:2^K
    bin_str = dec2bin(a-1,K);
    for b=1:length(bin_str)
        dec2vect(a,b) = str2double(bin_str(b));
    end
end

end