close all
clear all
clc
%intro

%%
%tacka 6

%parametri signala
fs = 8000;          %freq odabiranja [Hz]
Ts = 1/fs;          %period odabiranja
t = 0 : Ts : 5;     %vreme u [s]
N = length(t);      %broj odbiraka
tetha0 = 0;         %pocetna faza - arbitratno uzeta za 0
f0 = 0;             %ucestanost u pocetnom trenutku, zadato 0
beta = fs/10;       %nagib linearne funkcije po kojoj raste f, zadato 5/2

%generianje signala
xChi =  sin (tetha0 + 2*pi*(f0.*t + beta/2 .*t.^2));
figure('NumberTitle', 'off', 'Name', 'chirp signal');
plot(t,xChi), axis('xy'), ylabel('amplituda'), xlabel (' vreme [s]' );

%pustanje ovog signala na zvucnicima
chirpAudio = audioplayer(xChi, fs);
chirpAudio.play;

pause
%%
%tacka 7

%decimacija
xChi2 = xChi(1:2:N);
xChi5 = xChi(1:5:N); 
 
chirp2Audio = audioplayer(xChi2,fs/2);
chirp5Audio = audioplayer(xChi5,fs/5);

chirp2Audio.play;
pause
chirp5Audio.play;
pause
%%
%tacka 8
%@brief:    spektogrami

%Hamingov prozor
nfft = 4096; 
window_width = nfft;
overlap_num = 3/4*window_width;

ws = hamming(window_width);

%racunanje spektrograma
[B,frequencies,times] = spectrogram(xChi, ws, overlap_num, nfft, fs);
B_dB = 20*log10(abs(B)); %u dB

% prikaz spektrograma orginalnog signala

figure
imagesc(times, frequencies(1:end/4), B_dB(1:end/4,:));
axis('xy');
xlabel('vreme [s]');
ylabel('ucestanost [Hz]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs) ' ms']);

pause

%racunanje spektrograma decimiranih signala
[B,frequencies,times] = spectrogram(bconv, ws, overlap_num, nfft, fs);
B_dB = 20*log10(abs(B)); %u dB

% prikaz spektrograma
figure
imagesc(times, frequencies(1:end/4), B_dB(1:end/4,:));
axis('xy');
xlabel('vreme [s]');
ylabel('ucestanost [Hz]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs) ' ms']);

pause
%%
%tacka 9

clear all
close all
clc

%ucitavanje signala x
[x,fs] = audioread('dz1_signali\chopin.wav');

%Hamingov prozor
nfft = 4096; 
window_width = nfft;
overlap_num = 3/4*window_width;

ws = hamming(window_width);

%racunanje spektrograma
[B,frequencies,times] = spectrogram(x, ws, overlap_num, nfft, fs);
B_dB = 20*log10(abs(B)); %u dB

% prikaz spektrograma
figure;
imagesc(times, frequencies(1:end/4), B_dB(1:end/4,:));
axis('xy');
xlabel('vreme [s]');
ylabel('ucestanost [Hz]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs) ' ms']);

pause
%%
%tacka 10

%koliko puta je smanjena ucestanost odabiranja
%uzimam svaki n-ti odbirak
n=24;

xd = x(1:n:length(x));

%nova ucestanost je n puta manja
fs_d=fs/n;

time = length(xd)/(fs_d);  %u sekundama
t = 1/fs_d:1/fs_d:time;

pause

%Hamingov prozor
nfft = 4096; 
window_width = nfft;
overlap_num = 3/4*window_width;

ws = hamming(window_width);

%racunanje spektrograma
[B,frequencies,times] = spectrogram(xd, ws, overlap_num, nfft, fs_d);
B_dB = 20*log10(abs(B)); %u dB

% prikaz spektrograma
figure;
imagesc(times, frequencies(1:end/4), B_dB(1:end/4,:));
axis('xy');
xlabel('vreme [s]');
ylabel('ucestanost [Hz]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs_d) ' ms']);
pause