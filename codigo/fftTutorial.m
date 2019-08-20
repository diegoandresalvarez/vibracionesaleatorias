clear, clc, close all

%% Se define la senal
fo1 = 15;                 % frecuencia de la onda sinusoidal 1
fo2 = 20;                 % frecuencia de la onda sinusoidal 2
Fs = 100;                 % frecuencia de muestreo (Hz)
Ts = 1/Fs;                % periodo de muestreo (s)
t = 0:Ts:1-Ts;            % tiempos de muestreo
n = length(t);            % numero de muestras

y = 2*sin(2*pi*fo1*t) + 3*sin(2*pi*fo2*t + 200);
%y = 2*sin(2*pi*fo1*t) + 3*sin(2*pi*fo2*t + 200) + 1.5*randn(size(t)); 
%y = 2*exp(1i*2*pi*fo1*t);     % la curva sinusoidal compleja
%y = 2*sin(2*pi*1.005*fo1*t);  % produce filtracion espectral (spectral leakage)
%y = square(2*pi*4*t);         % se observan los armonicos

%% Se dibuja la curva sinusoidal en el tiempo
figure;
plot(t,y)
xlabel('tiempo (segundos)')
ylabel('y(t)')
title('Onda senosoidal')
grid

%% Plot the frequency spectrum using the MATLAB fft command
YfreqDomain = fft(y);     % DFT

% Plot the magnitude
figure;
subplot(2,1,1)
stem(abs(YfreqDomain)); 
xlabel('Sample Number')
ylabel('Magnitude')
title('Using the Matlab fft command')
grid

% Plot the phase
subplot(2,1,2) 
plot(unwrap(angle(YfreqDomain)));
%plot(angle(YfreqDomain));
xlabel('Sample Number')
ylabel('Phase (rad)')
grid

%% Espectro centrado
[YfreqDomain,frequencyRange] = centeredFFT(y,Fs);

figure
subplot(2,1,1)
stem(frequencyRange, abs(YfreqDomain)); % plot the magnitude
xlabel('Freq (Hz)')
ylabel('Magnitude')
title('Using the centeredFFT function')
grid

subplot(2,1,2) 
plot(frequencyRange, unwrap(angle(YfreqDomain)));
xlabel('Freq (Hz)')
ylabel('Phase (rad)')
grid

%% Espectro positivo
[YfreqDomain,frequencyRange] = positiveFFT(y,Fs);

figure
subplot(2,1,1)
stem(frequencyRange, abs(YfreqDomain)); % plot the magnitude
xlabel('Freq (Hz)')
ylabel('Magnitude')
title('Using the positiveFFT function')
grid

subplot(2,1,2) 
plot(frequencyRange, unwrap(angle(YfreqDomain)));
xlabel('Freq (Hz)')
ylabel('Phase (rad)')
grid
