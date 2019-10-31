clear; clc%; close all

%% Generate the signal
% Generate a linear chirp, x, sampled at 1 kHz for 2 seconds. The 
% frequency of the chirp is 100 Hz initially and crosses 200 Hz at t = 1 s.

fs = 1000; % Hz
dt = 1/fs;
t = 0:dt:2;

x = chirp(t, 100, 1, 200);

%% Compute and display the spectrogram of x.
% [s,f,t] = spectrogram(x,window,noverlap,f,fs)
% Divide the signal into sections of length 128, windowed with a Hann window
window = hann(128,'periodic');

% Specify 120 samples of overlap between adjoining sections.
% noverlap debe ser menor que length(window)
noverlap = 120; % samples

% Use nfft points to calculate the FFT
nfft = 2^10;
% the number of frequencies will be 
nfreq = floor(nfft/2+1);
% the number of time instants will be 
ntime = floor((length(x)-noverlap)/(length(window)-noverlap));

% [s,f,t] = spectrogram(x, window, noverlap, nfft, fs);
% size(s)==[nfreq ntime], length(f)==nfreq, length(t)==ntime

figure
% el 'yaxis' es para que time=eje horiz, freq=eje vert
spectrogram(x, window, noverlap, nfft, fs, 'yaxis');
title('Spectrogram of linear chirp')

% track the chirp frequency by finding the maximum of the PSD at each of
% the ntime time points
[s, ff, tt, p] = spectrogram(x, window, noverlap, nfft, fs);
% s return the STFT as a matrix
% p returns the PSD as a matrix (one-sided periodograms)

[q,nd] = max(10*log10(p));
hold on
plot3(tt,ff(nd),q,'w', 'LineWidth', 4)
colorbar

%{
figure
surf(tt,ff,10*log10(abs(p)+eps),'EdgeColor','none')
xlim([tt(1) tt(end)])
colorbar
view(0,90)
xlabel('Time (secs)')
ylabel('Frequency (Hz)')
%}
