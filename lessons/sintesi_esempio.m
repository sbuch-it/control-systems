%% Sintesi di controllori - Esempio

clear all
close all
clc

% Funzione di trasferimento
s = tf('s');
G = (1)/(s*(1+0.1*s)*(1+0.2*s));

%% Rapporto ingresso uscita y/r = 1
kd = 1;
H = 1/kd;

%% Errore di inseguimento alla rampa lineare err_r <= 1/30
% Errore di inseguimento alla rampa lineare finito, 
% sistema deve essere di tipo 1 ma G(s) è di tipo 1
% quindi h = 0 perché non si aggiunge polo al controllore

err_r = 1/30;
kG = 1; % guadagno di Bode
kc = kd^2/(kG*err_r);

% Picco di risonanza Mr <= 3 dB

MrdB = 3;
Mr = 10^(MrdB/20);

phi_m_rad = (2.3-Mr)/(1.25);
phi_m = rad2deg(phi_m_rad);

% Banda passante Bw >= 12 rad/s










