function [X,freq] = centeredFFT(x,Fs)
% Plots the two-sided spectrum
% x is the signal that is to be transformed
% Fs is the sampling rate

% WHO: Quan Quach on 02/22/2008 (www.blinkdagger.com)

N = length(x);

% generate the frequency axis
if mod(N,2)==0
    k = -N/2:(N/2-1);       % N even (par)
else
    k = -(N-1)/2:(N-1)/2; % N odd (impar)
end
% Lo anterior es igual a:
% k = floor(-N/2):floor((N-1)/2);

T = N/Fs; % = N*dt
freq = k/T;               % the frequency axis

% takes the fft of the signal, and adjusts the amplitude accordingly
X = fft(x)/N;             % normalize the data
X = fftshift(X);          % shifts the fft data so that it is centered

return;

