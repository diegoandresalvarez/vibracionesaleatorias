% From: Carlos Adrian Vargas Aguilera
% Date: 24 Jun, 2009 22:45:03
% https://www.mathworks.com/matlabcentral/newsreader/view_thread/250977

clear, clc, close all

%% Se configuran los parametros de la FT
t1 = -10;  % el eje del tiempo va entre t1 y t2
t2 =  50;
N = 4096;  % number of points (debe ser par)

%% Se definen las funciones
% "square function" and its FT
%T = 1; % square width                % corra con t1=-3, t2=3 y N = 4096
%A = 1; % square amplitudes
%g  = @(t) A*(heaviside(t+T/2) - heaviside(t-T/2));
%Fg = @(f) A*T*sinc(f*T); 

g  = @(t) exp(-t).*(t >= 0);         % corra con t1=-10, t2=50 y N = 4096
Fg = @(f) 1./(1 + 2*pi*1j*f);

%g  = @(t) exp(-t.^2);                % corra con t1=-10, t2=30 y N = 4096
%Fg = @(f) sqrt(pi)*exp(-(pi*f).^2);

%g  = @(t) sinc(t);                   % corra con t1=-30, t2=30 y N = 4096
%Fg = @(f) rectpuls(f);

%g  = @(t) sin(t.^2);                 % corra con t1=-50, t2=50 y N = 4096
%Fg = @(f) -sqrt(pi)*sin((pi*f).^2 - pi/4);

%% Se definen los rangos de tiempo y de frecuencia
% OJO en esta implementacion debemos tener el cero en el rango t ... por
% eso el número par de datos en N (por el ajuste que se hace abajo)
dt = (t2-t1)/N;  fs = 1/dt; dfs = fs/N;
t  = t1:dt:(t2-dt);
f = -fs/2:dfs:(fs/2-dfs);

%% Se hace la aproximacion de la FT con la FFT
F = fftshift(fft(g(t))*dt); % dt because of the "integration"

% la aproximacion esta se haciendo con una integral_0^(t2-t1) XXX(t) dt y 
% la funcion debe tener una integral_t1^t2 XXX(t) dt. Por lo tanto, se 
% mueve en el tiempo t1, para que los limites de integracion cuadren y 
% queden integral_0^(t2-t1) XXX(t) dt
% recuerde que F{x(t-t1)} = exp(-j*2*pi*f*t1)*X(f)
F = exp(-1j*2*pi*f*t1).*F;

%% Plots
figure
subplot(211)
plot(t,g(t))
subplot(212)
hold on
Fgf = Fg(f);
plot(f,real(Fgf),'r-', f,real(F),'r.')
plot(f,imag(Fgf),'b-', f,imag(F),'b.')
legend('Re(F{g})','Re(FFT)','Im(F{g})', 'Im(FFT)')

%% Ahora calculamos la IFT y la graficamos
gt = ifft(ifftshift(exp(+1j*2*pi*f*t1).*F)/dt, 'symmetric');
figure
hold on
Fgf = Fg(f);
plot(t,real(g(t)),'r-', t,real(gt),'r.')
plot(t,imag(g(t)),'b-', t,imag(gt),'b.')
legend('Re(g(t))','Re(IFFT)','Im(g(t))', 'Im(IFFT)')
