function encodedData = encoder(data, redundantSymbols)
    symbolSize = 4;
    fieldDimension = 2^symbolSize;
    codewordSize = fieldDimension - 1;
    messageSize = codewordSize - redundantSymbols;
    
    % Create the Galois field.
    [gf_exp, gf_log] = my_galoisField;
    
    % Pad the data to fit the message size for the codeword.
    if rem(length(data), messageSize)~=0
        data = [data zeros(1, messageSize - rem(length(data), messageSize))]; % pad to length divisible by fieldDimension
    end
    
    % Encode the message
    encodedData = [];
    for index = 1:messageSize:length(data)
        encodedData = [encodedData rs_encode_msg(data(index:index+messageSize-1), redundantSymbols, gf_exp, gf_log)]; %#ok<AGROW>
    end