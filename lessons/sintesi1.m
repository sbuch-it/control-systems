%% Sintesi di controllori - Esercizio 1

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (s+0.1)/(s*(s^2+s+1))

%% Guadagno in continua Y/R

kd = 2;
kH = 1/kd;

%% Errore di inseguimento

G = zpk(G);
G.DisplayFormat = 'frequency'
kG = 0.1;

e_ramp = 0.2;
kc = (kd^2)/(kG*e_ramp);

C = kc;

%% Tempo di salita -> pulsazione di attraversamento

Ts = 0.5;
Bw = 3/Ts;
wc = 4;

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

eps = 7;
fm_delta = fm-(180+f)+eps;
alpha = (1-sind(fm_delta))/(1+sind(fm_delta));
tau = 1/(wc*sqrt(alpha));
Ca = (1+round(tau,1)*s)/(1+round(alpha*tau,1)*s)

%% Analisi specifiche ad anello aperto

G2 = C*Ca*G*kH;
figure; bode(G2)
[m,f] = bode(G2,wc);
m_dB = 20*log10(m);

%% Progetto della rete ritardatrice

alpha = 10^(-m_dB/20);
tau = 100/wc;
Cr = (1+round(alpha*tau,1)*s)/(1+round(tau,1)*s)

%% Analisi con la rete ritardatrice

G3 = C*Ca*Cr*G*kH;
figure; bode(G3)
[m,f] = bode(G3,wc);
m_dB = 20*log10(m);

%% Specifiche del sistema ad anello chiuso

figure; nichols(G3)

W = feedback(G3,1);
figure; bode(W)

figure; step(W)
stepinfo(W)
