function [output output2] = demodulator(input)
%function demodulator - samples of received waveform to complex baseband
%also uses SRRC filter
%input is a row vector of samples
%output is a row vector of complex numbers

    %cutoff=.485; %the decision range
    cutoff=.52;
    %cutoff=.38;
    %cutoff=.512;
    %cutoff=.5;
    
    %Second SRRC filter
    T = 1; %symbol time
    k = 4; %filter samples
    m = 4; %delay
    beta = 0.32; %bandwidth factor
    n = 0:2*m*k;
    z = (n/k)-m+eps;
    h = 4*beta/(pi*sqrt(T))*(cos((1+beta)*pi*z)+sin((1-beta)*pi*z)./(4*beta*z))./(1-16*beta*beta*z.*z); %impulse response for SRRC filter

    filtered_input=conv(input,conj(h)); %filter the received signal
    
    index=timing_sync(filtered_input); %use timing sync function to identify symbol start index
    %index=2;
    
    summed=zeros(1,floor((length(filtered_input)-index)/8)); %create vector to store summations
    
    %loop through filtered received signal and sum across symbol period (8
    %samples)
    for k=1:floor((length(filtered_input)-index)/8)
        summed(k)=(sum(filtered_input(index+(k-1)*8:index-1+k*8)))/32;
    end
    
    output=zeros(1,length(summed)); %create vector to store complex number output
    output2=index;
    
    %loop through summed values and make decisions based on cutoff region
    %for real part (in-phase component) & imag part (quadrature component)
    for k=1:length(summed)
        if real(summed(k))>= cutoff
            output(k)=3;
        elseif real(summed(k))>=0
            output(k)=1;
        elseif real(summed(k))>=-cutoff;
            output(k)=-1;
        else
            output(k)=-3;
        end
    
        if imag(summed(k))>= cutoff
            output(k)=output(k)+j*3;
        elseif imag(summed(k))>=0
            output(k)=output(k)+j;
        elseif imag(summed(k))>=-cutoff;
            output(k)=output(k)-j;
        else
            output(k)=output(k)-j*3;
        end
    end
    
    output=output(5:length(output)-3); %output demodulated data points (removing extra leading and trailing data points added by filter)
end

