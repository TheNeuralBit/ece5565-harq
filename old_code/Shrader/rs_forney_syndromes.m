function fsynd = rs_forney_syndromes(synd, pos, nmess, gf_exp, gf_log)
    fsynd = synd;
    for idx=1:length(pos)
        x = gf_exp(nmess-pos(idx)+1);
        for jdx = 1:length(fsynd)-1
            fsynd(jdx) = bitxor(gf_mult(fsynd(jdx), x, gf_exp, gf_log), fsynd(jdx+1));
        end
        fsynd = fsynd(1:length(fsynd)-1);
    end