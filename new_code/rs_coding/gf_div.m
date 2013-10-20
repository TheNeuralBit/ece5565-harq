function result = gf_div(x, y, gf_exp, gf_log)
    dimension = 4;
    fieldSize = 2^dimension;
    if (y == 0)
        error('Can not divide by zero\n');
    elseif (x == 0)
        result = 0;
    else
        result = gf_exp(gf_log(x) + fieldSize - gf_log(y));
    end
    