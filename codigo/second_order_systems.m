%% Response of second order systems
%
% There are five cases
% 1. Overdamped
% 2. Underdamped
% 3. Undamped
% 4. Critically damped 
% 5. Unstable

% Frequency response simulation: s = jw
% [magnitude, phase] = bode(sys)
% [re, im]           = nyquist(sys)

clear, clc, close all

m = 1; c = 5; k = 4;  sys1 = tf([1],[m c k]); % 1. Overdamped
m = 1; c = 1; k = 4;  sys2 = tf([1],[m c k]); % 2. Underdamped
m = 1; c = 0; k = 4;  sys3 = tf([1],[m c k]); % 3. Undamped
m = 1; c = 4; k = 4;  sys4 = tf([1],[m c k]); % 4. Critically damped
m = 1; c = 1; k = -4; sys5 = tf([1],[m c k]); % 5. Unstable

figure;
subplot(1,2,1);
impulse(sys1,sys2,sys3,sys4,10)
legend('Overdamped', 'Underdamped', 'Undamped', 'Critically damped')
subplot(1,2,2);
impulse(sys5,10)
legend('Unstable');

figure;
subplot(1,2,1);
step(sys1,sys2,sys3,sys4,10)
legend('Overdamped', 'Underdamped', 'Undamped', 'Critically damped')
subplot(1,2,2);
step(sys5,10)
legend('Unstable');

figure;
subplot(1,2,1);
bode(sys1,sys2,sys3,sys4)
legend('Overdamped', 'Underdamped', 'Undamped', 'Critically damped')
subplot(1,2,2);
bode(sys5)
legend('Unstable');

figure;
subplot(2,3,1); nyquist(sys1); title('Nyquist diagram for the overdamped case')
subplot(2,3,2); nyquist(sys2); title('Nyquist diagram for the underdamped case')
subplot(2,3,3); nyquist(sys3); title('Nyquist diagram for the undamped case')
subplot(2,3,4); nyquist(sys4); title('Nyquist diagram for the critically damped case')
subplot(2,3,5); nyquist(sys5); title('Nyquist diagram for the unstable case')

figure; 
subplot(2,3,1); pzmap(sys1);   title('Pole-zero map for the overdamped case')
subplot(2,3,2); pzmap(sys2);   title('Pole-zero map for the underdamped case')
subplot(2,3,3); pzmap(sys3);   title('Pole-zero map for the undamped case')
subplot(2,3,4); pzmap(sys4);   title('Pole-zero map for the critically damped case')
subplot(2,3,5); pzmap(sys5);   title('Pole-zero map for the unstable case')

% Natural frequency and damping of system poles
disp('System 1 = '); damp(sys1) 
disp('System 2 = '); damp(sys2) 
disp('System 3 = '); damp(sys3) 
disp('System 4 = '); damp(sys4) 
disp('System 5 = '); damp(sys5) 

%% Launch a GUI that simplifies the analysis of LTI systems
% linearSystemAnalyzer(sys1, sys2, sys3, sys4, sys5)

%% Stability analysis
% If K>1, the system is asymptotically stable.
% If K<1, the system is unstable.
% If K=1, the system is marginally stable (stable but not asymptotically stable). 

%% Plot the transfer function vs the frequency response function in the s-pĺane
re = linspace(-10,10,100);
im = linspace(-10,10,100);
sys = sys2;
[num, den] = tfdata(sys, 'v')
[s_re, s_im] = meshgrid(re,im);

% Transfer function
s = s_re + 1j*s_im;
Hs = polyval(num,s)./polyval(den,s);

% Frequency response function
w = 0 + 1j*s_im;
Hw = polyval(num,w)./polyval(den,w);

figure
h = surf(s_re,s_im,20*log10(abs(Hs))); alpha(h, 0.1);
hold on
fill3(zeros(size(s_im)),s_im,20*log10(abs(Hw)),[1 0 0])
xlabel('\sigma = Re(s)')
ylabel('\omega = Im(s)')
zlabel('|H(s)| [dB]')
title('S-Plane Plot of System');

% This new plot is done in order to compare with the Bode plot

re = linspace(-10,10,100);
im    = linspace(-3,2,100);
imlog = logspace(-3,2,100);
[s_re, s_im] = meshgrid(re,imlog);

% Transfer function
s = s_re + 1j*2*pi*s_im;
Hs = polyval(num,s)./polyval(den,s);

% Frequency response function
w = 0 + 1j*2*pi*s_im;
Hw = polyval(num,w)./polyval(den,w);

figure
subplot(1,2,1);
bodemag(sys);
xx = xlim;
yy = ylim;

subplot(1,2,2);
h = surf(s_re,imlog,20*log10(abs(Hs))); alpha(h, 0.1);
set(gca,'Yscale','log') %# to set the Y-axis to logarithmic
hold on
fill3(zeros(size(s_im)),imlog,20*log10(abs(Hw)),[1 0 0])
xlabel('\sigma = Re(s)')
ylabel('f = $\frac{\omega}{2\pi}$ = Im(s)', 'Interpreter','LaTeX','FontSize',14)
zlabel('|H(s)| [dB]')
title('S-Plane Plot of System');
view([90, 0]);
ylim(xx);
zlim(yy);
