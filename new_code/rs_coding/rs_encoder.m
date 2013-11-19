function output_bits = rs_encoder(input_bits)
    configuration;
    fieldDimension = 2^SYMBOL_SIZE;
    codewordSize = fieldDimension - 1;
    messageSize = codewordSize - REDUNDANT_SYMBOLS;
    numSymbols = length(input_bits) / SYMBOL_SIZE;
    
    % Create the Galois field.
    [gf_exp, gf_log] = my_galoisField;
    
    data = zeros(1, numSymbols);
    
    % Convert binary to decimal symbols
    for idx = 1:numSymbols
        startPos = (idx - 1) * SYMBOL_SIZE + 1;
        endPos = idx * SYMBOL_SIZE;
        data(idx) = binaryVectorToDecimal(input_bits(startPos:endPos)');
    end
    
    % Pad the data to fit the message size for the codeword.
    if rem(length(data), messageSize)~=0
        data = [data zeros(1, messageSize - rem(length(data), messageSize))]; % pad to length divisible by fieldDimension
    end
    
    % Encode the message
    encodedData = rs_encode_msg(data, REDUNDANT_SYMBOLS, gf_exp, gf_log);
    
    % Convert decimal symbols back to binary vector
    encodedDataSymbols = length(encodedData);
    output_bits = zeros(1, encodedDataSymbols*SYMBOL_SIZE);
    for idx = 1:encodedDataSymbols
        startPos = (idx - 1) * SYMBOL_SIZE + 1;
        endPos = idx * SYMBOL_SIZE;
        output_bits(startPos:endPos) = decimalToBinaryVector(encodedData(idx), SYMBOL_SIZE);
    end
