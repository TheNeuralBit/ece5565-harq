function err_pos = rs_find_errors(synd, nmess, gf_exp, gf_log)
    dimension = 4;
    fieldSize = 2^dimension;
    err_poly = 1;
    old_poly = 1;
    
    for i=1:length(synd)
        old_poly = [old_poly 0]; %#ok<AGROW>
        delta = synd(i);
        
        for j = 2:length(err_poly)
            delta = bitxor(delta, gf_mult(err_poly(length(err_poly)-j+1), synd(i+1-j), gf_exp, gf_log));
        end
        
        if delta ~= 0
            if length(old_poly) > length(err_poly)
                new_poly = gf_poly_scale(old_poly, delta, gf_exp, gf_log);
                old_poly = gf_poly_scale(err_poly, gf_div(1, delta, gf_exp, gf_log), gf_exp, gf_log);
                err_poly = new_poly;
            end
            err_poly = gf_poly_add(err_poly, gf_poly_scale(old_poly, delta, gf_exp, gf_log));
        end
    end
    
    errs = length(err_poly)-1;
    
    if errs*2 > length(synd)
        err_pos = -1;
    else
        err_pos = [];
        for i = 1:nmess
            if gf_poly_eval(err_poly, gf_exp(fieldSize-i+1), gf_exp, gf_log) == 0
                err_pos = [err_pos nmess-i+1]; %#ok<AGROW>
            end
        end
        
        if length(err_pos) ~= errs
            err_pos = -1;
        end
    end