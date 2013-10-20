function g = rs_generator_poly(nsym, gf_exp, gf_log)
g = 1;
for i=1:nsym
    g = gf_poly_mul(g, [1 gf_exp(i)], gf_exp, gf_log);
end