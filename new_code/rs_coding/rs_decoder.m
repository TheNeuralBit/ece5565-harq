function output_bits = rs_decoder(input_bits)
    configuration;
    numSymbols = length(input_bits) / SYMBOL_SIZE;
    
    % Create the Galois field.
    [gf_exp, gf_log] = my_galoisField;
    
    encodedData = -ones(1, RS_CODEWORD_SIZE);
    
    % Convert binary to decimal symbols
    for idx = 1:numSymbols
        startPos = (idx - 1) * SYMBOL_SIZE + 1;
        endPos = idx * SYMBOL_SIZE;
        encodedData(idx) = binaryVectorToDecimal(input_bits(startPos:endPos));
    end
    
    % Correct the message of any errors or erasures.
    decodedData = rs_correct_msg(encodedData, REDUNDANT_SYMBOLS, gf_exp, gf_log);
    recoveredData = decodedData(1:RS_DATA_SIZE);
    
    % Convert decimal symbols back to binary vector
    decodedDataSymbols = length(recoveredData);
    output_bits = zeros(1, decodedDataSymbols*SYMBOL_SIZE);
    for idx = 1:decodedDataSymbols
        startPos = (idx - 1) * SYMBOL_SIZE + 1;
        endPos = idx * SYMBOL_SIZE;
        output_bits(startPos:endPos) = decimalToBinaryVector(recoveredData(idx), SYMBOL_SIZE);
    end