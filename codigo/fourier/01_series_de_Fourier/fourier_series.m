% Este programa calcula y grafica las series de Fourier de una funcion dada

syms x P n N

%% Numero de terminos a calcular de la serie de Taylor
N = 10;

%% Se define la funcion s(x) y el periodo P
%s = cos(2*x);  P = 2*sym(pi);
s = sin(2*x);  P = 2*sym(pi);
%s = cos(2*x + sym(pi/4));  P = 2*sym(pi);
%s = sin(2*x + sym(pi/4));  P = 2*sym(pi);

%s = exp(-x); P = 2;

% Una funcion par tiene un espectro (c) real -> verifique mirando c
%s = abs(x);  P = 2;



% Observe en los dos siguientes ejemplos como el espectro se llena de ceros
% cuando se escoge como periodo un múltiplod el periodo fundamental. 
% Observe que los |c_n| y los arg(c_n) se conservan de la misma magnitud.
% 1)
%s = x; P = 2;
%
% 2)
%{
s = + heaviside(x+3)*heaviside(-1-x)*(x+2) ... 
    + heaviside(x+1)*heaviside(1-x)*x ...
    + heaviside(x-1)*heaviside(3-x)*(x-2); 
P = 6;

% Adicionalmente, del ejemplo 1): una funcion impar tiene un espectro 
% imaginario puro -> verifique mirando c
%}


%% Se definen los coeficientes
assume(n, 'integer'); % Se le informa a MATLAB que n es un entero
a = @(n) (2/P)*int(s*cos(2*pi*n*x/P), x, -P/2, P/2);
b = @(n) (2/P)*int(s*sin(2*pi*n*x/P), x, -P/2, P/2);

%% Se calcula la serie de Fourier
% S_N(x) = \frac{a_0}{2} + \sum_{n=1}^N\bigg[a_n\cos\bigg(\frac{2\pi n x}{P}\bigg) + b_n\sin\bigg(\frac{2\pi nx}{P}\bigg)\bigg]
sN = cell(N+1,1);
sN{1} = a(0)/2;
for n = 1:N
   sN{n+1} = sN{n} + a(n)*cos(2*pi*n*x/P) + b(n)*sin(2*pi*n*x/P);
end 

%% Se imprime y grafica la serie truncada
figure
for i = 1:N
   fprintf('S_%d(x) = \n', i);
   sympref('AbbreviateOutput', false);
   pretty(sN{i+1});
   sympref('AbbreviateOutput','default');   
   fprintf('\n')
   clf;
   fplot(sN{i+1}, [-P, P], 'b');
   hold on;
   fplot(s, [-P, P],'r');
   title(sprintf('Serie truncada de Fourier con N = %d', i));
   drawnow;
   pause(0.1);
end

%% ------------------------------------------------------------------------
%% Ahora hacemos lo mismo, pero con la serie de Fourier compleja

%% Se definen los coeficientes
cc = @(n) (1/P)*int(s*exp(-1j*2*pi*n*x/P), x, -P/2, P/2);

%% Se calcula la serie de Fourier compleja
% S_N(x) = \sum_{n=-N}^N c_n \exp\lef(\frac{j 2\pi n x}{P}\right)
sNC = cell(N+1,1);
c = zeros(2*N+1,1);
c(N+1) = cc(0); % componente DC 
sNC{1} = c(N+1);
for n = 1:N
   c_pn = cc(n);       c(N+1 + n) = c_pn; % = c(+n)
   c_mn = conj(c_pn);  c(N+1 - n) = c_mn; % = c(-n)
   sNC{n+1} = sNC{n} + c_mn*exp(1j*2*pi*(-n)*x/P)  + c_pn*exp(1j*2*pi*n*x/P);
end 

%% Se imprime y grafica la serie truncada
figure
for i = 1:N
   fprintf('SC_%d(x) = \n', i);
   sympref('AbbreviateOutput', false);
   pretty(sNC{i+1});
   sympref('AbbreviateOutput','default');
   fprintf('\n')
   clf;
   fplot(sNC{i+1}, [-P, P], 'b');
   hold on;
   fplot(s, [-P, P],'r');
   title(sprintf('Serie truncada de Fourier compleja con N = %d', i));
   drawnow;
   pause(0.1);
end

%% Se grafica el espectro correspondiente
figure
subplot(2,1,1)
stem(-N:N, abs(c));
title('Espectro discreto de frecuencia')
ylabel('|c_n|')
subplot(2,1,2)
stem(-N:N, angle(c));
title('Espectro discreto de fase')
ylabel('arg(c_n) [rad]')
xlabel('n')