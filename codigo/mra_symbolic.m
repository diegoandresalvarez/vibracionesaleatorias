%% From the state space representation to the transfer function
% This example is a SISO system. Those functions support as well MIMO
% systems

syms m c k s

A = [ 0     1        % state transition matrix
     -k/m  -c/m ];
  
B = [ 0              % input to state matrix (input coefficient matrix)
      1/m ];
   
C = [ 1 0 ];         % state to output matrix (output coefficient matrix)

D = [ 0 ];           % feedthrough matrix (direct path coefficient matrix)

I = sym(eye(2));

% Transfer function
%Hs = C*inv(s*I - A)*B + D
Hs = C/(s*I - A)*B + D

