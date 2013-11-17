function msg_out = rs_correct_msg(msg_in, nsym, gf_exp, gf_log)
    % Preallocate the output data with the contents of the input data.
    msg_out = msg_in;
    
    % Find the positions of symbol erasures and set the erasures to zero.
    erase_pos = find(msg_in < 0);
    if (~isempty(erase_pos))
        msg_out(erase_pos) = 0;
    end
    
    % If the number of erasures exceed the number of redundant symbols,
    % then just return the message because nothing can be done.
    if (length(erase_pos) > nsym)
        return
    end
    
    % Calculate the syndrome
    synd = rs_calc_syndromes(msg_out, nsym, gf_exp, gf_log);
    if (max(synd) == 0) % If the syndrome consists of all zeros, we have a correct message.
        return
    end
    
    % Calculate the Forney syndrome to adjust the syndrome for the erasures.
    fsynd = rs_forney_syndromes(synd, erase_pos, length(msg_out), gf_exp, gf_log);
    
    % Find the position of the errors
    err_pos = rs_find_errors(fsynd, length(msg_out), gf_exp, gf_log);
    
    % If there are too many errors, then just return the message because
    % nothing can be done.
    if (err_pos == -1)
        return;
    end
    
    % Combine the locations of erasures and errors into one vector.
    combined_pos = [erase_pos err_pos];
    
    % Correct the message
    msg_out = rs_correct_errata(msg_out, synd, combined_pos, gf_exp, gf_log);