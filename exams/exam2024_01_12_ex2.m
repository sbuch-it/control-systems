%% Esame 12-01-2024 - Esercizio 2

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (10*(s+4))/((s^2+1.5*s+1)*(s+400))

%% Domanda 1

KI1 = 6.36;
C1 = KI1/s;

G1 = C1*G;
figure; margin(G1)
[Gm1,Pm1,Wcg1,Wcp1] = margin(G1);

W1 = feedback(G1,1);
figure; bode(W1)

%% Domanda 2

KP2 = 5000;
KI2 = 317000;
C2 = KP2+(KI2/s);

G2 = C2*G;
figure; margin(G2)
[Gm2,Pm2,Wcg2,Wcp2] = margin(G2);

W2 = feedback(G2,1);
figure; bode(W2)
