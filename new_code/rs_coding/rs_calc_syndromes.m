function syndrome = rs_calc_syndromes(msg, nsym, gf_exp, gf_log)
    syndrome = zeros(1, nsym);
    for i=1:nsym
        syndrome(i) = gf_poly_eval(msg, gf_exp(i), gf_exp, gf_log);
    end