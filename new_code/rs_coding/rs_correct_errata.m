function new_msg = rs_correct_errata(msg, synd, pos, gf_exp, gf_log)
    configuration;
    fieldSize = 2^SYMBOL_SIZE;
    q = 1;
    for i = 1:length(pos);
        x = gf_exp(length(msg)-pos(i)+1);
        q = gf_poly_mul(q, [x 1], gf_exp, gf_log);
    end
    
    p = synd(1:length(pos));
    p = fliplr(p);
    p = gf_poly_mul(p, q, gf_exp, gf_log);
    p = p(length(p)-length(pos)+1:length(p));
    q = q(bitand(length(q),1)+1:2:length(q));
    
    for i = 1:length(pos)
        x = gf_exp(pos(i)+fieldSize-length(msg));
        y = gf_poly_eval(p, x, gf_exp, gf_log);
        z = gf_poly_eval(q, gf_mult(x, x, gf_exp, gf_log), gf_exp, gf_log);
        msg(pos(i)) = bitxor(msg(pos(i)), gf_div(y, gf_mult(x, z, gf_exp, gf_log), gf_exp, gf_log));
    end
    new_msg = msg;