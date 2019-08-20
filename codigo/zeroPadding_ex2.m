clear, clc, close all

f1 = 4.0;                                    % frequency of the sine wave
f2 = 4.5;                                    % MODIFIQUE A 4.1, 4.3, 4.5, 4.555
Fs = 100;                                    % sampling rate
dt = 1/Fs;                                   % sampling time interval
t = 0:dt:2-dt;                               % sampling period
n = length(t);                               % number of samples
y = 200*sin(2*pi*f1*t) + 200*sin(2*pi*f2*t); % the sine curve

figure
subplot(3,1,1); 
plot(t,y)
title('Sample Signal'); xlabel('Time (seconds)'); ylabel('Amplitude'); 
grid

subplot(3,1,2)
[a,b] = positiveFFT(y,Fs);
stem(b,abs(a))
title('FFT of Sample Signal with No Zero Padding');
xlabel('Freq (Hz)'); ylabel('Magnitude'); grid; xlim([0 10])

subplot(3,1,3)
NFFT = 2^(nextpow2(length(y))+3);
[a,b] = positiveFFT_zero_padding(y,Fs,NFFT);
stem(b,abs(a))
title(sprintf('FFT of Sample Signal: Zero Padding up to N = %d', NFFT))
xlabel('Freq (Hz)'); ylabel('Magnitude'); grid; xlim([0 10])

