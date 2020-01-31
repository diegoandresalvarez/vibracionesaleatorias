function [f,t,T0,phin] = simu_from_PSD_SUM(Sf0f0, N, wu, M)
% Simulate a realization of a weakly stationary stochastic process using
% the PSD Sff and the spectral representation method using the summation by 
% cosines (equation 44).
%
% FUNCTION CALL
% [f,t,T0,phin] = simu_from_PSD_SUM(Sf0f0, N, wu, M)
%
% INPUT PARAMETERS
% Sf0f0 = power spectral density PSD (function handle)
% N     = number of random phases
% wu    = upper cut-off frequency
% M     = number of time steps
%
% OUTPUT PARAMETERS
% t   = time history
% f   = realization of the stochastic process
% T0  = period of the realization
% phi = random phases

% Reference:
% Shinozuka, M. and Deodatis, G. (1991). 
% Simulation of Stochastic Processes by Spectral Representation. 
% ASME Applied Mechanics Reviews; 44(4):191-204.
% doi:10.1115/1.3119501

% WHO    WHAT                                WHEN
% DAAM   First algorithm                     January 31st, 2020
% DAAM - Diego Andres Alvarez Marin daalvarez@unal.edu.co

%% Evaluation of eq. 40
if Sf0f0(0) ~= 0
   warning(...
    ['The spectral representation method requires Sf0f0(0) to be 0 so that\n' ...  
     'the realization is ergodic in the mean and in the autocorrelation.']);
end

%% Set up the default number of time steps M >= 2*N
% M = 2*N this is the minimum possible in order to avoid aliasing
if nargin == 3
   M = 2*N;                % eq. 128
end

%% Set up the initial parameters
dw = wu/N;                 % eq. 39
n  = 0:N-1;                % eq. 38
wn = n*dw;                 % eq. 38
An = sqrt(2*Sf0f0(wn)*dw); % eq. 37
   
T0 = 2*pi/dw;              % eq. 43  period of the realization
dt = T0/M;
dtmax = (2*pi)/(2*wu);     % eq. 45  maximum possible value for dt
if dt > dtmax
   error('Increse the number of time steps M in order to avoid aliasing');
end

%% Generate the random phases
phin = 2*pi*rand(1,N);     % eq. 26  random phases ~ Unif[0,2*pi)

%% Now the simulation
t = 0:dt:(T0-dt);          % time vector
f = zeros(1,M);
for i = 1:M
   f(i) = sqrt(2)*sum(An.*cos(wn*t(i) + phin)); % eq. 44
end

%% bye bye
return 
