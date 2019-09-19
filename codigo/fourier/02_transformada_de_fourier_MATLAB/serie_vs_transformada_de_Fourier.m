%% Comparación de la serie y de la transformada de Fourier
% Aquí se está analizando un escalón entre -tau/2 y tau/2
% El escalón sería un f = heaviside(t+tau/2) - heaviside(t-tau/2);
%
%                                  ^ f(t)
%                                  |
%                            ------1------
%                            .     |     .
%                            .     |     .
%                            .     |     .
% -----------|---------------|-----|-----|---------------|-------------> t
%          -T/2           -tau/2   0  +tau/2           +T/2

%% Parametros
wmax = 20;                      % frecuencia angular máxima para la T de F
T    = 50;                      % periodo para la serie de Fourier

dw = 2*pi/T;                    % incremento de n para la serie de Fourier
N = floor(wmax/dw);             % número de términos de la serie de Fourier
                                % que estarán en [-wxmax, +wmax]
n = -N:N;
w = linspace(-wmax,+wmax,5000); % frecuencias angulares para la transformada

%% se define y calcula la serie y la tranformada de Fourier
tau = 1;                            % el escalón está entre -tau/2 y tau/2
%{
syms t tau T n w
%assume(T>tau)
assume(tau>0)
f = heaviside(t+tau/2) - heaviside(t-tau/2);
cn  = simplify((1/T)*int(f*exp(-1j*(2*pi*n/T)*t), t, -tau/2, tau/2))
Fw1 = simplify(int(f*exp(-1j*w*t), t, -tau/2, tau/2))
Fw2 = simplify(fourier(f,t,w))
%}
cn = (tau/T)*sinc(pi*n*tau/T);  % serie
Fw = tau*sinc(w*tau/2);         % transformada

%% Se dibuja la serie vs la transformada de Fourier
figure
% espectro de amplitud
subplot(2,1,1);
hold on;
stem(dw*n,T*abs(cn));   
plot(w, abs(Fw),'r-');
xlabel('w');
ylabel('Amplitud: T*|c_n|, |F(w)|')
title('Espectro de Fourier: serie vs transformada')

% espectro de fase
subplot(2,1,2);
hold on;
stem(dw*n,angle(cn));
plot(w, angle(Fw),'r-');
xlabel('w');
ylabel('Fase: angle(c_n), angle(F(w)')

%% Bye, bye!