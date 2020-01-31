function [f,t,T0,phin] = simu_from_PSD_FFT(Sf0f0, N, wu, M)
% Simulate a realization of a weakly stationary stochastic process using
% the PSD Sf0f0 and the spectral representation method and the speed up 
% provided by the fast Fourier transform (eq. 126).
%
% FUNCTION CALL
% [f,t,T0,phin] = simu_from_PSD_FFT(Sf0f0, N, wu, M)
%
% INPUT PARAMETERS
% Sf0f0 = power spectral density PSD (function handle)
% N     = number of random phases
% wu    = upper cut-off frequency
% M     = lower bound on the number of time steps (this value may change)
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

%% Evaluation of eq. 40/eq. 130
if Sf0f0(0) ~= 0
   warning(...
    ['The spectral representation method requires Sf0f0(0) to be 0 so that\n' ...  
     'the realization is ergodic in the mean and in the autocorrelation.']);
end

%% Set up the default number of time steps M >= 2*N
% M = 2*N this is the minimum possible in order to avoid aliasing
if nargin == 3
   M = 2*N;                    % eq. 128
end

%% Set up the initial parameters
M = 2^nextpow2(M);             % eq. 129  number of time samples
dw = wu/N;                     % eq. 123  increment in frequency
n  = 0:N-1;                    % eq. 121  (corrected typo in paper)
An = sqrt(2*Sf0f0(n*dw)*dw);   % eq. 122
phin = 2*pi*rand(1,N);         % eq.  26  draw random phases ~ Unif[0,2*pi)
Bn = sqrt(2)*An.*exp(1j*phin); % eq. 121

T0 = 2*pi/dw;                  % eq. 124  period of the realization
dt = T0/M;                     % eq. 125a/b 
dtmax = (2*pi)/(2*wu);         % eq. 127  maximum possible value for dt
if dt > dtmax
   error('Increse the number of time steps M in order to avoid aliasing');
end

%% Now the simulation
t = 0:dt:(T0-dt);              % time vector
f = M*real(ifft(Bn, M));       % eq. 126, 131

%% bye bye
return 
