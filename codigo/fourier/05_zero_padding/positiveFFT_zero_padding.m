function [X,freq]=positiveFFT_zero_padding(x,Fs,N)
% Plots the one-sided spectrum
% x is the signal that is to be transformed
% Fs is the sampling rate
% N is the number of points returned in the FFT result

% WHO: Quan Quach on 02/22/2008 (www.blinkdagger.com)

k = 0:N-1;                % create a vector from 0 to N-1
T = N/Fs;                 % get the frequency interval
freq = k/T;               % create the frequency range
X = fft(x,N)/length(x);   % normalize the data

% only want the first half of the FFT, since it is redundant
cutOff = ceil(N/2); 

% take only the first half of the spectrum
X = X(1:cutOff);
freq = freq(1:cutOff);

% Because we are discarding the negative values, we need to double everything.
% The only exception is at DC (frequency = 0), which should stay the same.
% Ver: http://en.wikipedia.org/wiki/DC_offset
DC = X(1); % DC is the mean value of the waveform
X = 2*X;
X(1) = DC;

return;
