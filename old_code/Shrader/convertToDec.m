function output=convertToDec(input)
        
    symbolsize=4; %number of bits per symbol
    %add zeros to the end of the input vector to make it
    %evenly divisible by the symbol size
    if rem(length(input),symbolsize)~=0
        pad=zeros(1,symbolsize-rem(length(input),symbolsize)); %pad to length divisible by symbol size
        input = [input pad];
    end
    input_length=length(input);
    input_reshaped=transpose(reshape(input,4,input_length/4)); %reshape input vector to 2 column matrix - first column is 2 bits for in-phase component
                                                               %convert each row from binary to decimal (0 through 3)
    input_decimals=zeros(1,length(input)/4);
    for k=1:length(input_reshaped)
        input_decimals(k)= 8*input_reshaped(k,1)+4*input_reshaped(k,2)+2*input_reshaped(k,3)+1*input_reshaped(k,4);
    end
 output=input_decimals;
end