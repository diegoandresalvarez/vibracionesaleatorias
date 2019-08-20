clear all; close all; clc

fo = 4;               % frequency of the sine wave
Fs = 100;             % sampling rate
Ts = 1/Fs;            % sampling time interval
t = 0:Ts:1-Ts;        % sampling period
y = 2*sin(2*pi*fo*t); % the sine curve

nextPower = nextpow2(length(y));
NFFT1 = 2^(nextPower);   [a1,b1] = centeredFFT_zero_padding(y,Fs,NFFT1);
NFFT2 = 2^(nextPower+1); [a2,b2] = centeredFFT_zero_padding(y,Fs,NFFT2);
NFFT3 = 2^(nextPower+4); [a3,b3] = centeredFFT_zero_padding(y,Fs,NFFT3);

figure
subplot(3,1,1);  stem(b1,abs(a1)), axis([-10 10 0 1.2])
ylabel('Magnitude'); title(sprintf('FFT of Input Signal Using N = %d',NFFT1)); grid

subplot(3,1,2);  stem(b2,abs(a2)), axis([-10 10 0 1.2])
ylabel('Magnitude'); title(sprintf('FFT of Input Signal Using N = %d',NFFT2)); grid

subplot(3,1,3);  stem(b3,abs(a3)), axis([-10 10 0 1.2])
ylabel('Magnitude'); title(sprintf('FFT of Input Signal Using N = %d',NFFT3)); grid
xlabel('Frequency (Hz)')

% Now we will verify that in fact we are doing zero-padding:
Y1 = fft(y,NFFT1);  y1 = ifft(Y1);
Y2 = fft(y,NFFT2);  y2 = ifft(Y2);
Y3 = fft(y,NFFT3);  y3 = ifft(Y3);

figure
subplot(3,1,1); plot(y1); xlim([0 NFFT3])
title(sprintf('Input Signal Padded with Zeros up to N = %d',NFFT1)); ylabel('Amplitude')
grid

subplot(3,1,2); plot(y2); xlim([0 NFFT3])
title(sprintf('Input Signal Padded with Zeros up to N = %d',NFFT2)); ylabel('Amplitude')
grid

subplot(3,1,3); plot(y3); xlim([0 NFFT3]); 
title(sprintf('Input Signal Padded with Zeros up to N = %d',NFFT3)); ylabel('Amplitude')
xlabel('Sample Number')
grid