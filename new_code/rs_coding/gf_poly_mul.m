function result = gf_poly_mul(x, y, gf_exp, gf_log)
    configuration;
    fieldSize = 2^SYMBOL_SIZE;
    result = zeros(1, length(x)+length(y)-1);
    
    for j = 1:length(y)
        for i = 1:length(x)
            result(i+j-1) = mod(bitxor(gf_mult(x(i), y(j), gf_exp, gf_log), result(i+j-1)), fieldSize);
        end
    end