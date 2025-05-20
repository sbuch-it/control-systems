%% Esame 21-12-2020 - Esercizio 2

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (10)/((1+0.1*s)^2*(1+0.001*s));

Gz = zero(G)
Gp = pole(G)

% Sistema stabile se tutte le radici nel semipiano sinistro
figure; rlocus(G) % instabile con 2 PD
figure; rlocus(-G) % instabile con 1 PD

%% 1. Controllore puramente proporzionale

KP1 = 50;
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

%% 3. Controllore PI con Bw > 100 rad/s

KP3 = 10;
KI3 = 1;
C3 = KP3+(KI3/s);
G3 = C3*G;

figure; rlocus(G3) % instabile con 2 PD
figure; rlocus(-G3) % instabile con 1 PD

W3 = feedback(G3,1);
figure; bode(W3);

%% 4. Controllore puramente integrale con 2.5dB < Mr < 3dB

KI = 30;
C4 = KI/s;
G4 = C4*G;

W4 = feedback(G4,1);
figure; bode(W4)
