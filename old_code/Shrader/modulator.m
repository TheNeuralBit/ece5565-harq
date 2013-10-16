function [output] = modulator(input)
%function modulator - converts complex baseband to samples of waveform
%using SRRC pulse shape
%input is a row vector of complex numbers
%output is a row vector of samples
    
    %Square Root Raised Cosine Pulse shaping - based on Tranter equation
    T = 1; %symbol time
    k = 4; %filter samples
    m = 4; %delay
    beta = 0.32; % bandwidth factor
    n = 0:2*m*k;
    z = (n/k)-m+eps;
    h = 4*beta/(pi*sqrt(T))*(cos((1+beta)*pi*z)+sin((1-beta)*pi*z)./(4*beta*z))./(1-16*beta*beta*z.*z); %impulse response for SRRC filter

    padded_input=zeros(1,8*length(input)); %create vector with 8 samples per symbol
    
    for k=1:length(input)
        padded_input((k-1)*8+1:k*8)=[0 0 0 0 input(k) 0 0 0]; % turn input into string of impulses separated by zeros
    end
    
    output=conv(padded_input,h); %filter the padded input vector by convolving SRRC filter with the input impulses
end

