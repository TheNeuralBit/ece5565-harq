function msg_out = rs_encode_msg(msg_in, nsym, gf_exp, gf_log)
gen = rs_generator_poly(nsym, gf_exp, gf_log);
msg_out = [msg_in zeros(1, nsym)];

for i = 1:length(msg_in)
    coef = msg_out(i);
    if coef ~= 0
        for j=0:length(gen)-1
            msg_out(i+j) = bitxor(gf_mult(gen(j+1), coef, gf_exp, gf_log), msg_out(i+j));
        end
    end
end

msg_out(1:length(msg_in)) = msg_in(1:end);

