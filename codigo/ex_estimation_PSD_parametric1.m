%% PSD Estimate of a multichannel signal

% Create a multichannel signal consisting of three sinusoids in additive 
% $N(0,1)$ white Gaussian noise. The sinusoids' frequencies are 100 Hz, 
% 200 Hz, and 300 Hz. The sampling frequency is 1 kHz, and the signal has 
% a duration of 1 s.
clear, clc, close all

rng default % Set the random number generator to the default settings for reproducible results

fs = 1000;
dt = 1/fs;
t = 0:dt:1-dt;
f = 100; %[100; 200; 300];
x = cos(2*pi*f*t)' + randn(length(t), length(f));

% Estimate the PSD of the signal using a 12th-order autoregressive model. 
% Use the default DFT length. Plot the estimate.
morder = 12;

%% Burg's method
figure; pburg(x,morder,[],fs)

%[Pxx_burg,F_burg] = pburg(x,morder,[],Fs);
%figure
%plot(F_burg,10*log10(Pxx_burg));
%xlabel('frequency [Hz]')
%ylabel('power/frequency [dB/Hz]')
%legend('pburg PSD Estimate')

%% Covariance method
figure; pcov(x,morder,[],fs)

%% Modified covariance method
figure; pmcov(x,morder,[],fs)

%% Yule-Walker method
figure; pyulear(x,morder,[],fs)
