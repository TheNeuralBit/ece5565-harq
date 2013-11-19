function msg_out = rs_correct_msg(msg_in, nsym, gf_exp, gf_log)
    msg_out = msg_in;
    erase_pos = find(msg_in < 0);
    
    if (~isempty(erase_pos))
        msg_out(erase_pos) = 0;
    end
    
    if (length(erase_pos) > nsym)
        msg_out = [];
        return
    end
    
    synd = rs_calc_syndromes(msg_out, nsym, gf_exp, gf_log);
    if (max(synd) == 0)
        return
    end
    
    fsynd = rs_forney_syndromes(synd, erase_pos, length(msg_out), gf_exp, gf_log);
    err_pos = rs_find_errors(fsynd, length(msg_out), gf_exp, gf_log);
    
    if (err_pos == -1)
        return;
    end
    
    combined_pos = [erase_pos err_pos];
    msg_out = rs_correct_errata(msg_out, synd, combined_pos, gf_exp, gf_log);
    
    synd = rs_calc_syndromes(msg_out, nsym, gf_exp, gf_log);