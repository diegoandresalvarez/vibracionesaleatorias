function [X,freq] = centeredFFT_zero_padding(x,Fs,N)
% Plots the two-sided spectrum
% x is the signal that is to be transformed
% Fs is the sampling rate
% N is the number of points returned in the FFT result

% WHO: Quan Quach on 02/22/2008 (www.blinkdagger.com)

% generate the frequency axis
if mod(N,2)==0
    k = -N/2:N/2-1;       % N even (par)
else
    k = -(N-1)/2:(N-1)/2; % N odd (impar)
end
T = N/Fs;
freq = k/T;               % the frequency axis

% takes the fft of the signal, and adjusts the amplitude accordingly
X = fft(x,N)/length(x);   % normalize the data
X = fftshift(X);          % shifts the fft data so that it is centered

return;
