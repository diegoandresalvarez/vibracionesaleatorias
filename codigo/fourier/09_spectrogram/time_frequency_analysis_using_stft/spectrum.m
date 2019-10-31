%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Spectrum Analysis with MATLAB Implementation     %
%                                                      %
%  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Xamp, Xph, f] = spectrum(x, fs, varargin)
% Spectrogram


% function: [Xamp, Xph, f] = spectrum(x, fs, varargin)
% x - singnal in the time domain
% fs - sampling frequency, Hz
% Xamp - amplitude spectrum, dB
% Xph - phase spectrum, degrees
% f - frequency vector, Hz
% type 'plot' in the place of varargin if one want to make a plot of the spectrum

% Author: M.Sc. Eng. Hristo Zhivomirov       06/10/13
% http://www.mathworks.com/matlabcentral/fileexchange/45465-time-frequency-analysis-of-non-stationary-signals-with-matlab-implementation
% Modified by: Diego Andres Alvarez Marin

% test whether x is a vector
assert(isvector(x), 'x must be a vector');

x = x(:);

% calculate NFFT
nfft = length(x);

% windowing
win = hanning(nfft, 'periodic');
x = x.*win;

% take fft of x
fftx = fft(x, nfft);

% calculate the number of unique points
NumUniquePts = ceil((nfft+1)/2);

% FFT is symmetric, throw away second half
fftx = fftx(1:NumUniquePts);

% define the coherent amplification of the window
K = sum(win)/length(x);

% take the magnitude of fft(x) and scale it, so not to be a
% function of the length of x and window coherent amplification
Xamp = abs(fftx)/length(x)/K;

% correction of the DC & Nyquist component
if rem(nfft, 2) % odd nfft excludes Nyquist point
    Xamp(2:end) = Xamp(2:end)*2;
else            % even nfft includes Nyquist point
    Xamp(2:end-1) = Xamp(2:end-1)*2;
end

% convert magnitude spectrum to dB
Xamp = 20*log10(Xamp);

% phase spectrum
Xph = atan2(imag(fftx), real(fftx));

% convert phase spectrum to degrees
Xph = Xph*180/pi;

% frequency vector with NumUniquePts points
f = (0:NumUniquePts-1)*fs/nfft;

if strcmp(varargin, 'plot')
    
    % generate the plots, titles and labels
    figure
    subplot(2, 1, 1)
    plot(f/1000, Xamp, 'r')
    grid on
    xlim([0 max(f/1000)])
    ylim([min(Xamp)-10 max(Xamp)+10])
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
    xlabel('Frequency, kHz')
    ylabel('Magnitude, dB')
    title('Amplitude spectrum of the signal')
     
    subplot(2, 1, 2)
    plot(f/1000, Xph, 'r')
    grid on
    xlim([0 max(f/1000)])
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
    xlabel('Frequency, kHz')
    ylabel('Phase, \circ')
    title('Phase spectrum of the signal')
    
end

end