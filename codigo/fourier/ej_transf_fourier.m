clear, clc

fprintf('Transformada de Fourier de f(t) = exp(-t^2)\n');
syms t w
f = exp(-t^2);
fourier(f, t, w)

fprintf('\nTransformada de Fourier de f(x) = exp(-x^2)*exp(-t^2)\n');
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


fprintf('\nTransformada inversa de Fourier de F(w) = sqrt(sym(pi))*exp(-w^2/4)\n');
syms t w
F = sqrt(sym(pi))*exp(-w^2/4);
ifourier(F, w, t)

fprintf('\nTransformada inversa de Fourier de F(w) = exp(-w^2/(4*a^2))\n');
syms a w t
assume(a,'real')   % se define "a" como constante real
F = exp(-w^2/(4*a^2));
ifourier(F, w, t)

fprintf('\nTransformada inversa de Fourier de F(w) = delta(w)\n');
syms t w
ifourier(dirac(w), w, t)

fprintf('\nTransformada inversa de Fourier de F(w) = 2*exp(-abs(w)) - 1\n');
F = 2*exp(-abs(w)) - 1
ifourier(F, w, t)

fprintf('\nTransformada inversa de Fourier de F(w) = 1/(w^2 + 1)\n');
F = 1/(w^2 + 1)
ifourier(F, w, t)


