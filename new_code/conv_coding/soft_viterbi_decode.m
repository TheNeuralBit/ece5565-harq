function [out_bits] = soft_viterbi_decode(in_bits,k,polys,K)
%viterbi_decode:
%
%Input: 
%  in_bits: vector of real-valued SOFT bits
%  k: number of bits shifted into encoder at one time
%  polys: vector of octal numbers, where each number corresponds to the
%    octal number representation of a generating polynomial. Note that 
%    n = length(polys) = number of generating polynomials
%  K: constraint length 
%
%Output:
%  out_bits: vector of real-valued bits (ones and zeros) of length
%  length(in_bits)*n/k
%
%Note: Currently, only operates with k=1. Input here is assumed to be soft
%  bits and we perform soft decision decoding
%

%Standardize to row vector
if(size(in_bits,2) == 1)
    in_bits = in_bits'; %Change to row vector 
    isColVector = 1;
else
    isColVector = 0; 
end

%Set up initial variables
n = length(polys);
numBits = length(in_bits);
out_bits = zeros(1,numBits*k/n);
[dec2parity,dec2sum] = create_dec2parity_vect(K);
dec2vect = create_dec2vect(n);

%Prepare generating polynomials
g = zeros(1,n);
for a =1:n
    g(a) = base2dec(num2str(polys(a)),8);
end

%Obtain possible shift register states
register_states = zeros(2^(K-1),K-1);
for a = 0:length(register_states)-1
    bin_str = dec2bin(a,K-1);
    for idx=1:length(bin_str)
        register_states(a+1,idx) = str2double(bin_str(idx));
    end
end
%register_states


%%PERFORM VITERBI DECODING


%A copy of the convolutional encoder next state table, the state transition table of the encoder. The dimensions of this table (rows x columns) are 2(K - 1) x 2k. This array needs to be initialized before starting the decoding process.
%A copy of the convolutional encoder output table. The dimensions of this table are 2(K - 1) x 2k. This array needs to be initialized before starting the decoding process.
%An array (table) showing for each convolutional encoder current state and next state, what input value (0 or 1) would produce the next state, given the current state. We'll call this array the input table. Its dimensions are 2(K - 1) x 2(K - 1). This array needs to be initialized before starting the decoding process.
%An array to store state predecessor history for each encoder state for up to K x 5 + 1 received channel symbol pairs. We'll call this table the state history table. The dimensions of this array are 2 (K - 1) x (K x 5 + 1). This array does not need to be initialized before starting the decoding process.
%An array to store the accumulated error metrics for each state computed using the add-compare-select operation. This array will be called the accumulated error metric array. The dimensions of this array are 2 (K - 1) x 2. This array does not need to be initialized before starting the decoding process.
%An array to store a list of states determined during traceback (term to be explained below). It is called the state sequence array. The dimensions of this array are (K x 5) + 1. This array does not need to be initialized before starting the decoding process.


%Build next_state_table - ***ASSUMES k = 1***
next_state_table = zeros(2^(K-1),2^k);
for a = 0:2^(K-1)-1
    for b = 0:2^k-1
        next_state_table(a+1,b+1) = bitxor(bitshift(a,-1),bitshift(b,K-2));  
    end 
end
%next_state_table

%Build encoder_output_table - ***ASSUMES k = 1***
%encoder_output_table = zeros(2^(K-1),2^k,n);
encoder_output_table = zeros(2^(K-1),2^k);
for a = 0:2^(K-1)-1
    for b = 0:2^k-1 
        register = bitxor(a,bitshift(b,K-1)); %Shifts b into spot K
        polyOutStr = '';
        for c = 1:n
            numAnd = bitand(register,g(c));
            polyOutStr = strcat(polyOutStr,num2str(dec2parity(numAnd+1)));
            %encoder_output_table(a+1,b+1,c) = dec2parity(numAnd+1);
        end
        encoder_output_table(a+1,b+1) = bin2dec(polyOutStr);
    end 
    %encoder_output_table(a+1,:,:)
end
%encoder_output_table


%Build input_forNextState_table - ***Assumes k = 1***
%(entries of table will be bits since k=1) 
input_forNextState_table = NaN(2^(K-1),2^(K-1));
for a = 0:2^(K-1)-1
    for b = 0:2^(K-1)-1
        if b == 0
            input_forNextState_table(a+1,next_state_table(a+1,0+1)+1) = 0;
        elseif b == 1
            input_forNextState_table(a+1,next_state_table(a+1,1+1)+1) = 1;
        end   
    end 
end
%input_forNextState_table


%FINISHED = 'MADE IT THROUGH MY CODE'


%*******START DECODING HERE*******

%Assumes k = 1
state_history_computed = zeros(2^(K-1),numBits*k/n);
path_metrics_computed = Inf(2^(K-1),2);
path_metrics_computed(1,1) = 0; %Row 1 holds past metric, row 2 current metric
for a = 1:n:numBits
    %curBits = fliplr(in_bits(a:a+n-1));
    curBits = in_bits(a:a+n-1);
    %curBits_hard = curBits<0;
    %cur_dec = sum(curBits_hard.*2.^(numel(curBits)-1:-1:0));
    difference0 = zeros(2^(K-1),1);
    difference1 = zeros(2^(K-1),1);
    
    %difference0_hard = zeros(2^(K-1),1); %hard
    %difference1_hard = zeros(2^(K-1),1); %hard
    for b = 1:2^(K-1)
        %tmpdiff = bitxor(cur_dec,encoder_output_table(b,0+1)); %hard
        %difference0_hard(b) = dec2sum(tmpdiff+1); %hard
        encoder_output_vect = -2.*dec2vect(encoder_output_table(b,0+1)+1,:)+1;
        difference0(b) = norm(encoder_output_vect-curBits)^2;
        
        
        %tmpdiff = bitxor(cur_dec,encoder_output_table(b,1+1)); %hard
        %difference1_hard(b) = dec2sum(tmpdiff+1); %hard
        encoder_output_vect = -2.*dec2vect(encoder_output_table(b,1+1)+1,:)+1;
        difference1(b) = norm(encoder_output_vect-curBits)^2;
    end
    
    %Now compare the two paths incoming to each new state 
    for b = 1:2^(K-1)
        
        branchMetric = difference0(b);
        nextState = next_state_table(b,0+1);
        tmpPathMetric = branchMetric + path_metrics_computed(b,1);
        if(tmpPathMetric < path_metrics_computed(nextState+1,2))
            path_metrics_computed(nextState+1,2) = tmpPathMetric;
            state_history_computed(nextState+1,(a-1)/n+1) = b-1;
        end
        
        branchMetric = difference1(b);
        nextState = next_state_table(b,1+1);
        tmpPathMetric = branchMetric + path_metrics_computed(b,1);
        if(tmpPathMetric < path_metrics_computed(nextState+1,2))
            path_metrics_computed(nextState+1,2) = tmpPathMetric;
            state_history_computed(nextState+1,(a-1)/n+1) = b-1;
        end
        
        
    end
    %path_metrics_computed(:,2)
    %state_history_computed(:,1:(a-1)/n+1)
    path_metrics_computed(:,1) = path_metrics_computed(:,2);
    path_metrics_computed(:,2) = Inf(2^(K-1),1);

    
end
%path_metrics_computed
%state_history_computed

%Perform decoding traceback
traceback_states = zeros(1,numBits*k/n);
numEncodedBits = numBits*k/n;
[minMetric,minIdx] = min(path_metrics_computed(:,1)); %Get minimum path metric




traceback_states(1,end) = minIdx-1;
for a = 1:numBits*k/n-1
    traceback_states(1,end-a) = state_history_computed(traceback_states(1,end-a+1)+1,numBits*k/n-a+1);
end
traceback_states = [0 traceback_states]; %Assumes encoder started in all zero state
for a = 1:numEncodedBits
    out_bits(a) = input_forNextState_table(traceback_states(a)+1,traceback_states(a+1)+1);
end


if(isColVector)
    out_bits = out_bits'; %Change back to column vector 
end


end

%%Tests: 
%
% in_bits,k,polys,K: [1 0 1 1 1 0 1 1 1 0 0 0],1,[7,3,5],3
%   out_bits: 1 0 0 0
%
% in_bits,k,polys,K: [1 1 1 0 0 1 0 1 1 1 1 1 1 1 0 1 0 1 (0 1 0 0 1 1)],1,[4,5,7],3
%   out_bits: 1 0 0 1 1 1
%
% in_bits,k,polys,K: [1 1 1 0 1 1 0 0 0 1 1 0 1 0 1 1 1 0 (0 1 0 0 1 1)],1,[17,13],4
%   out_bits: 1 0 0 1 1 1 0 1 1
%
% in_bits,k,polys,K: [0 0 0 0 1 1 1 0 0 0 0 1 0 0 1 0 1 0 1 0 1 1 0 1 1 1 0
%             0 0 1 1 0 1 0 1 1 0 1 0 0 (0 1 1 1 1 1)],1,[17,13],4
%   out_bits: 0 0 1 0 1 0 1 1 1 0 1 0 0 1 1 1 0 1 0 1
%
% in_bits,k,polys,K: [1 0 1 1 0 0 1 0 0 1 0 1 0 1 (0 1 1 1 0 0 1 0 1 1)],1,[77,25],6
%   out_bits: 1 0 1 1 1 0 1
%
% in_bits,k,polys,K: [0 0 1 1 0 1 1 0 1 1 0 1 0 1 1 0 0 0 0 0 0 0 1 1 1 0 1 1 (0 0
%             1 0 0 1 0 1 1 1 1 0 0 1 1 1 1 0 1 1 0 0 0 0)],1,[17777,12525],13
%   out_bits: 0 1 1 1 0 1 0 1 1 0 0 1 0 0
%
% in_bits,k,polys,K: [00 11 10 00 01 10 01 11 11 10 00 10 11 00 11 (10 11)],1,[7,5],3
%   out_bits: 0 1 0 1 1 1 0 0 1 0 1 0 0 0 1
%

