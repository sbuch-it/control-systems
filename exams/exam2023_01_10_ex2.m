%% Esame 10-01-2023 - Esercizio 2

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (s+10)/(s^2*(s+1)*(s+100))

Gz = zero(G)
Gp = pole(G)

% Sistema stabile se tutte le radici nel semipiano sinistro
figure; rlocus(G) % instabile con 2 PD
figure; rlocus(-G) % instabile con 1 PD

%% 1. Controllore puramente proporzionale

KP1 = 100;
C1 = KP1;
G1 = C1*G;

figure; rlocus(G1) % instabile con 2 PD
figure; rlocus(-G1) % instabile con 1 PD

%% 2. Controllore PI

KP2 = 1;
KI2 = 1;
C2 = KP2+(KI2/s);
G2 = C2*G;

figure; rlocus(G2) % instabile con 2 PD
figure; rlocus(-G2) % instabile con 1 PD

%% 3. Controllore PD

KP3 = 1;
KD3 = 1;
C3 = KP3+(KD3*s);
G3 = C3*G;

figure; rlocus(G3) % stabile
figure; rlocus(-G3) % instabile con 1 PD

%% 3. Controllore PD con margine di fase = 45°

KP4 = 92.5;
KD4 = 100;
C4 = KP4+(KD4*s);
G4 = C4*G;

W = feedback(G4,1);
figure; margin(W);
[Gm,Pm,Wcg,Wcp] = margin(W);
