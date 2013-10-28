function [ output_args ] = plot_eye_diagram( data, symbol_samps, num_symbols )
% Reshape into an eye diagram
data_reshape = reshape(data(1:num_symbols*symbol_samps), symbol_samps*2, []).';

plot(linspace(0,2,symbol_samps*2), real(data_reshape).','b');   
title('Eye Diagram');
xlabel('Time (symbols)')
axis([0 2 -1 1])
grid on

end

