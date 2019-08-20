%% PSD Estimate

% Create signal consisting of three sinusoids in additive 
% $N(0,1)$ white Gaussian noise. The sinusoids' frequencies are 100 Hz, 
% 150 Hz, and 190 Hz. The sampling frequency is 1 kHz, and the signal has 
% a duration of 1 s.
clear, clc, close all

% Set the random number generator to the default settings for reproducible 
% results
rng default 

fs = 1000; % inserte un numero par
dt = 1/fs;
t = 0:dt:100-dt;
N = length(t);
f = [100; 125; 190];
x = 0.9*sin(2*pi*f(1)*t + 1)' + ...
    0.5*sin(2*pi*f(2)*t + 2)' + ...
    0.05*sin(2*pi*f(3)*t + 3)' + ...
   randn(N, 1);

%% Obtain the periodogram using the fft
%window = rectwin(N); 
window = hann(N);

xdft = fft(x.*window);
xdft = xdft(1:N/2+1);
psdx = dt*abs(xdft).^2/sum(window.^2);

% Multiply the positive and negative frequencies by a factor of 2. 
% Zero frequency (DC) and the Nyquist frequency do not occur twice
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/N:fs/2;

figure
plot(freq, 10*log10(psdx))
grid on
title('Periodogram using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/frequency (dB/Hz)')

%% Periodogram estimate
nfft = length(x);
figure; periodogram(x,window,nfft,fs)
psd_periodogram = periodogram(x,window,nfft,fs);
% Observe que ambos metodos producen la misma salida
maxerr = max(psdx - psd_periodogram)

% Notas sobre la funcion periodogram():
% Cuando no se especifica "window", usa por defecto la rectwin()
% x y window deben tener la misma longitud

%% Welch's method
% Repeating the experiment several times and averaging would remove the 
% spurious spectral peaks and yield more accurate power measurements. You 
% can achieve this averaging using the pwelch function. This function will 
% take a large data vector, break it into smaller segments of a specified 
% length, compute as many periodograms as there are segments, and average 
% them. As the number of available segments increases, the pwelch function 
% will yield a smoother power spectrum (less variance) with power values 
% closer to the expected values.
nfft   = 1000;
window = 1000; % usa ventanna de Hamming
noverlap = []; % usa 50% de window como overlap
figure; pwelch(x,window,noverlap,nfft,fs)

% Este es aproximadamente el promedio de floor(N/length(window)) ventanas

% As seen on the plot, pwelch effectively removes all the spurious frequency 
% peaks caused by noise. The spectral component at 190 Hz that was buried 
% in noise is now visible. Averaging removes variance from the spectrum and 
% this effectively yields more accurate power measurements.

%% Measuring Total Average Power
% Primero se mide en el dominio del tiempo
pwr = sum(x.^2)/N % in watts

% Luego se mide en el dominio de la frecuencia
% length(window) = tamano del vector al que se le sacara la fft
% noverlap = numero de muestras a traslapar
noverlap = 0;
window = rectwin(nfft);
[Pxx_welch,F_welch] = pwelch(x,window,noverlap,nfft,fs);
pwr1 = sum(Pxx_welch) % in watts

% Ambas cantidades son iguales (Parseval) si no se usa ventana = rectwin(N)

% figure
% plot(F_welch,10*log10(Pxx_welch));
% legend('pwelch PSD Estimate')

%% Thompson's multitaper PSD estimation method
% Ver detalles en: 
% http://www.mathworks.com/help/signal/ref/pmtm.html
nw = [];
figure; pmtm(x,nw,nfft,fs)

return
