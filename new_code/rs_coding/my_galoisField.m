function [gf_exp, gf_log] = my_galoisField
configuration;
fieldSize = 2^SYMBOL_SIZE;
doubleFieldSize = 2*fieldSize;
gf_exp = ones(1, 2*fieldSize);
gf_log = zeros(1, fieldSize);
x = 1;
for i = 2:fieldSize-1
    x = bitshift(x, 1);
    if x >= fieldSize
        x = mod(bitxor(x, GALOIS_FIELD_GENERATOR_POLY), fieldSize);
    end
    gf_exp(i) = x;
    gf_log(x) = i-1;
end

gf_exp(fieldSize+1:doubleFieldSize) = gf_exp((fieldSize+1:doubleFieldSize)-(fieldSize-1));
