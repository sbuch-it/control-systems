%% Esame 17-12-2014 - Esercizio 1

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (800*(s+7)^2)/(s*(s+20)^2*(s^2+s+1))

%% Guadagno in continua Y/R

kd = 100;
kH = 1/kd;

%% Errore di inseguimento

G = zpk(G);
G.DisplayFormat = 'frequency'
kG = 98;

e_ramp = 5;
kc = (kd^2)/(kG*e_ramp);

C = 25;

%% Tempo di salita -> pulsazione di attraversamento

Ts = 0.4;
Bw = 3/Ts;
wc = 5;

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

eps = 8;
fm_delta = (fm-(180+f)+eps)/2;
alpha = (1-sind(fm_delta))/(1+sind(fm_delta));
tau = 1/(wc*sqrt(alpha));
Ca = (1+round(tau,2)*s)/(1+round(alpha*tau,2)*s)

%% Analisi con la doppia rete anticipatrice

G2 = C*Ca*Ca*G*kH;
figure; bode(G2)
[m,f] = bode(G2,wc);
m_dB = 20*log10(m);

%% Progetto della rete ritardatrice

alpha = 10^(-m_dB/20);
tau = 100/wc;
Cr = (1+alpha*tau*s)/(1+tau*s)

%% Analisi con la rete ritardatrice

G3 = C*Ca*Ca*Cr*G*kH;
figure; bode(G3)
[m,f] = bode(G3,wc);
m_dB = 20*log10(m);

%% Analisi del sistema ad anello chiuso

figure; nichols(G3)

W = feedback(G3,1);
figure; bode(W)

figure; step(W)
stepinfo(W)

%% Progetto della nuova rete anticipatrice

alpha = 0.13;
tau = 0.45;
Ca = (1+tau*s)/(1+round(alpha*tau,2)*s)

%% Analisi con la nuova rete ritardatrice

G4 = C*Ca*Ca*Cr*G*kH;
figure; bode(G4)
[m,f] = bode(G4,wc);
m_dB = 20*log10(m);

%% Analisi del sistema ad anello chiuso

figure; nichols(G4)

W = feedback(G4,1);
figure; bode(W)

figure; step(W)
stepinfo(W)
