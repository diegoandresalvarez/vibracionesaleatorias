%% Interpolacion en el tiempo utilizando el algoritmo ifft() y la funcion interpft()

% From: Bruno Luong
% Date: 17 Jul, 2012 03:42:20
% http://www.mathworks.com/matlabcentral/newsreader/view_thread/321829

% Ver tambien:
% http://www.embedded.com/design/other/4212939/Time-domain-interpolation-using-the-Fast-Fourier-Transform-

clear, close all

%% The function to be interpolated
n = 40;
x = linspace(-3, 5, n);
y = 1./((x - 0.5).^2 + 1);
% y = 1.2*sin(3.5*x) + 2*sin(1.6*x + 2);

%% Pad the high frequency
padsize = 100/2;

z = fft(y);
if mod(n, 2) % n is odd (impar)
    zp = ifftshift([zeros(1,padsize) fftshift(z) zeros(1,padsize)]);
else % n is even (par)
    zp = fftshift(z);    
    % This step "zp(1)/2 zp(2:end) zp(1)/2" to guarantee symmetry. Note
    % that zp(1) is a real number.
    zp = ifftshift([zeros(1,padsize) zp(1)/2 zp(2:end) zp(1)/2 zeros(1,padsize-1)]);
end

%% Resampling, renormalization
xp = linspace(x(1), x(end), length(zp));
yp = ifft(zp)/length(z)*length(zp); %compensate for the amplitude loss induced by interpolation

%% Plot the results
figure
plot(xp,yp,'b-', x, y,'rx', xp, interpft(y, length(zp)), 'm.')
legend('interpolacion con ifft()', 'puntos originales', 'interpft()')