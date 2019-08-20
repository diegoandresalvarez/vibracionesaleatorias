%% PSD Estimate of an AR(4) Process
clear, clc, close all

% Create a realization of an AR(4) wide-sense stationary random process
A = [1 -2.7607 3.8106 -2.6535 0.9238];

% Obtain the frequency response and plot the PSD of the system.
[HH,FF] = freqz(1,A,[],1);

figure
plot(FF,20*log10(abs(HH)))

xlabel('Frequency (Hz)')
ylabel('PSD (dB/Hz)')

% Create a realization of the AR(4) random process. Set the random number 
% generator to the default settings for reproducible results. The 
% realization is 1000 samples in length. Assume a sampling frequency of 
% 1 Hz. Compare the PSD estimates with the true PSD.
rng default

x = randn(1000,1);
y = filter(1,A,x);


%% Determination of the order of the model
[a,e,k] = arburg(y, 12);    % Se requieren 4 coeficientes para pburg
% [a,e] = arcov (y, 12);    % NO APLICA
% [a,e] = armcov(y, 12);    % NO APLICA
% [a,e,k] = aryule(y, 20);  % Se requieren 11 coeficientes para aryule

figure
stem(k,'filled')
title('Reflection Coefficients')
xlabel('Model Order')

% The reflection coefficients decay to zero after order 4. This indicates 
% an AR(4) model is most appropriate.
%}

order = 4;     % of the AR used to produce the PSD estimate
nfft  = 1024;
fs    = 1;

%% Burg's method
[Pxx_burg,F_burg] = pburg(y,order,nfft,fs);
figure
plot(FF,20*log10(abs(HH)), F_burg,10*log10(Pxx_burg));
xlabel('frequency [Hz]')
ylabel('power/frequency [dB/Hz]')
legend('True Power Spectral Density','pburg PSD Estimate')

%% Covariance method
[Pxx_cov,F_cov] = pcov(y,order,nfft,fs);
figure
plot(FF,20*log10(abs(HH)), F_cov,10*log10(Pxx_cov));
legend('True Power Spectral Density','pcov PSD Estimate')

%% Modified covariance method
[Pxx_mcov,F_mcov] = pmcov(y,order,nfft,fs);
figure
plot(FF,20*log10(abs(HH)), F_mcov,10*log10(Pxx_mcov));
legend('True Power Spectral Density','pmcov PSD Estimate')

%% Yule-Walker method
[Pxx_yulear,F_yulear] = pyulear(y,order,nfft,fs);
figure
plot(FF,20*log10(abs(HH)), F_yulear,10*log10(Pxx_yulear));
legend('True Power Spectral Density','pyulear PSD Estimate')

%% All methods
figure
plot(...
   FF,       20*log10(abs(HH)), ...
   F_burg,   10*log10(Pxx_burg), ...
   F_cov,    10*log10(Pxx_cov), ...
   F_mcov,   10*log10(Pxx_mcov), ...
   F_yulear, 10*log10(Pxx_yulear));
legend('True Power Spectral Density', ...
   'pburg PSD Estimate', ...
   'pcov PSD Estimate', ...
   'pmcov PSD Estimate', ...
   'pyulear PSD Estimate');
