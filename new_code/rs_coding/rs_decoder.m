function output_bits = rs_decoder(input_bits)
    configuration;
    fieldDimension = 2^SYMBOL_SIZE;
    codewordSize = fieldDimension - 1;
    numSymbols = length(input_bits) / SYMBOL_SIZE;
    
    % Create the Galois field.
    [gf_exp, gf_log] = my_galoisField;
    
    encodedData = zeros(1, numSymbols);
    
    % Convert binary to decimal symbols
    for idx = 1:numSymbols
        startPos = (idx - 1) * SYMBOL_SIZE + 1;
        endPos = idx * SYMBOL_SIZE;
        encodedData(idx) = binaryVectorToDecimal(input_bits(startPos:endPos));
    end
    
    decodedData = [];
    for index = 1:codewordSize:length(encodedData)
        % Calculate the syndrome
        syndrome = rs_calc_syndromes(encodedData(index:index+codewordSize-1), REDUNDANT_SYMBOLS, gf_exp, gf_log);

        % Find the position of the errors
        errorPositions = rs_find_errors(syndrome, codewordSize, gf_exp, gf_log);
        
        if errorPositions ~= -1
            % Repair the message
            repairedMessage = rs_correct_errata(encodedData(index:index+codewordSize-1), syndrome, errorPositions, gf_exp, gf_log);
            decodedData = [decodedData repairedMessage(1:codewordSize-REDUNDANT_SYMBOLS)]; %#ok<AGROW>
        else
            decodedData = [decodedData encodedData(index:index+codewordSize-1-REDUNDANT_SYMBOLS)]; %#ok<AGROW>
        end
    end
    
    %decodedDataHmm = decodedData
    
    % Convert decimal symbols back to binary vector
    decodedDataSymbols = length(decodedData);
    output_bits = zeros(1, decodedDataSymbols*SYMBOL_SIZE);
    for idx = 1:decodedDataSymbols
        startPos = (idx - 1) * SYMBOL_SIZE + 1;
        endPos = idx * SYMBOL_SIZE;
        output_bits(startPos:endPos) = decimalToBinaryVector(decodedData(idx), SYMBOL_SIZE);
    end
    
    %outputBitsHmm = output_bits