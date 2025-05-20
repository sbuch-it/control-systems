%% Sintesi di controllori - Esercizio 4

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (100*(s+10))/(s*(s+20)*(s+50))

%% Guadagno in continua Y/R

kd = 0.2;
kH = 1/kd;

%% Errore di inseguimento

G = zpk(G);
G.DisplayFormat = 'frequency'
kG = 1;

e_ramp = 1/1500;
kc = (kd^2)/(kG*e_ramp);

C = kc/s;

%% Banda passante -> pulsazione di attraversamento

Bw = 90;
wc = 60;

%% Sovraelongazione massima -> margine di fase

s_hat = 20/100;
Mr = (1+s_hat)/(0.9);
fm_rad = (2.3-Mr)/(1.25);
fm = rad2deg(fm_rad);

%% Analisi del sistema ad anello aperto

G1 = C*G*kH;
figure; bode(G1)
[m,f] = bode(G1,wc);
m_dB = 20*log10(m);

%% Progetto della rete anticipatrice

m = 7;
alpha = 1/m;
tau = 3/wc;
Ca = (1+tau*s)/(1+round(alpha*tau,4)*s)

%% Analisi con la doppia rete anticipatrice

G2 = C*Ca*Ca*G*kH;
figure; bode(G2)
[m,f] = bode(G2,wc);
m_dB = 20*log10(m);

%% Analisi del sistema ad anello chiuso

figure; nichols(G2)

W = feedback(G2,1);
figure; bode(W)

figure; step(W)
stepinfo(W)
