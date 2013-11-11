function result = gf_div(x, y, gf_exp, gf_log)
    configuration;
    fieldSize = 2^SYMBOL_SIZE;
    if (y == 0)
        error('Can not divide by zero\n');
    elseif (x == 0)
        result = 0;
    else
        result = gf_exp(gf_log(x) + fieldSize - gf_log(y));
    end
    