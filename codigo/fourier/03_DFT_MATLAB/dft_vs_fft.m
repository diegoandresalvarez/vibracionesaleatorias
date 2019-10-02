% Programa para comparar la implementacion de la DFT y la IDFT con los
% comandos fft e ifft

clear, clc, close all

x = [2 7 -5 4 -9 2 -4 9];  % vector al que le sacaremos la DFT
N = length(x);
X = zeros(size(x));     % aqui se almacenara la DFT de x

%% Se calcula la DFT. Forma 1:
for k = 0:N-1
    for n = 0:N-1
        X(k +1) = X(k +1) + x(n +1)*exp(-j*2*pi*k*n/N);
    end
end

%% Se calcula la DFT. Forma 2:
n = 0:N-1;
X2 = zeros(size(x));     % aqui se almacenara la DFT de x
for k = 0:N-1
   X2(k +1) = sum(x.*exp(-j*2*pi*k*n/N));
end

%% Se grafican los resultados
t = 0:N-1;
subplot(3,2,[1 2])
stem(t,x);
xlabel(sprintf('Time (s), N = %d', N))
ylabel('Amplitude');
title('Time domain - Input sequence')

subplot(323)
stem(t,abs(X))
xlabel('Frequency');
ylabel('|X(k)|');
title('Frequency domain - Magnitude response')

subplot(325)
stem(t,angle(X))
xlabel('Frequency');
ylabel('Phase');
title('Frequency domain - Phase response')

subplot(324)
stem(t,real(X))
xlabel('Frequency');
ylabel('Real{X}');
title('Frequency domain - Real part')

subplot(326)
stem(t,imag(X))
xlabel('Frequency');
ylabel('Imag{X}');
title('Frequency domain - Imaginary part')


%% Se imprimen los resultados de DFT
disp('*** *** DFT *** ***')
disp('X = ');        disp(X)         % to check X(k)
disp('abs(X) = ');   disp(abs(X))    % to check |X(k)|
disp('angle(X) = '); disp(angle(X))  % to check phase

%% Ahora lo mismo pero con el comando fft
disp('*** *** fft *** ***')
fft_x = fft(x);
disp('fft(x) = ');        disp(fft_x)         % to check X(k)
disp('abs(fft(x)) = ');   disp(abs(fft_x))    % to check |X(k)|
disp('angle(fft(x)) = '); disp(angle(fft_x))  % to check phase

%% AHORA LA TRANSFORMADA INVERSA DISCRETA DE FOURIER
disp('*** *** IDFT vs ifft *** ***')
%% Se calcula la IDFT. Forma 1:
idft_X = zeros(size(x));
X = fft_x;           % fft provee una estimacion mas precisa (comente/descomente)
for k = 0:N-1
    for n = 0:N-1
        idft_X(k+1) = idft_X(k+1) + X(n+1)*exp(j*2*pi*k*n/N);
    end
end
idft_X = idft_X/N;


%% Se calcula la DFT. Forma 2:
k = 0:N-1;
idft_X2 = zeros(size(x));     % aqui se almacenara la DFT de x
for n = 0:N-1
   idft_X2(n +1) = sum(X.*exp(j*2*pi*k*n/N));
end
idft_X2 = idft_X2/N;

%% Se imprimen los resultados
disp('x  = ');        disp(x)
disp('idft_X  = ');   disp(idft_X)   
disp('ifft(X) = ');   disp(ifft(X))