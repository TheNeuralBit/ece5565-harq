function [ sequence ] = generate_m_sequence( N )

% Define the taps used to compute the "new bit"
% on each iteration
if N == 14
    taps=[0 0 0 1 0 0 0 1 0 0 0 0 1 1];
elseif N == 13
    taps=[0 0 0 0 0 0 0 0 1 1 0 1 1];
elseif N == 12
    taps=[0 0 0 0 0 1 0 1 0 0 1 1];
elseif N == 11
    taps=[0 0 0 0 0 0 0 0 1 0 1];
elseif N == 10
    taps=[0 0 0 0 0 0 1 0 0 1];
elseif N == 9
    taps=[0 0 0 0 1 0 0 0 1];
elseif N == 8
    taps=[0 0 0 1 1 1 0 1];
elseif N == 7
    taps=[0 0 0 1 0 0 1];
elseif N == 6;
    taps=[0 0 0 0 1 1];
elseif N == 5; 
    taps=[0 0 1 0 1];
elseif N == 4; 
    taps=[0 0 1 1];
elseif N == 3;
    taps=[0 1 1]; 
end

M = 2^N-1;

% Pre-allocate arrays
m = ones(1,N);
sequence = zeros(1,M);

for ind = 1:M
    % Compute new bit
    new_bit = mod(sum(taps.*m),2);
    
    % Shift bits, place new bit at beginning of array
    m(2:N) = m(1:N-1);
    m(1) = new_bit;
    
    % "Shift out" the last bit
    sequence(ind) = m(N);
end

end