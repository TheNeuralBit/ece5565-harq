%%%
% Test-Bed for Different Modulation and De-Modulation functions
%
%   Test1: BPSK
%
%   Test2: QPSK
%
%   Test3: QAM
%
% Goal is to eventually have M-PSK,M-FSK,M-ASK,M-QAM
%
% By: Craig Carlson

clc;close all;clear all;

% Number of Samples
NumSamples= 50;

% Generate a random bit stream of 1's and 0's
bits_in=round(rand(NumSamples,1));

% Sampling rate fs
fs = 1000;

% Generate time for data
time=[];

SquareWave=[];

%Bit duration
t=0:1/fs:1;

%Create bit stream for visuals
for(i=1:1:length(bits_in))
   %Original Signal
   if bits_in(i)==0
      bit0= zeros(1,length(t));
      SquareWave= [SquareWave bit0];
   end
   
   if bits_in(i)==1
      bit1= ones(1,length(t));
      SquareWave= [SquareWave bit1]; 
   end
end


%%%%%%%%%%%---- Test1: BPSK ----%%%%%%%%%%%%%

[bits_bpsk, time]=BPSKmod(bits_in,fs);


%-------Needs Work------%
bits_bpsk_out=BPSKdemod(bits_bpsk,fs);
%-------Needs Work------%

%Plot the input bits
figure(1)
subplot(3,1,1);
plot(time,SquareWave,'r','LineWidth',2);
xlabel('Time (bits) ');
ylabel('Amplitude');
title('BPSK');
axis([0 time(end) -0.5 1.5]);
grid on;

%Plot the modulated BPSK stream
subplot(3,1,2);
plot(time,bits_bpsk,'b','LineWidth',2);
xlabel('Time (bit period) ');
ylabel('Amplitude');
title('BPSK Modulated Signal');
axis([0 time(end) -1.5 1.5]);
grid on;

%Plot the demodulated BPSK bit stream
subplot(3,1,3);
plot(time,bits_bpsk_out,'g','Linewidth',2);
xlabel('Time (bit period) ');
ylabel('Amplitude');
title('Demodulated BPSK Signal');
axis([0 time(end) -1.5 1.5]);
grid on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%---- Test2: BASK ----%%%%%%%%%%%%%

bits_bask=BASKmod(bits_in, fs);

%-------Needs Work------%
bits_bask_out=BASKdemod(bits_bask,fs);
%-------Needs Work------%

%Plot the input bits
figure(2)
subplot(3,1,1);
plot(time,SquareWave,'r','LineWidth',2);
xlabel('Time (bits) ');
ylabel('Amplitude');
title('BASK');
axis([0 time(end) -0.5 1.5]);
grid on;

%Plot the modulated BASK stream
subplot(3,1,2);
plot(time,bits_bask,'b','LineWidth',2);
xlabel('Time (bit period) ');
ylabel('Amplitude');
title('BASK Modulated Signal');
axis([0 time(end) -1.5 1.5]);
grid on;

%Plot the demodulated BASK bit stream
subplot(3,1,3);
plot(time,bits_bask_out,'g','Linewidth',2);
xlabel('Time (bit period) ');
ylabel('Amplitude');
title('Demodulated BASK Signal');
axis([0 time(end) -1.5 1.5]);
grid on;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%---- Test3: BFSK ----%%%%%%%%%%%%%

bits_bfsk=BFSKmod(bits_in, fs);


bits_bfsk_out=BFSKdemod(bits_bfsk,fs);

%Plot the input bits
figure(3)
subplot(3,1,1);
plot(time,SquareWave,'r','LineWidth',2);
xlabel('Time (bits) ');
ylabel('Amplitude');
title('BFSK');
axis([0 time(end) -0.5 1.5]);
grid on;

%Plot the modulated BASK stream
subplot(3,1,2);
plot(time,bits_bfsk,'b','LineWidth',2);
xlabel('Time (bit period) ');
ylabel('Amplitude');
title('BFSK Modulated Signal');
axis([0 time(end) -1.5 1.5]);
grid on;

%Plot the demodulated BASK bit stream
subplot(3,1,3);
plot(time,bits_bfsk_out,'g','Linewidth',2);
xlabel('Time (bit period) ');
ylabel('Amplitude');
title('Demodulated BFSK Signal');
axis([0 time(end) -1.5 1.5]);
grid on;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%---- Test4: ???? ----%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


