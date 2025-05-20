%% Esame 18-12-2018 Fila B - Esercizio 1

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (2*(s+1))/((2*s+1)*(8*s+1)*(100*s+1))

%% Guadagno in continua Y/R

kd = 5;
kH = 1/kd;

%% Errore di inseguimento

G = zpk(G);
G.DisplayFormat = 'frequency'
kG = 2;

e_ramp = 0.5;
kc = (kd^2)/(kG*e_ramp);

C = kc/s;

%% Tempo di salita -> pulsazione di attraversamento

Ts = 25;
Bw = 3/Ts;
wc = 0.08;

%% Picco di risonanza -> margine di fase

Mr_dB = 2;
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
alpha = (1-sind(fm_delta/4))/(1+sind(fm_delta/4));
tau = 1/(wc*sqrt(alpha));
Ca = (1+tau*s)/(1+alpha*tau*s)

%% Analisi con la rete anticipatrice

G2 = Ca*Ca*Ca*Ca*G1;
figure; bode(G2)
[m,f] = bode(G2,wc);
m_dB = 20*log10(m);

%% Progetto della rete ritardatrice

alpha = 10^(-(m_dB/2)/20);
tau = 1000/wc;
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
