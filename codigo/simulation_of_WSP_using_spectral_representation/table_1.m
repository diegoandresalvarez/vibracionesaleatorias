% Recalculates Table 1 of
% Shinozuka, M. and Deodatis, G. (1991). 
% Simulation of Stochastic Processes by Spectral Representation. 
% ASME Applied Mechanics Reviews; 44(4):191-204.
% doi:10.1115/1.3119501

% WHO    WHAT                                WHEN
% DAAM   First algorithm                     January 31st, 2020
% DAAM - Diego Andres Alvarez Marin daalvarez@unal.edu.co

clear, clc

%% Integrals 95 and 96 are defined
p   = @(N,f) real(quadgk(@(t) besselj(0, t*sqrt(2/N)).^N .* exp(-1i.*t.*f)/(2*pi), -Inf, Inf)); % eq. 95
Phi = @(N,x) integral(@(f) p(N,f), x, 10, 'ArrayValued', true);                                 % eq. 96

%% The results are printed
xx = [ 1 2 3 4 5 ];
fprintf('%15s','N \ x');
fprintf('%15d',xx);
fprintf('\n\n');
for N = [ 50 100 200 400 600 800 1000 10000 100000 ]
   fprintf('%15d',N);
   for x = xx
      fprintf('%15.3e', Phi(N,x));
   end
   fprintf('\n');
end

fprintf('\n%15s','Gaussian');
for x = xx
   fprintf('%15.3e', 1 - normcdf(x, 0, 1));
end
fprintf('\n');
