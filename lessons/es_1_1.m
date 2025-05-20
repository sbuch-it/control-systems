%% Esercizio 1 su Bode, Nyquist e Nichols

clear all; close all; clc

% Funzione di trasferimento
s = tf('s');
G = (20*(s+2))/((s+10)*(s^2+0.2*s+1))

% Funzione di trasferimento in forma di Bode
G_zpk = zpk(G);
G_zpk.DisplayFormat='frequency'

% Guadagno di Bode, poli e zeri
guadagno = dcgain(G)
poli = pole(G)
zeri = zero(G)

% Diagramma di Bode
figure, bode(G)





