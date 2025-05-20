%% Esame 18-12-2018 Fila A - Esercizio 1

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (250*(s+100))/(s*(s+5)*(s+50)^2)

%% Guadagno in continua Y/R

kd = 0.1;
kH = 1/kd;

%% Errore di inseguimento

G = zpk(G);
G.DisplayFormat = 'frequency'
kG = 2;

e_ramp = 2*(10)^(-3);
kc = (kd^2)/(kG*e_ramp);

C = kc;

%% Tempo di salita -> pulsazione di attraversamento

Ts = 0.1;
Bw = 3/Ts;
wc = 20;

%% Picco di risonanza -> margine di fase

Mr_dB = 1;
Mr = 10^(Mr_dB/20);
fm_rad = (2.3-Mr)/(1.25);
fm = rad2deg(fm_rad);

%% Analisi del sistema ad anello aperto

G1 = C*G*kH;
figure; bode(G1)
[m,f] = bode(G1,wc);
m_dB = 20*log10(m);

%% Progetto della rete anticipatrice

eps = 8;
fm_delta = fm-(180+f)+eps;
alpha = (1-sind(fm_delta))/(1+sind(fm_delta));
tau = 1/(wc*sqrt(alpha));
Ca = (1+tau*s)/(1+alpha*tau*s)

%% Analisi con la rete anticipatrice

G2 = Ca*G1;
figure; bode(G2)
[m,f] = bode(G2,wc);
m_dB = 20*log10(m);

%% Progetto della rete ritardatrice

alpha = 10^(-(m_dB/2)/20);
tau = 100/wc;
Cr = (1+alpha*tau*s)/(1+tau*s)

%% Analisi con la doppia rete ritardatrice

G3 = Cr*Cr*G2;
figure; bode(G3)
[m,f] = bode(G3,wc);
m_dB = 20*log10(m);

%% Analisi del sistema ad anello chiuso

figure; nichols(G3)

W = feedback(G3,1);
figure; bode(W)

figure; step(W)
stepinfo(W)
