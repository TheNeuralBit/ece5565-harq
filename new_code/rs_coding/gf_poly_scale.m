function result = gf_poly_scale(p, x, gf_exp, gf_log)
    result = zeros(1, length(p));
    for i = 1:length(p)
        result(i) = gf_mult(p(i), x, gf_exp, gf_log);
    end
    