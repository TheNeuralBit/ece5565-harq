function r = gf_poly_eval(p, x, gf_exp, gf_log)
    r = p(1);
    for i = 2:length(p)
        r = bitxor(gf_mult(r, x, gf_exp, gf_log), p(i));
    end