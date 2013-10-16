function decodedData = decoder(encodedData, redundantSymbols)
    symbolSize = 4;
    fieldDimension = 2^symbolSize;
    codewordSize = fieldDimension - 1;
    
    % Create the Galois field.
    [gf_exp, gf_log] = my_galoisField;
    
    decodedData = [];
    for index = 1:codewordSize:length(encodedData)
        % Calculate the syndrome
        syndrome = rs_calc_syndromes(encodedData(index:index+codewordSize-1), redundantSymbols, gf_exp, gf_log);

        % Find the position of the errors
        errorPositions = rs_find_errors(syndrome, codewordSize, gf_exp, gf_log);
        
        if errorPositions ~= -1
            % Repair the message
            repairedMessage = rs_correct_errata(encodedData(index:index+codewordSize-1), syndrome, errorPositions, gf_exp, gf_log);
            decodedData = [decodedData repairedMessage(1:codewordSize-redundantSymbols)]; %#ok<AGROW>
        else
            decodedData = [decodedData encodedData(index:index+codewordSize-1-redundantSymbols)];
        end
    end