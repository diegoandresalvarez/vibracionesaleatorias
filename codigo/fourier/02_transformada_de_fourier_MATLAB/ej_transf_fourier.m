clear, clc

sympref('FourierParameters', 'default');

%% TRANSFORMADA DE FOURIER
% NOTA: mire adicionalmente los ejemplos que se encuentran en:
% https://www.mathworks.com/help/symbolic/fourier.html

fprintf('Transformada de Fourier de f(t) = exp(-t^2)\n');
syms t w
f = exp(-t^2);
fourier(f, t, w)

fprintf('\nTransformada de Fourier de f(x) = exp(-x^2)*exp(-r^2)\n');
syms x r w
f = exp(-x^2)*exp(-r^2);
fourier(f, x, w)

fprintf('\nTransformada de Fourier de f(x) = x^3\n');
syms x w
f = x^3;
fourier(f, x, w)

fprintf('\nTransformada de Fourier de f(x) = heaviside(x - x0)\n');
syms x x0
f = heaviside(x - x0);
fourier(f, x, w)

fprintf('\nTransformada de Fourier de f(x) = exp(-r^2*abs(x))*sin(x)/x\n');
syms x r w
assume(r,'real')   % se define r como constante real
f = exp(-r^2*abs(x))*sin(x)/x;
fourier(f, x, w)

fprintf('\nTransformada de Fourier de f(x) = diff(f(t),t)');
syms t f(t) w
f = diff(f(t), t);
fourier(f, t, w)

%% TRANSFORMADA INVERSA DE FOURIER

fprintf('\nTransformada inversa de Fourier de F(w) = sqrt(sym(pi))*exp(-w^2/4)\n');
syms t w
F = sqrt(sym(pi))*exp(-w^2/4);
ifourier(F, w, t)

fprintf('\nTransformada inversa de Fourier de F(w) = exp(-w^2/(4*a^2))\n');
syms a w t
assume(a,'real')   % se define "a" como constante real
F = exp(-w^2/(4*a^2));
ifourier(F, w, t)

fprintf('\nTransformada inversa de Fourier de F(w) = dirac(w)\n');
syms t w
ifourier(dirac(w), w, t)

fprintf('\nTransformada inversa de Fourier de F(w) = 2*exp(-abs(w)) - 1\n');
F = 2*exp(-abs(w)) - 1
ifourier(F, w, t)

fprintf('\nTransformada inversa de Fourier de F(w) = 1/(w^2 + 1)\n');
F = 1/(w^2 + 1)
ifourier(F, w, t)


%% COMO CALCULAR LAS DIFERENTES COLUMNAS DE FOURIER DE LOS EJEMPLOS DE WIKIPEDIA:
% https://en.wikipedia.org/wiki/Fourier_transform#Square-integrable_functions,_one-dimensional

clear
syms a x xi w nu

%{ 
% CASO 205
assume(a > 0);
f = exp(-a*x)*heaviside(x);
%}

%{ 
% CASO 207
assume(a > 0);
f = exp(-a*abs(x));   %
%}

%{ 
% CASO 301
f = 1;     
%}

% COLUMNA 1: 
sympref('FourierParameters', [1 -2*sym(pi) ]);
fourier(f, x, xi)

% COLUMNA 2:
sympref('FourierParameters', [1/sqrt(2*sym(pi)), -1]);
fourier(f, x, w)

% COLUMNA 3:
sympref('FourierParameters', 'default');
sympref('FourierParameters', [1, -1]);
fourier(f, x, nu)

% NOTA IMPORTANTE: 
% Preferences set by sympref persist through your current and future MATLAB sessions. Restore the default values of c and s by setting FourierParameters to 'default'.

sympref('FourierParameters', 'default');

