clear, clc, close all

x0 = 0;
T  = 1;

nterms = 50;
a = zeros(1,nterms+1);
b = zeros(1,nterms);

fo1 = 15;                 % frecuencia de la onda sinusoidal 1
fo2 = 20;                 % frecuencia de la onda sinusoidal 2

% Se define la funcion
t = 0:0.001:0.99;
%g = @(t) 2*sin(2*pi*fo1*t) + 3*sin(2*pi*fo2*t + 200);
%g = @(t) 2*sin(2*pi*fo1*t) + 3*sin(2*pi*fo2*t + 200) + 1.5*randn(size(t)); 
%g = @(t) 2*exp(1i*2*pi*fo1*t);     % la curva sinusoidal compleja
%g = @(t) 2*sin(2*pi*1.005*fo1*t);  % produce filtracion espectral (spectral leakage)
g = @(t) square(2*pi*4*t);         % se observan los armonicos

% Se calcula a y b
a(1) = (2/T)*quadl(@(t) g(t).*cos(2*pi*0*t/T), x0, x0+T);
for n = 1:nterms
   a(n+1) = (2/T)*quadl(@(t) g(t).*cos(2*pi*n*t/T), x0, x0+T);
   b(n)   = (2/T)*quadl(@(t) g(t).*sin(2*pi*n*t/T), x0, x0+T);
end

% Se imprime la aproximacion
figure
plot(t,g(t),'r');
hold on;
for n = 1:nterms
   s = a(1)/2;
   for k = 1:n
      s = s + a(k+1)*cos(2*pi*k*t/T) + b(k)*sin(2*pi*k*t/T);
   end
   title(sprintf('n = %d\n',n));
   h = plot(t,s);
   pause(0.3);
   delete(h);
end
plot(t,s)

% Se calculan los coeficientes c[n]
tmp = (a(2:end) - 1j*b)/2;
c = [conj(tmp(end:-1:1)) a(1)/2 tmp];
abs(c)

% Se grafican los coeficientes c[n]
figure
stem(-nterms:nterms,abs(c));
xlabel('n')
ylabel('|c_n|')
title('Magnitud de los coeficientes c[n] de la serie de Fourier')