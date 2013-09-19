close all;
fs = 1E6; % sampling frequency in Hz
symbol_samps = 4;
sync_size=100;
T = symbol_samps/fs; % symbol time
symbols_per_packet=1024;
packet_size = symbols_per_packet*symbol_samps;  % 10 symbols in a packet
rc_rolloff = 0.5;

% Generate Data
% data = zeros(1, packet_size*10); % "Transmit" 10 packets
data = ones(symbol_samps, symbols_per_packet*10);

for i=1:size(data,2);
    m = mod(i,4);
    if m == 0
        data(:,i) = 1;
    elseif m == 1
        data(:,i) = 1j;
    elseif m == 2
        data(:,i) = -1;
    elseif m==3
        data(:,i) = -1j;
    end
end
data = data(:)';

% Insert sync symbols
symbol = generate_sync_symbol(sync_size, 0, 1);
tx = add_sync_symbols(data, symbol, packet_size);

% TX Pulse shape
tx = pulse_shaping(tx, fs, T, rc_rolloff, 'sqrt');

% Channel model
%NOTE: The correlation is unaffected by phase offset
rx = awgnChannel(tx,0.1,fs,20/fs,pi/3,0);
% rx = tx;

% RX Pulse shape
rx = pulse_shaping(rx, fs, T, rc_rolloff, 'sqrt');
figure;
plot(rx, 'o');
% Pull out dem symbols
% symbol = pulse_shaping(symbol, fs, T, rc_rolloff, 'normal');
symbol = pulse_shaping(symbol, fs, T, rc_rolloff, 'sqrt');
symbol = pulse_shaping(symbol, fs, T, rc_rolloff, 'sqrt');

[packet, index] = sync_packet(rx, symbol, sync_size, packet_size, 1, sync_size+packet_size);
figure;
plot(packet, 'o');
while index+sync_size+packet_size < length(rx)
    pause(0.5);
    [packet, index] = sync_packet(rx, symbol, sync_size, packet_size, index-sync_size, index+2*sync_size);
    plot(packet, 'o');
end

% packets = extract_sync_symbols(rx, symbol, sync_size, symbol_samps, symbols_per_packet);