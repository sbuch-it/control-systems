%% Esame 17-12-2014 - Esercizio 2

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = ((s+100)^2)/((s^2+s+1)*(s+1))

%% Picco di risonanza -> margine di fase

Mr_dB = 1;
Mr = 10^(Mr_dB/20);
fm_rad = (2.3-Mr)/(1.25);
fm = rad2deg(fm_rad);

%% Analisi del sistema G1 ad anello aperto

C1 = 1/s;
G1 = C1*G;
figure; bode(G1)

%% Analisi del sistema G2 ad anello aperto

C2 = (1+s)/s;
G2 = C2*G;
figure; bode(G2)

%% Analisi del sistema G3 ad anello aperto

C3 = (350*(1+s))/s;
G3 = C3*G;
figure; bode(G3)

%% Analisi del sistema G3 ad anello chiuso

figure; nichols(G3)

%% Analisi del sistema G4 ad anello aperto

C4 = (1500*(1+s))/s;
G4 = C4*G;
figure; bode(G4)

%% Analisi del sistema G4 ad anello chiuso

figure; nichols(G4)

W = feedback(G4,1);
figure; bode(W)
