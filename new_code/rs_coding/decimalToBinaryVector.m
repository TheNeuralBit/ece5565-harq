% Convert a decimal integer to a binary vector of the given length. If the
% given length is less than the space needed to represent the integer, it
% will be increased to that value.
function vector = decimalToBinaryVector(decimal, vectorLength)
    min = fix(log2(decimal)) + 1;
    if (vectorLength < min)
        vectorLength = min;
    end
    
    vector = bitget(decimal, vectorLength:-1:1);