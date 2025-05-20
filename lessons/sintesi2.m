%% Sintesi di controllori - Esercizio 2

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (s*10^6)/(s^2+s*3*10^3+10^6)

%% Guadagno in continua Y/R

kd = 1;
kH = 1/kd;

%% Errore di inseguimento

G = zpk(G);
G.DisplayFormat = 'frequency'
kG = 1;

e_ramp = 10^(-2);
kc = (kd^2)/(kG*e_ramp);

C = kc/(s^2);

%% Banda passante -> pulsazione di attraversamento

Bw = 800;
wc = 500;

%% Picco di risonanza -> margine di fase

Mr_dB = 3;
Mr = 10^(Mr_dB/20);
fm_rad = (2.3-Mr)/(1.25);
fm = rad2deg(fm_rad);

%% Analisi del sistema ad anello aperto

G1 = C*G*kH;
figure; bode(G1)
[m,f] = bode(G1,wc);
m_dB = 20*log10(m);

%% Progetto della rete anticipatrice

m = 9;
alpha = 1/m;
tau = 20/wc;
Ca = (1+tau*s)/(1+alpha*tau*s)

%% Analisi con la rete anticipatrice

G2 = C*Ca*G*kH;
figure; bode(G2)
[m,f] = bode(G2,wc);
m_dB = 20*log10(m);

%% Analisi del sistema ad anello chiuso

figure; nichols(G2)

W = feedback(G2,1);
figure; bode(W)

figure; step(W)
stepinfo(W)
