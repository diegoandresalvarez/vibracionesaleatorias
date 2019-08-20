clear, clc, close all

%% Se define la senal
fo1 = 15.5;               % frecuencia de la onda sinusoidal 1
%fo1 = 15;                % frecuencia de la onda sinusoidal 1
fo2 = 20.5;               % frecuencia de la onda sinusoidal 2
%fo2 = 20;                % frecuencia de la onda sinusoidal 2
Fs = 100;                 % frecuencia de muestreo (Hz)
Ts = 1/Fs;                % periodo de muestreo (s)
t = 0:Ts:1-Ts;            % tiempos de muestreo
n = length(t);            % numero de muestras

y = 1*sin(2*pi*fo1*t) + 0.01*sin(2*pi*fo2*t);  % produce filtracion espectral (spectral leakage)

%% Se dibuja la curva sinusoidal en el tiempo
figure;
plot(t,y)
xlabel('tiempo (segundos)')
ylabel('y(t)')
title('Onda senosoidal')
grid

ventana = {
@sigwin.barthannwin       %   1. Modified Bartlett-Hanning Window
@sigwin.bartlett          %   2. Bartlett Window
@sigwin.blackman          %  *3. Blackman Window
@sigwin.blackmanharris    %   4. Blackman-Harris Window
@sigwin.bohmanwin         %   5. Bohman Window
@sigwin.chebwin           %   6. Dolph-Chebyshev Window
@sigwin.flattopwin        %  *7. Flat Top Window 
@sigwin.gausswin          %   8. Gaussian Window
@sigwin.hamming           %  *9. Hamming Window
@sigwin.hann              % *10. Hann (Hanning) Window
@sigwin.kaiser            %  11 .Kaiser Window
@sigwin.nuttallwin        %  12. Nuttall defined 4–term Blackman-Harris Window 
@sigwin.parzenwin         %  13. Parzen Window
@sigwin.rectwin           %  14. Rectangular Window
@sigwin.taylorwin         %  15. Taylor Window
@sigwin.triang            %  16. Triangular Window
@sigwin.tukeywin          %  17. Tukey Window
};

NVENT = 3;
try
   objwin = ventana{NVENT}(n);
   objwin.SamplingFlag = 'periodic';
   disp(['Utilizando la version periodica de ' objwin.Name])   
catch
   objwin = ventana{NVENT}(n);
end
win = generate(objwin);
y_win = y.*win';

%% Se dibuja la curva sinusoidal en el tiempo
figure;
plot(t, y_win)
xlabel('tiempo (segundos)')
ylabel('y(t)*win(t)')
title('Onda senosoidal ventaneada')
grid

%% Espectro positivo
nextPower = nextpow2(n);
NFFT = 2^(nextPower+3);
[YfreqDomain,    frequencyRange]     = positiveFFT_zero_padding(y,Fs,NFFT);
[YfreqDomain_win,frequencyRange_win] = positiveFFT_zero_padding(y_win,Fs,NFFT);
%[Yfreq_solowin,frequency_solowin]    = positiveFFT_zero_padding(win,Fs,NFFT);

% se normaliza el espectro teniendo en cuenta la ventana
% sum(win) = coherent gain factor
YfreqDomain_win = YfreqDomain_win*n/sum(win); 

% figure
% hold on 
% plot(frequency_solowin, 20*log10(abs(Yfreq_solowin)/max(abs(Yfreq_solowin))), 'b');     % plot the magnitude
% xlabel('Freq (Hz)')
% ylabel('Magnitude [dB]')
% grid minor
% title(objwin.Name)
% ylim([-100 0]);

wvtool(win);

figure
subplot(3,1,1)
hold on
plot(frequencyRange,     abs(YfreqDomain), 'b');     % plot the magnitude
plot(frequencyRange_win, abs(YfreqDomain_win), 'r'); % plot the magnitude
xlabel('Freq (Hz)')
ylabel('Magnitude')
grid
legend('Rectangular', objwin.Name)
plot([fo1, fo1], ylim, 'c', [fo2, fo2], ylim, 'c');

subplot(3,1,2)
hold on
plot(frequencyRange,     20*log10(abs(YfreqDomain)/max(abs(YfreqDomain))), 'b');     % plot the magnitude
plot(frequencyRange_win, 20*log10(abs(YfreqDomain_win)/max(abs(YfreqDomain_win))), 'r'); % plot the magnitude
xlabel('Freq (Hz)')
ylabel('Magnitude [dB]')
grid
legend('Rectangular', objwin.Name)
ylim([-100 0]); % corte en -100 dB ya que los ceros van hasta -Inf
plot([fo1, fo1], ylim, 'c', [fo2, fo2], ylim, 'c');

subplot(3,1,3) 
hold on;
plot(frequencyRange,     unwrap(angle(YfreqDomain)), 'b');
plot(frequencyRange_win, unwrap(angle(YfreqDomain_win)), 'r'); % plot the magnitude
xlabel('Freq (Hz)')
ylabel('Phase (rad)')
grid
legend('Rectangular', objwin.Name)
plot([fo1, fo1], ylim, 'c', [fo2, fo2], ylim, 'c');
