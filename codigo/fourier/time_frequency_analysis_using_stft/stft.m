function [stft, f, t] = stft(x, wlen, h, nfft, fs)
% Short-Time Fourier Transform
%
% function: [stft, f, t] = stft(x, wlen, h, nfft, fs)
% x    - signal in the time domain
% wlen - length of the hamming window
% h    - hop size
% nfft - number of FFT points
% fs   - sampling frequency, Hz
% f    - frequency vector, Hz
% t    - time vector, s
% stft - STFT matrix (only unique points, time across columns, freq across rows)

% Author: M.Sc. Eng. Hristo Zhivomirov       12/21/13
% http://www.mathworks.com/matlabcentral/fileexchange/45465-time-frequency-analysis-of-non-stationary-signals-with-matlab-implementation
% Modified by: Diego Andres Alvarez Marin

% test whether x is a vector
assert(isvector(x), 'x must be a vector');

x = x(:);

% length of the signal
xlen = length(x);

% form a periodic hamming window
win = hamming(wlen, 'periodic');

% form the stft matrix
rown = ceil((nfft+1)/2);            % calculate the total number of rows
coln = 1+fix((xlen-wlen)/h);        % calculate the total number of columns
stft = zeros(rown, coln);           % form the stft matrix

% initialize the indexes
indx = 0;
col = 1;

% perform STFT
while indx + wlen <= xlen
    % windowing + FFT
    X = fft(x(indx+1:indx+wlen).*win, nfft);
    
    % update the stft matrix
    stft(:, col) = X(1:rown);
    
    % OJO AQUI FALTA AJUSTAR LAS AMPLITUDES 2*X menos DC
    
    % update the indexes
    indx = indx + h;
    col = col + 1;
end

% calculate the time and frequency vectors
t = (wlen/2:h:wlen/2+(coln-1)*h)/fs;
f = (0:rown-1)*fs/nfft;

end