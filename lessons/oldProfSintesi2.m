%% Sintesi di controllori caso 2

clear all
close all
clc

% funzione di trasferimento
s=tf('s');
G=(s*10^6)/(s^2+s*3*10^3+10^6)

% funzione in forma poli-zeri
G=zpk(G);
G.DisplayFormat='frequency'

kg=1; % ricavato dalla forma poli-zeri
kd=1; % rapporto ingresso-uscita Y/R
kh=1/kd;
err_r=10^(-2); % errore di inseguimento alla rampa unitaria
kc=kd^2/(kg*err_r);

C=kc/s^2; % tipo 1

% margine di fase
Mr=3;
fi_m=rad2deg(2.3-10^(Mr/20)/1.25)

B3=800;

wa=500; % scelta del progettista
% valore tra 400 e 640

% verificare se alla pulsazione omega = 4 il modulo vale 0
% e la frequenza è 60 gradi quindi si deve perdere modulo e
% guadagnare fase, serve una rete anticipo-ritardo
L1=C*kh*G;
bode(L1)
figure

[m,f]=bode(L1,wa) % fase -153.4349
m_dB=20*log10(m) % -18.4703

% guadagnare 18 dalla carta normalizzata del modulo si sceglie m=9
% considerare la carta normalizzata della fase per m = 9
tau=0.04;
m=tau/9;

% rete anticipatrice, prima lo zero e poi il polo
Ca=(1+tau*s)/(1+(m)*s)

% aggiungo la rete e verifico
L2=Ca*L1;
[m,f]=bode(L2,wa)
m_dB=20*log10(m)


W = feedback(L2,1);
bode(W)
% peak response
figure;
step(W) % risposta al gradino


