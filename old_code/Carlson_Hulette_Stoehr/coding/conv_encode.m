function [out_bits] = conv_encode(in_bits,k,polys,K)
%conv_encode:
%
%Input: 
%  in_bits: vector of real-valued bits (ones and zeros)
%  k: number of bits shifted into encoder at one time
%  polys: vector of octal numbers, where each number corresponds to the
%    octal number representation of a generating polynomial. Note that 
%    n = length(polys) = number of generating polynomials
%  K: constraint length 
%
%Output:
%  out_bits: vector of real-valued bits (ones and zeros) of length
%  length(in_bits)*n/k
%
%out_bits are convolutionally encoded at a rate of k/n
%
%Note: Currently, only operates with k=1 (This will be
%updated periodically with further capabilities)
%


%Standardize to row vector
if(size(in_bits,2) == 1)
    in_bits = in_bits'; %Change to row vector 
    isColVector = 1;
else
    isColVector = 0; 
end

%Set up initial varialbes
n = length(polys);
numBits = length(in_bits);
out_bits = zeros(1,numBits*n/k);
[dec2parity,dec2sum] = create_dec2parity_vect(K);

%Prepare generating polynomials
g = zeros(1,n);
for a =1:n
    g(a) = base2dec(num2str(polys(a)),8);
end


%Append zeros to front of input sequence to simulate all-zero state in the
%shift register 
in_bits = [zeros(1,K-1) in_bits];

%Perform convolutional encoding
for a = 1:numBits
    register = fliplr(in_bits(a:a+K-1));
    register_dec = sum(register.*2.^(numel(register)-1:-1:0));
    %Compute parity bit for each generating polynomial
    for b = 1:n
        numAnd = bitand(register_dec,g(b));
        out_bits((a-1)*n+b) = dec2parity(numAnd+1);
    end

end

%Force shift register to all zero-state
%FIX ME -- ADD ALL-ZERO STATE CODE HERE


if(isColVector)
    out_bits = out_bits'; %Change back to column vector 
end






end