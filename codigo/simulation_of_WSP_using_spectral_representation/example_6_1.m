%% Simulation of weakly stationary stochastic processes using the spectral 
%  representation method
%
% Here, example 6.1 of Shinozuka and Deodatis (1991) is reproduced.

% Reference:
% Shinozuka, M. and Deodatis, G. (1991). 
% Simulation of Stochastic Processes by Spectral Representation. 
% ASME Applied Mechanics Reviews; 44(4):191-204.
% doi:10.1115/1.3119501

% WHO    WHAT                                WHEN
% DAAM   First algorithm                     January 31st, 2020
% DAAM - Diego Andres Alvarez Marin daalvarez@unal.edu.co

%%
clear, clc, close all

%% Definition of the PSD and its autocorrelation function
sigma = 1;                                                   % eq. 135
b     = 1; %sec                                              % eq. 135
Sf0f0 = @(w) (1/4)*sigma^2*b^3*w.^2.*exp(-b*abs(w));         % eq. 133
Rf0f0 = @(t) sigma^2*b^4*(b^2 - 3*t.^2)./((b^2 + t.^2).^3);  % eq. 132

%% Select the upper cut-off frequency wu
wu = 4*pi; % rad/sec                                         % eq. 136

%% Check whether wu is appropriate, according to eq. 41
if abs(integral(Sf0f0,0,wu)/integral(Sf0f0,0,inf)) < 1 - 0.001
   error('Please set a larger upper cut-off frequency wu')
end

%% Simulation of a realization of the stochastic process
N = 128;                                                     % eq. 137

seed = rng;  % store the seed of the random number generator
tic
[f1,t1,T0_1] = simu_from_PSD_SUM(Sf0f0, N, wu, 10*N);
time1 = toc;
fprintf('The time spent by the "sum of cosines" method is %f s.\n', time1);

rng(seed)  % reset the seed of the random number generator to its previous state
tic
[f2,t2,T0_2] = simu_from_PSD_FFT(Sf0f0, N, wu, 10*N);
time2 = toc;
fprintf('The time spent by the FFT method is %f s.\n', time2);

% Observe that both codes produce the same realization of the stochastic
% process; 
figure
plot(t1,f1,'b-.', t2, f2,'r:');
legend('simu_from_PSD_SUM()', 'simu_from_PSD_FFT()', 'Interpreter', 'none')
xlabel('time [s]')
ylabel('')

disp('Note that simu_from_PSD_SUM() is slower than simu_from_PSD_FFT()')
disp('even though f1 is shorter than f2')
fprintf('time1/time2 = %f\n', time1/time2);
length_f1 = length(f1)
length_f2 = length(f2)

%% Generate an ensemble of size_ensemble realizations
M = length(f2);
size_ensemble = 100;
f3 = zeros(size_ensemble,M);
for i = 1:size_ensemble
   [f3(i,:),t3,T0_3] = simu_from_PSD_FFT(Sf0f0, N, wu, M);
end

%% Plot the autocorrelation function and compare it to the temporal and the 
%% ensemble autocorrelation function
dt = t2(2) - t2(1); % recalculate time step
tau = 0:dt:T0_2/3;

% Calculation of the temporal autocorrelation function (eq. 105)
Rffi = Rf0f0_spectral_representation(Sf0f0, N, wu, tau);

% Plot the results
figure
plot(tau, Rf0f0(tau), 'b-.', tau, Rffi ,'r:');
xlim([0 T0_2/3]);
legend('R_{f0f0}(\tau) - target autocorrelation function',       ...
       'R_{ff}^{(i)}(\tau) - temporal autocorrelation function', ...
       'Location', 'Best');
xlabel('Time lag \tau (sec)');
title('Autocorrelation function: target vs temporal autocorrelation');

%% Estimate the temporal and the ensemble autocorrelation function and 
%% compare it to the true autocorrelation function
% Calculation of the temporal autocorrelation function (using the one realization)
[Rffi_temporal, lags_t] = xcorr(f2, 'unbiased');

% Calculation of the ensemble autocorrelation function (using the size_ensemble realizations)
[Rff_ensemble, lags_e] = xcorr_ensemble(f3);

% Plot the results
figure
plot(tau, Rf0f0(tau), '.', lags_t*dt, Rffi_temporal ,':', lags_e*dt, Rff_ensemble ,'-');
xlim([0 T0_2/3]);
legend('R_{f0f0}(\tau) - target autocorrelation function',       ...
       'R_{ff}^{(i)}(\tau) - temporal autocorrelation function', ...
       sprintf('R_{ff}(\tau) - ensemble autocorrelation function (%d realizations)', size_ensemble), ...                             
       'Location', 'Best');
xlabel('Time lag \tau (sec)');
title('Target vs temporal vs ensemble autocorrelation function');

%% Plot the PSD and compare it to the PSD estimation techniques
dt = t2(2) - t2(1);
fs = 1/dt;
w = linspace(0,wu,200);

%% Estimation of the PSD using the equation
%                     E[|X(t,T)|^2]           
% Sf0f0(f) = lim     ---------------
%            T-> oo         T
%
%                           dt         sum_{m=0}^size_ensemble |DFT_m{x*window}[k]|^2
% Sf0f0(f_k) =aprox= -------------- * ------------------------------------------------
%                    sum(window.^2)                 size_ensemble

% Plot the reference PSD
figure
plot(w/(2*pi), 2*2*pi*Sf0f0(w), 'b-'); %One-sided PSD Gf0f0(f) [f = Hz]
xlim([0 wu/(2*pi)]);
xlabel('Frequency f [Hz]');
ylabel('One-sided PSD [1/Hz]');
title('One-sided PSD: G_{f0f0}(f)')
hold on;

% Obtain the periodogram of each realization of the ensemble using the fft
% and then average them
window = hann(M)'; % rectwin(M)'; 
xdft = fft(f3 .* repmat(window,size_ensemble, 1), [], 2);
tmp  = dt*mean(abs(xdft(:,1:M/2+1)).^2)/sum(window.^2);
% Multiply the positive and negative frequencies by a factor of 2. 
% Zero frequency (DC) and the Nyquist frequency do not occur twice
% tmp(1)   = Zero frequency -- DC offset
% tmp(end) = Nyquist frequency
average_Gff_periodogram = [ tmp(1) 2*tmp(2:end-1) tmp(end) ];

% Plot the results
f_periodogram = 0:fs/M:fs/2;
plot(f_periodogram, average_Gff_periodogram, 'r:');
grid on
title('Estimation of the one-sided PSD using the average of periodograms')
xlabel('Frequency (Hz)')
ylabel('Power/frequency (units^2/Hz)')
legend('G_{f0f0}(f) - target one-sided power spectral density',       ...
       sprintf('G_{ff}(f) - ensemble one-sided power spectral density (%d realizations)', size_ensemble), ...                             
       'Location', 'Best');


%% Estimation of the PSD using the periodogram
% Plot the reference PSD 
figure;
plot(w/(2*pi), 2*2*pi*Sf0f0(w), 'b-'); %One-sided PSD Gf0f0(f) [f = Hz]
xlim([0 wu/(2*pi)]);
xlabel('Frequency f [Hz]');
ylabel('One-sided PSD [1/Hz]');
title('One-sided PSD: G_{f0f0}(f)')
hold on;

xdft = fft(f2 .* window);
tmp  = dt*abs(xdft(:,1:M/2+1)).^2/sum(window.^2);
% Multiply the positive and negative frequencies by a factor of 2. 
% Zero frequency (DC) and the Nyquist frequency do not occur twice
% tmp(1)   = Zero frequency -- DC offset
% tmp(end) = Nyquist frequency
Gff_periodogram = [ tmp(1) 2*tmp(2:end-1) tmp(end) ];

% Plot the results
plot(f_periodogram, Gff_periodogram, 'r.')

%% Estimation of the PSD using the periodogram (alternative method)
[Gff_periodogram2, f_periodogram2] = periodogram(f2, window, M, fs);
plot(f_periodogram2, Gff_periodogram2, 'r-');

% Both methods produce the same answer:
maxerr = max(Gff_periodogram - Gff_periodogram2')


%% Estimation of the PSD using Welch's methods
nfft     = [];
window   = []; % usa ventanna de Hamming
noverlap = []; % usa 50% de window como overlap
[Gff_welch,f_welch] = pwelch(f2, window, noverlap, nfft, fs);
plot(f_welch, Gff_welch, 'g--');

%% Estimation of the PSD using Thompson's multitaper method
nw = [];
[Gff_mtm,f_mtm] = pmtm(f2, nw, nfft, fs);
plot(f_mtm, Gff_mtm, 'm-.')

legend('G_{f0f0}(f) - target one-sided power spectral density', ...
       'G_{ff}(f) - my periodogram function', ...                             
       'G_{ff}(f) - periodogram() function of MATLAB', ...                             
       'G_{ff}(f) - Welch''s method', ...                                    
       'G_{ff}(f) - Thompson''s multitaper method', ...                                           
       'Location', 'Best');
xlim([0 wu/(2*pi)]);
grid on
title('Estimation of the one-sided PSD using the periodogram')
xlabel('Frequency (Hz)')
ylabel('Power/frequency (units^2/Hz)')
