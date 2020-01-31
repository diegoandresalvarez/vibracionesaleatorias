function Rf0f0 = Rf0f0_spectral_representation(Sf0f0, N, wu, tau)
% Estimates the autocorrelation function of a stochastic process that is 
% simulated using the spectral representation method, by means of eq. 52
%
% FUNCTION CALL
% Rf0f0 = Rf0f0_spectral_representation(Sf0f0, N, wu, tau)
%
% INPUT PARAMETERS
% Sf0f0 = power spectral density PSD (function handle)
% N     = number of random phases
% wu    = upper cut-off frequency
% tau   = vector of time instants where Rf0f0 is going to be calculated
%
% OUTPUT PARAMETERS
% Rf0f0 = autocorrelation function

% Reference:
% Shinozuka, M. and Deodatis, G. (1991). 
% Simulation of Stochastic Processes by Spectral Representation. 
% ASME Applied Mechanics Reviews; 44(4):191-204.
% doi:10.1115/1.3119501

% WHO    WHAT                                WHEN
% DAAM   First algorithm                     January 31st, 2020
% DAAM - Diego Andres Alvarez Marin daalvarez@unal.edu.co

%% Set up some initial variables
dw = wu/N;                     % eq. 39 increment in frequency
n  = 0:N-1;                    % eq. 37
wn = n*dw;                     % eq. 38
An = sqrt(2*Sf0f0(wn)*dw);     % eq. 37

%% Calculation of the temporal autocorrelation function (eq. 52)
Rf0f0 = zeros(size(tau));
for j = 1:length(tau)
   Rf0f0(j) = sum(An.^2 .* cos(wn*tau(j)));  % eq. 52
end

%% bye bye
return 
