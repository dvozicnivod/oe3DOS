clear all
close all
clc

load('..\dz1_signali\impulse_response_birds.mat');

[x,fs] = audioread('..\dz1_signali\birds_airplane.wav');

H = fft(impulse_response);
figure;
plot(abs(H));

bconv = block_convolution(x,impulse_response,5000);

%Hamingov prozor
nfft = 4096; 
window_width = nfft;
overlap_num = 3/4*window_width;

ws = hamming(window_width);

%racunanje spektrograma
[B,frequencies,times] = spectrogram(x, ws, overlap_num, nfft, fs);
B_dB = 20*log10(abs(B)); %u dB

% prikaz spektrograma orginalnog signala

figure
subplot(1,2,1);
imagesc(times, frequencies(1:end/4), B_dB(1:end/4,:));
axis('xy');
xlabel('vreme [s]');
ylabel('ucestanost [Hz]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs) ' ms']);


%racunanje spektrograma konvolucije
[B,frequencies,times] = spectrogram(bconv, ws, overlap_num, nfft, fs);
B_dB = 20*log10(abs(B)); %u dB

% prikaz spektrograma
subplot(1,2,2);
imagesc(times, frequencies(1:end/4), B_dB(1:end/4,:));
axis('xy');
xlabel('vreme [s]');
ylabel('ucestanost [Hz]');
title(['Spektrogram za T = ' num2str(1000*window_width/fs) ' ms']);

pause
audiowrite('pticice.wav',bconv,fs);

for i=1:length(bconv)
    
    bconv(i)= 1000* bconv(i);
    
end;

audiowrite('pticice_pojacan.wav',bconv,fs);
