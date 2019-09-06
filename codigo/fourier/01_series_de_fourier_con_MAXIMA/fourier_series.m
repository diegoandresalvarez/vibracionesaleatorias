% Este programa calcula y grafica las series de Fourier de una funcion dada

syms x P n N

%% Numero de terminos a calcular de la serie de Taylor
N = 40;

%% Se define la funcion s(x) y el periodo P
%s = exp(-x); P = 2;
%s = abs(x); P = 2;
%s = x; P = 2;
s = + heaviside(x+3)*heaviside(-1-x)*(x+2) ... 
    + heaviside(x+1)*heaviside(1-x)*x ...
    + heaviside(x-1)*heaviside(3-x)*(x-2); 
P = 6;


%% Se definen los coeficientes
assume(n, 'integer'); % Se le informa a MATLAB que n es un entero
a = @(n) (2/P)*int(s*cos(2*pi*n*x/P), x, -P/2, P/2);
b = @(n) (2/P)*int(s*sin(2*pi*n*x/P), x, -P/2, P/2);

%% Se calcula la serie de Fourier
% S_N(x) = \frac{a_0}{2} + \sum_{n=1}^N\bigg[a_n\cos\bigg(\frac{2\pi n x}{P}\bigg)+b_n\sin\bigg(\frac{2\pi nx}{P}\bigg)\bigg]
sN = cell(N+1,1);
sN{1} = a(0)/2;
for n = 1:N
   sN{n+1} = sN{n} + a(n)*cos(2*pi*n*x/P) + b(n)*sin(2*pi*n*x/P);
end 

%% Se imprime y grafica la serie truncada
figure
for i = 1:N
   fprintf('S_%d(x) = \n', i);
   pretty(sN{i+1});
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
c = @(n) (1/P)*int(s*exp(-1j*2*pi*n*x/P), x, -P/2, P/2);

%% Se calcula la serie de Fourier compleja
% S_N(x) = \frac{a_0}{2} + \sum_{n=1}^N c_n \exp\lef(\frac{j 2\pi n x}{P}\right)
sNC = cell(N+1,1);
sNC{1} = c(0);
for n = 1:N
   sNC{n+1} = sNC{n} + c(-n)*exp(1j*2*pi*(-n)*x/P) + c(n)*exp(1j*2*pi*n*x/P);
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
