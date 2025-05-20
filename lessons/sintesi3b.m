%% Sintesi di controllori - Esercizio 3b

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (2.5)/((s+1)*(s+5))

%% Guadagno in continua Y/R

kd = 8;
kH = 1/kd;

%% Errore di inseguimento

G = zpk(G);
G.DisplayFormat = 'frequency'
kG = 0.5;

e_step = 0.1;
kc_step = ((kd^2/e_step)-kd)/(kG);

e_ramp = 0.4;
kc_ramp = (kd^2)/(kG*e_ramp);

C = kc_ramp/s;

%% Tempo di salita -> pulsazione di attraversamento

Ts = 0.25;
Bw = 3/Ts;
wc = 8;

%% Picco di risonanza -> margine di fase

Mr_dB = 1.5;
Mr = 10^(Mr_dB/20);
fm_rad = (2.3-Mr)/(1.25);
fm = rad2deg(fm_rad);

%% Analisi del sistema ad anello aperto

G1 = C*G*kH;
figure; bode(G1)
[m,f] = bode(G1,wc);
m_dB = 20*log10(m);

%% Progetto della rete anticipatrice

fm_delta = 120/4;
alpha = (1-sind(fm_delta))/(1+sind(fm_delta));
tau = 1/(wc*sqrt(alpha));
Ca = (1+round(tau,1)*s)/(1+round(alpha*tau,2)*s)

%% Analisi con la rete anticipatrice

G2 = C*Ca*Ca*Ca*Ca*G*kH;
figure; bode(G2)
[m,f] = bode(G2,wc);
m_dB = 20*log10(m);

%% Progetto della rete ritardatrice

alpha = 10^(-m_dB/20);
tau = 100/wc;
Cr = (1+round(alpha*tau,1)*s)/(1+round(tau,1)*s)

%% Analisi con la rete ritardatrice

G3 = C*Ca*Ca*Ca*Ca*Cr*G*kH;
figure; bode(G3)
[m,f] = bode(G3,wc);
m_dB = 20*log10(m);

%% Analisi del sistema ad anello chiuso

figure; nichols(G3)

W = feedback(G3,1);
figure; bode(W)

figure; step(W)
stepinfo(W)
