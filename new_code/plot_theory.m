function plot_theory(cfg)
%plot_theory:
%  Plots theoretical results for ARQ, Type I HARQ, and Type II HARQ with
%  convolutional coding
%
%Input: 
%  cfg: 
%  harqtype: 0=ARQ, 1=TypeI HARQ, 2=TypeII HARQ
%  txattempt: Denotes the attempt number for the transmission of this set
%    of bits. Each HARQ type and FEC scheme used may use this number to 
%    determine exactly what to transmit (along with persistent info)
%
%Output:
%  tx_samples: samples to be passed into channel 
%  num_bits_txed: total number of bits transmitted (to be used for
%    throughput measurements)
%
%For results on general convolutional coding with BPSK, see Module 10, test_coding_BPSK

%Set up parameters
EBNO = -3:12;         % Desired Ratio of Bit Energy to Noise Power in dB
ebno = 10.^(EBNO.*0.1);
no_retx = 10; % Max number of retransmissions used for Type II calculation

if cfg == 1 %With polys [15, 17]
    CODE_RATE = 1/2; 
    GENERATING_POLYS = [15 17]; %Rate 1/2
    CONSTRAINT_LENGTH = 4; 
    k = 2048;
    n_p = 32;
    m = 4;
    alpha = [1 3 5 11 25 55 121 267 589 1299];
    dfree = 6;
    
    %For HARQII
    dfree_3 = 10;
    alpha_3 = [5 0 5 0 31 0 65 0 242 0 640 0 2058 0];
    dfree_5 = 16;
    alpha_5 = [1 3 1 0 3 2 1 9 14 6 11 29 22 25 76];
    dfree_7 = 22;
    alpha_7 = [1 0 3 0 1 0 3 0 3 0 9 0 14 0];
    dfree_9 = 28;
    alpha_9 = [1 0 0 3 0 0 1 0 3 0 1 2 0 9 0];
    
elseif cfg == 2 %With polys [133, 171]
    CODE_RATE = 1/2; 
    GENERATING_POLYS = [133 171]; %Rate 1/2
    CONSTRAINT_LENGTH = 6; 
    k = 980;%960;
    n_p = 32;%14;
    m = 6;
    alpha = [11 0 38 0 193 0 1331 0 7275 0];
    dfree = 10;
    
    %For HARQII
    dfree_3 = 13;
    alpha_3 = [1 1 5 6 9 21 35 50 88 203 339 691];
    dfree_5 = 23;
    alpha_5 = [1 1 4 3 2 4 8 15 10 6 24 41 45 54];
    dfree_7 = 33;
    alpha_7 = [1 1 4 3 1 1 1 3 8 15 10 1 0 5 24];
    dfree_9 = 43;
    alpha_9 = [1 1 4 3 1 1 0 0 1 3 8 15 10 1 0];
    
else
    error('Invalid input to function.')
end

%Define Q-function inline function: Q(x) = 0.5*erfc(x\sqrt(2))
Q = inline('1/2.*erfc(sqrt(factor.*EbNo)./sqrt(2))','EbNo','factor'); %P_b for BPSK when factor=2

%Compute coded BPSK theoretical BER for K = 4, [15,17]
%factor = 2;
%alpha = [1 3 5];
%beta = [2 7 18];
%dfree = 6;
%P_b_sdd = beta(1).*Q(ebno,2*CODE_RATE*dfree) + beta(2).*Q(ebno,2*CODE_RATE*(dfree+1)) + beta(3).*Q(ebno,2*CODE_RATE*(dfree+2));


%% ARQ Throughput

Tr_ARQ = 1./(1-Q(ebno,2)).^(k+n_p);
Thr_ARQ = 1./Tr_ARQ .* (k./(k+n_p));


%% HARQ Type I Throughput

P_E = 0;
for idx=1:length(alpha)
    P_E = P_E + alpha(idx).*Q(ebno,2*(dfree+idx-1));
end 
Tr_I = 1./(1-P_E).^(k+n_p); %Assumes l = 1
Thr_I = 0.5./Tr_I .* (k./(k+n_p+m)); %Assumes l = 1



%% HARQ Type II Throughput
R = 1 - (1 - Q(ebno,2)).^(k+n_p + m); %Assumes l = 1

P_E_2 = 0;
for idx=1:length(alpha)
    P_E_2 = P_E_2 + alpha(idx).*Q(ebno,2*(dfree+idx-1));
end 
P_D_2 = 1 - (1-P_E_2).^(k+n_p); %Assumes l = 1

P_E_3 = 0;
for idx=1:length(alpha_3)
    P_E_3 = P_E_3 + alpha_3(idx).*Q(ebno,2*(dfree_3+idx-1));
end 
P_D_3 = 1 - (1-P_E_3).^(k+n_p); %Assumes l = 1

P_E_5 = 0;
for idx=1:length(alpha_5)
    P_E_5 = P_E_5 + alpha_5(idx).*Q(ebno,2*(dfree_5+idx-1));
end 
P_D_5 = 1 - (1-P_E_5).^(k+n_p); %Assumes l = 1

P_E_7 = 0;
for idx=1:length(alpha_7)
    P_E_7 = P_E_7 + alpha_7(idx).*Q(ebno,2*(dfree_7+idx-1));
end 
P_D_7 = 1 - (1-P_E_7).^(k+n_p); %Assumes l = 1

P_E_9 = 0;
for idx=1:length(alpha_9)
    P_E_9 = P_E_9 + alpha_9(idx).*Q(ebno,2*(dfree_9+idx-1));
end 
P_D_9 = 1 - (1-P_E_9).^(k+n_p); %Assumes l = 1


P_D = P_D_2 + P_D_3 + P_D_5 + P_D_7 + P_D_9;
Tr_II = 1 + R + P_D;
Thr_II = 1./Tr_II .* (k./(k+n_p+m)); %Assumes l = 1




%% Plot

%Fix approximations of HARQII to match ARQ if ARQ has better performance
for idx=1:length(Thr_II)
    if Thr_ARQ(idx) > Thr_II(idx)
        Thr_II(idx) = Thr_ARQ(idx);
    end
end

%Plot on log scale
figure;
plot(EBNO,Thr_ARQ,'-ks',EBNO,Thr_I,'-r*',EBNO,Thr_II, '-bo')
axis([min(EBNO) max(EBNO) 0 1])
legend('ARQ','Type I HARQ upper bound','Type II HARQ upper bound','Location','NorthWest')
xlabel('Eb/No (dB)')
ylabel('Throughput')
title('Throughput for ARQ, Type I HARQ, and Type II HARQ with code combining') %assumes convolutional coding with soft decisions
