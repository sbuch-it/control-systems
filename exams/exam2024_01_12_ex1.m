%% Esame 12-01-2024 - Esercizio 1

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (s+50)/(s*(s+200)*(2*s^2+3*s+2))

%% Guadagno in continua Y/R

kd = 10;
kH = 1/kd;

%% Errore di inseguimento

G = zpk(G);
G.DisplayFormat = 'frequency'
kG = 50/400;

e_step = 0.7;
kc_step = ((kd^2/e_step)-kd)/(kG);

e_ramp = 16;
kc_ramp = (kd^2)/(kG*e_ramp);

C = kc_ramp;

%% Tempo di salita -> pulsazione di attraversamento

Ts = 1;
Bw = 3/Ts;
wc = 2.4; % [1.5 - 2.4]

%% Picco di risonanza -> margine di fase

Mr_dB = 2;
Mr = 10^(Mr_dB/20);
fm_rad = (2.3-Mr)/(1.25);
fm = rad2deg(fm_rad);

%% Analisi del sistema G1 ad anello aperto

G1 = C*G*kH;
figure; bode(G1)
[m,f] = bode(G1,wc);
m_dB = 20*log10(m);

%% Progetto la rete anticipatrice

eps = 9;
fm_delta = (fm-(180+f)+eps)/2;
alpha = (1-sind(fm_delta))/(1+sind(fm_delta));
tau = 1/(wc*sqrt(alpha));
Ca = (1+tau*s)/(1+alpha*tau*s)

%% Analisi del sistema G2 ad anello aperto

G2 = C*Ca*Ca*G*kH;
figure; bode(G2)
[m,f] = bode(G2,wc);
m_dB = 20*log10(m);

%% Progetto la rete ritardatrice

alpha = 10^(-m_dB/20);
tau = 100/wc;
Cr = (1+alpha*tau*s)/(1+tau*s)

%% Analisi del sistema G3 ad anello aperto

G3 = C*Ca*Ca*Cr*G*kH;
figure; bode(G3)
[m,f] = bode(G3,wc);
m_dB = 20*log10(m);

figure; nichols(G3)

%% Analisi del sistema G3 ad anello chiuso

W = feedback(G3,1);
figure; bode(W)

figure; step(W)
