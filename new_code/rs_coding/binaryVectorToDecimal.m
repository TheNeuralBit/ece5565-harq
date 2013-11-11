% Converts an arbitrary length binary vector into its decimal equivalent.
function result = binaryVectorToDecimal(input)
    result = sum(input.*(2.^(size(input, 2)-1:-1:0)));