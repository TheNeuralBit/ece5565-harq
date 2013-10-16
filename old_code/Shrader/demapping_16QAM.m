function output=demapping_16QAM(input)
%function demapping_16QAM - input is complex row vector which is demapped using 16 QAM with Gray Coding
%output is a decimal vector
    output = input;
    output(input == -3-3i) = 0;
    output(input == -3-1i) = 1;
    output(input == -3+3i) = 2;
    output(input == -3+1i) = 3;
    output(input == -1-3i) = 4;
    output(input == -1-1i) = 5;
    output(input == -1+3i) = 6;
    output(input == -1+1i) = 7;
    output(input ==  3-3i) = 8;
    output(input ==  3-1i) = 9;
    output(input ==  3+3i) = 10;
    output(input ==  3+1i) = 11;
    output(input ==  1-3i) = 12;
    output(input ==  1-1i) = 13;
    output(input ==  1+3i) = 14;
    output(input ==  1+1i) = 15;
end