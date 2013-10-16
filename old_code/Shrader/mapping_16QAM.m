function output=mapping_16QAM(input)
%function mapping_16QAM - input is binary row vector which is mapped using 16 QAM with Gray Coding
%output is a normalized complex vector
    % 00=0 --> -3
    % 01=1 --> -1
    % 11=3 --> +1
    % 10=2 --> +3
    symbolsize=4; %size of symbols
    if rem(length(input),symbolsize)~=0
        pad=zeros(1,symbolsize-rem(length(input),symbolsize)); %pad to length divisible by symbol size
        input = [input pad];
    end
    %            0000  0001  0010  0011  0100  0101  0110  0111 1000 1001 1010 1011 1100 1101 1110 1111
    voltages = [-3-3i -3-1i -3+3i -3+1i -1-3i -1-1i -1+3i -1+1i 3-3i 3-1i 3+3i 3+1i 1-3i 1-1i 1+3i 1+1i];
    output = voltages(input(1:length(input))+1) / sqrt(5);
end