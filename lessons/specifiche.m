%% Specifiche

clear all; close all; clc

% Funzione di trasferimento
s = tf('s');
G1 = ((1+s)*(1+0.1*s))/(s^3);
G = G1

% Margine di fase e di guadagno
[Gm,Pm,Wcg,Wcp] = margin(G)



