function err_pos = rs_find_errors(synd, nmess, gf_exp, gf_log)
    configuration;
    fieldSize = 2^SYMBOL_SIZE;
    err_poly = 1;
    old_poly = 1;
    
    for idx = 1:length(synd)
        old_poly = [old_poly 0]; %#ok<AGROW>
        delta = synd(idx);
        
        for jdx = 2:length(err_poly)
            delta = bitxor(delta, gf_mult(err_poly(length(err_poly)-jdx+1), synd(idx+1-jdx), gf_exp, gf_log));
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
        for jdx = 1:nmess
            %jdx
            %nmess
            %hmm = fieldSize-jdx+1
            if gf_poly_eval(err_poly, gf_exp(fieldSize-jdx+1), gf_exp, gf_log) == 0
                err_pos = [err_pos nmess-jdx+1]; %#ok<AGROW>
            end
        end
        
        if length(err_pos) ~= errs
            err_pos = -1;
        end
    end