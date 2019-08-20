%% Analysis of a spring-mass-damper LTI system (SISO system)
%
% Differential equation:
%
%   d2x(t)     dx(t)       
% m ------ + c ----- + k x(t) = u(t), initial conditions: x(0) = x0
%    dt2        dt        
%
% Transfer function (if x(0) = 0):
%                 1
% H(s) =  -----------------
%          m*s^2 + c*s + k

% The state space representation is best suited for numerical computations. 
% For highest accuracy, convert to state space prior to combining models 
% and avoid the transfer function an zero/pole/gain representations, 
% except for model specification and inspection.

clear, clc, close all

m = 1; % mass [kg]
c = 2; % damping [N*s/m]
k = 3; % stiffness [N/m]

%% ************************************************************************
%% * *** *** *** *** *** CONTINUOUS-TIME LTI SYSTEMS  *** *** *** *** *** *
%% ************************************************************************
%% State-space representation
A = [ 0     1        % state matrix
     -k/m  -c/m ];
  
B = [ 0              % input to state matrix
      1/m ];
   
C = [ 1 0 ];         % state to output matrix

D = [ 0 ];           % feedthrough matrix

ss_msd = ss(A, B, C, D);

% Explore the model:
size(ss_msd)             % Number of inputs, outputs and states
order(ss_msd)            % Number of poles (for proper transfer functions) or the number of states (for state-space models)
isct(ss_msd)             % Is it a continuous system?
isdt(ss_msd)             % Is it a discrete system?
issiso(ss_msd)           % Is it a SISO system?
isstable(ss_msd)         % Is it a stable system?

get(ss_msd)

% You can also explore or change the matrices:
% ss_msd.A
% ss_msd.A = [1 2; 3 4];

% Launch a GUI that simplifies the analysis of LTI systems
linearSystemAnalyzer(ss_msd)
% ltiview(ss_msd) ALSO WORKS
% linearSystemAnalyzer(sys1, sys2)

%% Estimation of the transfer function (and back)
% Remember that:
% H(s) = C*inv(s*I - A)*B + D
%
% Method 1
[num, den]       = ss2tf(A, B, C, D)
[A2, B2, C2, D2] = tf2ss(num, den)
% Observe that we have obtained a differente state-space representation. SS
% representations are not unique. tf2ss() returns the so-called control
% canonical form.

% Method 2
tf_msd  = tf(num,den)
ss_msd2 = ss(tf_msd)
tf_msd2 = tf(ss_msd2)
[A3, B3, C3, D3] = ssdata(ss_msd2)

% Method 3
s = tf('s');
tf_msd3 = 1/(m*s^2 + c*s + k)

% Method 4
% Here 'v' is for SISO systems
[num4, den4]  = tfdata(ss_msd, 'v')

%% Calculation of poles and zeros, stability
% Method 1
zeros1 = roots(num)
poles1 = roots(den)

% Method 2
[zeros2, poles2] = tf2zp(num, den)
% zp2ss

% Method 3
zeros3 = zero(ss_msd)
poles3 = pole(ss_msd)

%% Definition of a system from its poles, zeros and gain
% Method 1
% When you give MATLAB a set of zeros and poles, it chooses polynomials for 
% the numerator and denominator which are scaled so that the highest order 
% coefficient of each polynomial is equal to one. In order to produce the 
% desired transfer function, you need to tell MATLAB what the scalar gain 
% should be based on this fact. For our example system, a scalar gain of 1
% is used since, by observation of the original transfer function, we would 
% need to divide both the numerator and denominator through by 1 to produce 
% numerator and denominator polynomials with the highest order coefficient 
% of each polynomial equal to one.
gain_tf = 1;
[num5, den5] = zp2tf(zeros1, poles1, gain_tf)
ss_msd4 = zpk(zeros1, poles1, gain_tf)

% Method 2
num6 = gain_tf*poly(zeros1)
den6 = poly(poles1)

% The poles of H(s) are the eigenvalues of A
eig(A)

% The system is stable if all poles have negative real part
if all(real(poles1) < 0)
   fprintf('The system is stable');
else
   fprintf('The system is unstable');
end

% Method 3: Partial Fraction Expansion and Residues
% The residue() function breaks the transfer function defined by num and 
% den into its n component residues, where n is the order of the 
% denominator:
% num(s)       R(1)       R(2)             R(n)
% ------  =  -------- + -------- + ... + -------- + K(s) 
% den(s)     s - P(1)   s - P(2)         s - P(n)
% This is useful for obtaining the inverse Laplace transform
[R, poles_tf3, K] = residue(num, den)

%% Estimation of the impulse response function
[yimp, timp] = impulse(ss_msd);
figure
impulse(ss_msd);
grid on;
info_impulse = lsiminfo(yimp, timp, 0)  % final value is 0
% SettlingTime - Settling time
% Min          - Minimum value of Y
% MinTime      - Time at which the min value is reached
% Max          - Maximum value of Y
% MaxTime      - Time at which the max value is reached<

%% Estimation of the step response function
[ystep, tstep] = step(ss_msd);
figure
step(ss_msd);
grid on;
step_info = stepinfo(ss_msd)
% https://en.wikipedia.org/wiki/Step_response
% RiseTime     - Rise time
% SettlingTime - Settling time
% SettlingMin  - Minimum value of y once the response has risen
% SettlingMax  - Maximum value of y once the response has risen
% Overshoot    - Percentage overshoot (relative to yfinal)
% Undershoot   - Percentage undershoot
% Peak         - Peak absolute value of y
% PeakTime     - Time at which this peak is reached

%% Response to a free vibration (x(0) = x0, u(t) = 0)
figure
x0 = [1; 0];                      % initial state
initial(ss_msd, x0);

%% System response to a forced vibration + initial conditions
t = linspace(0,2*pi*10,10000)';
% the input u is an array having as many rows as time samples and as many 
% columns as system inputs.
u = sin(t);
x0 = [1; 0];                      % initial state
y1 = lsim(ss_msd, u, t);          %MIRAR LA AYUDA
y2 = lsim(tf_msd, u, t);          %MIRAR LA AYUDA

figure
lsim(ss_msd, u, t);

%% Linear simulation tool (GUI)
figure
lsim(ss_msd)
% ver 3-17 (p 59) ... sine wave, square, step, white noise as inputs 

%% Solving the response of the system with ODE23()
% TO DO

%% Covariance of output
% the noise intensity W is defined by
% E[w(t)w(tau)'] = W delta(t-tau)  (delta(t) = Dirac delta)
w = 1;
[P,Q] = covar(ss_msd, w)  % Covariance of response to white noise

% In continuous time, the steady-state state covariance Q is obtained by 
% solving the Lyapunov equation
% AQ + QA' + BWB' = 0
%
% In both continuous and discrete time, the output response covariance is 
% given by P = CQC' + DWD'. For unstable systems, P and Q are infinite.

%% ************************************************************************
%% ** *** *** *** *** *** DISCRETE-TIME LTI SYSTEMS  *** *** *** *** *** **
%% ************************************************************************
%% Constructing discrete time systems
% They are created like the continuous systems. THe only difference is that
% you must specify a sampling time period for any model you build, for
% example:
%{
ss_disc = ss(Ad,Bd,Cd,Dd, 0.01);
tf_disc = tf(num_d,den_d, 0.01);
%}

%% Conversion to discrete state-space representation
Ts = 0.1;
ssd1_msd = c2d(ss_msd, Ts);     % discretization with sample period Ts
ssd2_msd = d2d(ssd1_msd, 0.01); % resampling to period 0.01
ssc_msd  = d2c(ssd1_msd);       % equivalent continuous time model

% According to "doc c2d", there are several discretization methods:	
% 'zoh'     - Zero-order hold (default). Assumes the control inputs are 
%             piecewise constant over the sample time Ts.
% 'foh'     - Triangle approximation (modified first-order hold). Assumes 
%             the control inputs are piecewise linear over the sample time 
%             Ts.
% 'impulse' - Impulse invariant discretization.
% 'tustin'  - Bilinear (Tustin) method.
% 'matched' - Zero-pole matching method.

% Compare the response of the discretized and continuous systems
figure
step(ss_msd, ssd1_msd);

%% Estimation of the impulse response function
% For a relaxed discrete time system (x[0] = 0), it is:
% https://ccrma.stanford.edu/~jos/StateSpace/StateSpace_4up.pdf
%
%        / Dd                for n = 0
% h[n] = |
%        \ Cd*Ad^{n-1}*Bd    for n > 0
figure
impulse(ss_msd, ssd1_msd)

%% Estimation of the transfer function (and back)
% Remember that:
% H(z) = Cd*inv(z*I - Ad)*Bd + Dd
tfd_msd = tf(ssd1_msd)

%% Calculation of poles and zeros, stability
zerosd = zero(ssd1_msd)
polesd = pole(ssd1_msd)

% Observe that the poles of H(z) are the eigenvalues of Ad
eig(ssd1_msd.A)

% The system is stable if all poles are within the unit circle

%% FALTA
% SPACE STATE MODAL REPRESENTATION
% https://ccrma.stanford.edu/~jos/StateSpace/StateSpace_4up.pdf

% FALTA SPACE STATE SIMILARITY TRANSFORMATIONS

% SUSPENSION SYSTEM (Diseño del amortiguador de un carro, shock absorver)
% https://ece.gmu.edu/~hayes////courses/SignalsSystems/Labs/lab03_2016.pdf
% http://sigpromu.org/brett/elec2400/matlab2.pdf
