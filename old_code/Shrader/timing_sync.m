function [output]=timing_sync(input)
%function timing_sync - identifies symbol start index
%input is a row vector of complex numbers
%output is an integer representing the start index of the symbols for
%demodulation
        
    %pulse shape using SRRC filter
    T = 1; %symbol time
    k = 4; %filter samples
    m = 4; %delay
    beta = 0.32; %bandwidth factor
    n = 0:2*m*k;
    z = (n/k)-m+eps;
    h = 4*beta/(pi*sqrt(T))*(cos((1+beta)*pi*z)+sin((1-beta)*pi*z)./(4*beta*z))./(1-16*beta*beta*z.*z); %impulse response for SRRC filter

    input_length=length(input);
    symbol_length=8;
    
    %create impulse train to use for synchronization
    train_length=floor(input_length/symbol_length);
    impulse=[0 0 0 0 1 0 0 0];
    train=[];
    for k=1:train_length
        train = [train impulse];
    end
    sync=conv(train,h); %sync is a series of SRRC pulses made by convolving impulse train and SRRC filter

    %loop through input shifted by range of values
    %from 1 to length of symbol-1
    %multiply it by sync, square output and sum all values
    for k=1:symbol_length-1
        summed(k)=sum((sync(1:train_length).*circshift(real(input(1:train_length)),[0,1-k])).^2) + sum((sync(1:train_length).*circshift(imag(input(1:train_length)),[0,1-k])).^2);
    end

    [maxVal,output]=max(summed); %pick max summation as output index (best correlation with sync pulse train)

end

  