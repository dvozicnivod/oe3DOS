clear all
close all
clc

%intro

%%
%tacka 1

%ucestanosti kosinusoida
f1 = 1;
f2 = 3;
f3 = 7;
fs = 100;       %ucestanost odabiranja
Ts = 1 / fs;    %perioda odabiranja

%broj tacaka u kojima odabiramo signal
N1 = 32;
N2 = 128;
N3 = 1024;
%odgovarajuce vremenske ose
t1 = 0 : Ts : (N1-1)*Ts;
t2 = 0 : Ts : (N2-1)*Ts;
t3 = 0 : Ts : (N3-1)*Ts;
%osa odbiraka
n1 = 0:N1-1;
n2 = 0:N2-1;
n3 = 0:N3-1;

%semplovani signali
x1 = cos(2*pi*f1*t1) + 0.5*cos(2*pi*f2*t1)+3*cos(2*pi*f3*t1);
figure('NumberTitle', 'off', 'Name', 'semplovani signal x(t)');
subplot(3,1,1);
plot(t1,x1), axis('xy'), ylabel('amplituda [V]'), xlabel (' vreme [s]' ), title('N1 = 32'), xlim([0 t1(end)]);

x2 = cos(2*pi*f1*t2) + 0.5*cos(2*pi*f2*t2)+3*cos(2*pi*f3*t2);
subplot(3,1,2);
plot(t2,x2), axis('xy'), ylabel('amplituda [V]'), xlabel (' vreme [s]' ), title('N2 = 128'), xlim([0 t2(end)]);

x3 = cos(2*pi*f1*t3) + 0.5*cos(2*pi*f2*t3)+3*cos(2*pi*f3*t3);
subplot(3,1,3);
plot(t3,x3), axis('xy'), ylabel('amplituda [V]'), xlabel (' vreme [s]' ), title('N3 = 1024'), xlim([0 t3(end)]);

%fft semplovanih signala
X1fft = fft(x1, N1);
X2fft = fft(x2, N2);
X3fft = fft(x3, N3);
%freq osa
freqs1 = fs/length(X1fft)*(0 : length(X1fft)/2 - 1);
freqs2 = fs/length(X2fft)*(0 : length(X2fft)/2 - 1);
freqs3 = fs/length(X3fft)*(0 : length(X3fft)/2 - 1);
%izdvajanje znacajnih frekvencija
freqs1 = freqs1(freqs1 < fs/5);
freqs2 = freqs2(freqs2 < fs/5);
freqs3 = freqs3(freqs3 < fs/5);
%izdvajanje bitnog dela spektra
X1fft = X1fft(1:length(freqs1));
X2fft = X2fft(1:length(freqs2));
X3fft = X3fft(1:length(freqs3));

%plotovanje
figure('NumberTitle', 'off', 'Name', 'fft semplovanih signala');

subplot(3,1,1);
stem(freqs1,abs(X1fft)),xlabel('ucestanost [Hz]'),ylabel('|X1(k)|'),title('FFT X1');

subplot(3,1,2);
stem(freqs2,abs(X2fft)),xlabel('ucestanost [Hz]'),ylabel('|X2(k)|'),title('FFT X2');

subplot(3,1,3);
stem(freqs3,abs(X3fft)),xlabel('ucestanost [Hz]'),ylabel('|X3(k)|'),title('FFT X3');

pause
%%
%tacka 2

%tri najvece frekvencijske komponente i njihove lokacije
[pks1, locs1] = findpeaks(abs(X1fft),'SortStr','descend','NPeaks',3);
[pks2, locs2] = findpeaks(abs(X2fft),'SortStr','descend','NPeaks',3);
[pks3, locs3] = findpeaks(abs(X3fft),'SortStr','descend','NPeaks',3);

dominantComp1 = freqs1(locs1);
dominantComp2 = freqs2(locs2);
dominantComp3 = freqs3(locs3);

%greska
%prvi spektar prepoznaje samo jednu dominantnu komponentu
error2 = dominantComp2 - [7,1,3];       %pikove nalazi u fiksnom rasporedu
error3 = dominantComp3 - [7,1,3];       %i ja to koristim bestidno

%plotovanje (ESTETIKA APSOLUTNI PRIORITET xD)
figure('NumberTitle', 'off', 'Name', 'dominantne komponente i greske');
subplot(3,2,1), title('X1 komponente');
text(0.1,0.5, num2str(dominantComp1)), axis off;
subplot(3,2,3), title('X2 komponente');
text(0.1,0.5, num2str(dominantComp2)), axis off;
subplot(3,2,5), title('X3 komponente');
text(0.1,0.5, num2str(dominantComp3)), axis off;
subplot(3,2,2), title('X1 greska');
text(0.1,0.5, num2str('NaN')), axis off;
subplot(3,2,4), title('X2 greska');
text(0.1,0.5, num2str(error2)), axis off;
subplot(3,2,6), title('X3 greska');
text(0.1,0.5, num2str(error3)), axis off;

pause
%%
%tacka 3
%@brief: zahtev da prozorska funkcija ima odbirke koji na krajevima 
%        opadaju do nule pruza izbor od mnogo funkcija, odlucio sam se za
%        Blackman-ovu prozorsku funkciju

%generisanje prozorskih f-ja
blackWindow1 = blackman(N1);
blackWindow2 = blackman(N2);
blackWindow3 = blackman(N3);

%primenjivanje, ista imena promenljivih radi code reusablity
x1 = x1 .* blackWindow1';
x2 = x2 .* blackWindow2';
x3 = x3 .* blackWindow3';

%signali
figure('NumberTitle', 'off', 'Name', 'novi signal x(t)');
subplot(3,1,1);
plot(t1,x1), axis('xy'), ylabel('amplituda [V]'), xlabel (' vreme [s]' ), title('N1 = 32'), xlim([0 t1(end)]);
subplot(3,1,2);
plot(t2,x2), axis('xy'), ylabel('amplituda [V]'), xlabel (' vreme [s]' ), title('N2 = 128'), xlim([0 t2(end)]);
subplot(3,1,3);
plot(t3,x3), axis('xy'), ylabel('amplituda [V]'), xlabel (' vreme [s]' ), title('N3 = 1024'), xlim([0 t3(end)]);

%fft signala
X1fft = fft(x1, N1);
X2fft = fft(x2, N2);
X3fft = fft(x3, N3);
%freq osa
freqs1 = fs/length(X1fft)*(0 : length(X1fft)/2 - 1);
freqs2 = fs/length(X2fft)*(0 : length(X2fft)/2 - 1);
freqs3 = fs/length(X3fft)*(0 : length(X3fft)/2 - 1);
%izdvajanje znacajnih frekvencija
freqs1 = freqs1(freqs1 < fs/5);
freqs2 = freqs2(freqs2 < fs/5);
freqs3 = freqs3(freqs3 < fs/5);
%izdvajanje bitnog dela spektra
X1fft = X1fft(1:length(freqs1));
X2fft = X2fft(1:length(freqs2));
X3fft = X3fft(1:length(freqs3));

%plotovanje
figure('NumberTitle', 'off', 'Name', 'fft novih signala');

subplot(3,1,1);
stem(freqs1,abs(X1fft)),xlabel('ucestanost [Hz]'),ylabel('|X1(k)|'),title('FFT X1');

subplot(3,1,2);
stem(freqs2,abs(X2fft)),xlabel('ucestanost [Hz]'),ylabel('|X2(k)|'),title('FFT X2');

subplot(3,1,3);
stem(freqs3,abs(X3fft)),xlabel('ucestanost [Hz]'),ylabel('|X3(k)|'),title('FFT X3');

pause
%%
%tacka 4
%tri najvece frekvencijske komponente i njihove lokacije
[pks1, locs1] = findpeaks(abs(X1fft),'SortStr','descend','NPeaks',3);
[pks2, locs2] = findpeaks(abs(X2fft),'SortStr','descend','NPeaks',3);
[pks3, locs3] = findpeaks(abs(X3fft),'SortStr','descend','NPeaks',3);

dominantComp1 = freqs1(locs1);
dominantComp2 = freqs2(locs2);
dominantComp3 = freqs3(locs3);

%greska
%prvi spektar prepoznaje samo jednu dominantnu komponentu
error2 = dominantComp2 - [7,1,3];
error3 = dominantComp3 - [7,1,3];

%plotovanje (ESTETIKA APSOLUTNI PRIORITET xD)
figure('NumberTitle', 'off', 'Name', 'dominantne komponente i greske');
subplot(3,2,1), title('X1 komponente');
text(0.1,0.5, num2str(dominantComp1)), axis off;
subplot(3,2,3), title('X2 komponente');
text(0.1,0.5, num2str(dominantComp2)), axis off;
subplot(3,2,5), title('X3 komponente');
text(0.1,0.5, num2str(dominantComp3)), axis off;
subplot(3,2,2), title('X1 greska');
text(0.1,0.5, num2str('NaN')), axis off;
subplot(3,2,4), title('X2 greska');
text(0.1,0.5, num2str(error2)), axis off;
subplot(3,2,6), title('X3 greska');
text(0.1,0.5, num2str(error3)), axis off;