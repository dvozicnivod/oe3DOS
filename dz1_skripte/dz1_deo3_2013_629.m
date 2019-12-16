close all
clear all
clc
%intro

%%
%tacka1

%ucitavanje fajlova
load('..\dz1_signali\lp_filter.mat');
load('..\dz1_signali\sonar_signals.mat');

%racunanje spektrograma TX i RX
fs = 200000;
nfft = 4096;                      
window_width = nfft;               
overlap_num = 3/4*window_width;
ws = hamming(window_width);

[B,frequencies,times] = spectrogram(txSignal(1:220000)', ws, overlap_num, nfft, fs);
B_dB = 20*log10(abs(B));

%prikaz TX
figure;
subplot(2,1,1);
imagesc(times, frequencies(1:end), B_dB(1:end,:));
axis('xy');
xlabel('vreme [s]');
ylabel('ucestanost [Hz]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs) ' ms']);

[B,frequencies,times] = spectrogram(rxSignal(1:220000)', ws, overlap_num, nfft, fs);
B_dB = 20*log10(abs(B));
%prikaz RX
subplot(2,1,2);
imagesc(times, frequencies(1:end), B_dB(1:end,:));
axis('xy');
xlabel('vreme [s]');
ylabel('ucestanost [Hz]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs) ' ms']);

%rezultatni signal
subSignal = rxSignal' .* txSignal';

%racunanje spektrograma rezultatnog signala
fs = 200000;
nfft = 40000;                         
window_width = nfft;                
overlap_num = 3/4*window_width;
ws = hamming(window_width);

[B,frequencies,times] = spectrogram(subSignal', ws, overlap_num, nfft, fs);
B_dB = 20*log10(abs(B));

%prikaz
figure;
imagesc(times, frequencies(1:end), B_dB(1:end,:));
axis('xy');
xlabel('vreme [s]');
ylabel('ucestanost [Hz]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs) ' ms']);

%racunanje blok konvolucije - velicina bloka arbitrarna
bconv = block_convolution(subSignal,lp_filter,50000);

%racunanje spektrograma signala posle filtriranja
[B,frequencies,times] = spectrogram(bconv', ws, overlap_num, nfft, fs);
B_dB = 20*log10(abs(B));

%metri - 40kHz je delta f, a maksimalna dubina 75m jer je trajanje jednog
%        chirpa 100ms, pa je to u metrima
meters = frequencies .* (75/40000);

%prikaz
figure;
imagesc(times, meters(1:end*2/5), B_dB(1:end*2/5,:));
axis('xy');
xlabel('vreme [s]');
ylabel('dubina [m]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs) ' ms']);