%%Sintesi di controllori caso 1

clear all
close all
clc

% funzione di trasferimento
s=tf('s');
G=(s+0.1)/(s*(s^2+s+1))

% funzione in forma poli-zeri
G=zpk(G);
G.DisplayFormat='frequency'

kg=0.1; % ricavato dalla forma poli-zeri
kd=2; % rapporto ingresso-uscita Y/R
kh=1/kd;
err_r=0.2; % errore di inseguimento alla rampa unitaria
kc=kd^2/(kg*err_r);

% margine di fase
Mr=3;
fi_m=rad2deg(2.3-10^(Mr/20)/1.25);

ts=0.5; % tempo di salita
B3=3/ts;

wa=4; % scelta del progettista

% verificare se alla pulsazione omega = 4 il modulo vale 0
% e la frequenza è 60 gradi quindi si deve perdere modulo e
% guadagnare fase, serve una rete anticipo-ritardo
L1=kc*kh*G;
bode(L1)

[m,f]=bode(L1,wa)




eps=7; % prevedo dato che la rete ritardatrice perde fase
fase=-180-f+fi_m+eps;
% la fase risulta 60 gradi quindi calcolare la rete anticipatrice
alpha=(1-sind(fase))/(1+sind(fase));
m=1/alpha;
tau=1/wa/sqrt(1/m);

% rete anticipatrice, prima lo zero e poi il polo
Ca=(1+tau*s)/(1+(tau/m)*s)

% aggiungo la rete e verifico
L2=Ca*L1;
[m,f]=bode(L2,wa)
m_dB=20*log10(m); % 27.7850

% rete ritardatrice che perde 27 di modulo
alpha=10^(-m_dB/20);
tau=100/wa; % spostamento di due decadi indietro
Cr=(1+alpha*tau*s)/(1+tau*s);
% rete ritardatrice con prima il polo e poi lo zero

L3=Cr*L2;
[m,f]=bode(L3,wa)

nichols(L3) % active grid
figure;
% la linea non passa dal cerchio di 3 dB
W = feedback(L3,1);
bode(W)
% peak response
figure;
step(W) % risposta al gradino

