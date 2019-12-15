function y = block_convolution(x, h, block_length)
%%  block_convolution 
%@brief:        ra?una blok konvoluciju signala
%               x i h u zadatoj veli?ini bloka
%               ***sta se desava***
%@input params: x, h - vektorski signali 
%               block_lenght - brojna vrednost, velicina bloka
%@output param: y - vektorski signal koji prestavlja blok konvoluciju x i h


L = block_length;                                                          
%h = struct2array(h);

x = transpose(x);
N1 = length(x);         %duzina niza x
M = length(h);          %duzina niza h
N = N1+M-1;             %duzina konacnog niza.
y = zeros(1,2*N);       %instanciranje konacnog niza

Nparc = L + M - 1;      %broj clanova parcijalne konvolucije
h(Nparc) = 0;           %dopunjavanje nulama!
H = fft(h);

%algoritam za odredjivanje konvolucije
%i1 odredjuje pocetnu tacku od koje uzimamo L elemenata niza x
%u x2 sacuvamo L elemenata niza x, i dopunimo ga nulama
for i1 = 1 : L : N1                         
     if i1 < N - mod(N,L) 
        x2 = x(i1:i1+L-1);
     else
        x2 = x(i1:N1);
     end
        x2(Nparc) = 0;               
        X2 = fft(x2);                                   
        Y = X2.*H;
        ytemp = ifft(Y);                                                   
        y(i1:i1+Nparc-1) = y(i1:i1+Nparc-1)+ytemp(1:Nparc);
 end
y = y(1 : N);  %skracivanje y na samo one elemente koji ulaze u konvoluciju
