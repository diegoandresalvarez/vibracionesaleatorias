function [rx, lag] = xcorr_ensemble(x)
% Estimate the autocorrelation function of a stationary stochastic process
% in the weak sense using a ensemble of realizations
%
% FUNCTION CALL
% [rx, lag] = xcorr_ensemble(x)
%
% INPUT PARAMETERS
% x     = ensemble of realizations of the stochastic process (M x n matrix)
% here:
% M     = number of realizations
% n     = number of samples per realization
%
% OUTPUT PARAMETERS
% rx    = estimation of the autocorrelation function
% lag   = vector with the lags at which the correlations are computed.

% Reference:
% Wirsching, Paul H., Thomas L. Paez, and Keith Ortiz. Random Vibrations: 
% Theory and Practice. New York: Wiley, 1995.

% WHO    WHAT                                WHEN
% DAAM   First algorithm                     January 31st, 2020
% DAAM - Diego Andres Alvarez Marin daalvarez@unal.edu.co

[M, n] = size(x); % M = number of realizations, n = length of a realization

%% eq 12.19
rxx = nan(n);
for i = 1:n
   for j = i:n
      rxx(i,j) = mean(x(:,i) .* x(:,j));
%     rxx(j,i) = rxx(i,j); % THIS IS NOT NECESSARY, 
   end
end

%% eq 12.25
rx = zeros(1, n);
for j = 0:(n-1)
   rx(j +1) = mean(diag(rxx, j));
end
rx  = [ rx(end:-1:2) rx ];
lag = -(n-1):n-1;

%% bye, bye!
return