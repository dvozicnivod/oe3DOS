clear all
close all
clc
%intro

%%
%tacka 1 - pogledati fajl block_convolution.m

pause
%%
%tacka 2

%ucitavanje fajlova
load('..\dz1_signali\impulse_response_birds.mat');
[x,fs] = audioread('..\dz1_signali\birds_airplane.wav');

%racunanje fft impulsnog odziva
H = fft(impulse_response);
figure('NumberTitle', 'off', 'Name', 'dft implusnog odziva');
plot(abs(fftshift(H))),xlim([0,length(H)]);

%racunanje blok konvolucije - velicina bloka arbitrarna
bconv = block_convolution(x,impulse_response,5000);

pause
%%
%tacka 3

%Hamingov prozor
nfft = 4096; 
window_width = nfft;
overlap_num = 3/4*window_width;
ws = hamming(window_width);

%racunanje spektrograma
[B,frequencies,times] = spectrogram(x, ws, overlap_num, nfft, fs);
B_dB = 20*log10(abs(B));        %u dB

% prikaz spektrograma orginalnog signala
figure
subplot(1,2,1);
imagesc(times, frequencies(1:end), B_dB(1:end,:));
axis('xy');
xlabel('vreme [s]');
ylabel('ucestanost [Hz]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs) ' ms']);

%racunanje spektrograma konvolucije
[B,frequencies,times] = spectrogram(bconv, ws, overlap_num, nfft, fs);
B_dB = 20*log10(abs(B)); %u dB

% prikaz spektrograma konvolucije
subplot(1,2,2);
imagesc(times, frequencies(1:end), B_dB(1:end,:));
axis('xy');
xlabel('vreme [s]');
ylabel('ucestanost [Hz]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs) ' ms']);

pause
%%
%tacka 4

audiowrite('..\dz1_signali\pticice.wav',bconv,fs);
bconv = bconv .* 10000;
audiowrite('..\dz1_signali\pticice_pojacan.wav',bconv,fs);
