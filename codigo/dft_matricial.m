%% Calculo de la DFT utilizando el metodo matricial y comando "dftmtx"
% Ver:
% https://ccrma.stanford.edu/~jos/st/Matrix_Formulation_DFT.html
% https://en.wikipedia.org/wiki/DFT_matrix (aunque la de WIKIPEDIA tiene una normalizacion diferente)

clear, clc

x = [2; 3; -1; 4; -2]
N = length(x);

disp('fft(x) = ');        disp(fft(x))         % to check X(k)

%% Calculo de la matriz SN
SN = zeros(N);
for k = 0:N-1
   for n = 0:N-1
      SN(k+1,n+1) = exp(j*2*pi*k*n/N);
   end
end

%% Forma alterna de calculo de SN 2
k = 0:N-1; n = 0:N-1;
SN2 = exp(j*2*pi*k'*n/N);
norm(SN - SN2)

%% Forma alterna de calculo de SN 3 (comando de MATLAB dftmtx)
SN3 = dftmtx(N)';
norm(SN - SN3)

%% Forma alterna de calculo de SN 4 (dftmtx(N) = fft(eye(N)))
SN4 = fft(eye(N))';
norm(SN - SN4)
norm(SN3 - SN4)

% Calculo de la DFT e IDFT
fft_x = SN'*x            % recuerde que ' es la transpuesta conjugada (hermitian transpose)
ifft_x = (1/N)*SN*fft_x 
