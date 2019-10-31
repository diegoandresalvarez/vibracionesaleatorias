%https://commons.wikimedia.org/wiki/File:STFT_colored_spectrogram_125ms.png

clc, close all, clear;

%sampling frequency
fc=400;
%duration of the signal
T=20;
%zero padding factor
my_zero=10;

%generate the signal
t=linspace(0,T,fc*T);
x=zeros(1,length(t));
%thresholds
th1=0.25*T*fc;
th2=0.5*T*fc;
th3=0.75*T*fc;
th4=T*fc;
x(1:th1)=cos(2*pi*10*t(1:th1));
x((th1+1):th2)=cos(2*pi*25*t((th1+1):th2));
x((th2+1):th3)=cos(2*pi*50*t((th2+1):th3));
x((th3+1):th4)=cos(2*pi*100*t((th3+1):th4));

%calculate and show the spectrograms
[spectrogram, axisf, axist]=stft(x,10,1,fc,'blackman',my_zero);
spectrogram=spectrogram/max(spectrogram(:));
figure,imagesc(axist,axisf,spectrogram),
title('Spectrogram with T = 25 ms'),
ylabel('frequency [Hz]'),
xlabel('time [s]'), 
colorbar;

[spectrogram, axisf, axist]=stft(x,50,1,fc,'blackman',my_zero);
spectrogram=spectrogram/max(spectrogram(:));
figure,imagesc(axist,axisf,spectrogram),
title('Spectrogram with T = 125 ms'),
ylabel('frequency [Hz]'),
xlabel('time [s]'), 
colorbar;

[spectrogram, axisf, axist]=stft(x,150,1,fc,'blackman',my_zero);
spectrogram=spectrogram/max(spectrogram(:));
figure,imagesc(axist,axisf,spectrogram),
title('Spectrogram with T = 375 ms'),
ylabel('frequency [Hz]'),
xlabel('time [s]'), 
colorbar;

[spectrogram, axisf, axist]=stft(x,400,1,fc,'blackman',my_zero);
spectrogram=spectrogram/max(spectrogram(:));
figure,imagesc(axist,axisf,spectrogram),
title('Spectrogram with T = 1000 ms'),
ylabel('frequency [Hz]'),
xlabel('time [s]'), 
colorbar;
 
