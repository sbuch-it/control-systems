%% Bode, Nyquist e Nichols

clear all; close all; clc

% Funzione di trasferimento
s = tf('s');
G1 = (20*(s+2))/((s+10)*(s^2+0.2*s+1));
G2 = (3*(s^2+9))/((1+s)*(s^2+4)*(1+0.2*s));
G3 = (100*(s*(s-1)))/((3*s^2+12*s+9)*(s+5));
G4 = ((s+1)*(s+4))/(s*(s+10)*(4*s^2+0.1*s+1));
G = G4

% Guadagno di Bode, poli e zeri
gain = dcgain(G)
poles = pole(G)
zeros = zero(G)

% Diagramma di Bode
bode(G);
figure;

% Picco di risonanza e relativa pulsazione
[gpeak,fpeak] = getPeakGain(G)
gpeak_dB = 20 * log10(gpeak)

% Modulo e fase per omega = 5rad/s
omega = 5;
[mag,phase] = bode(G,omega)
mag_dB = 20 * log10(mag)

% Frequenza di attraversamento 0 dB e fase a tale frequenza
[Gm,Pm,Wcg,Wcp] = margin(G);
freq0db = Wcp
[mag,phase] = bode(G,freq0db);
phase0dB = phase

% Diagramma di Nyquist
nyquist(G);
figure;

% Diagramma di Nichols
nichols(G);
figure;

% Risposta al gradino unitario ad anello aperto
step(G)
title('Step Response - Feedforward');
figure;

% Risposta al gradino unitario ad anello chiuso
W = feedback(G,1);
title('Step Response - Feedback');
step(W)
