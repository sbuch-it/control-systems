clear all; close all; clc

% Funzione di trasferimento
s = tf('s');
%G = (s+1)/(s^2+0.5*s+1)
%G = exp(-s*0.5)
%G = 100/((s+1)*(s+10))
%G = 1/((s+1)*(s^2+1))
% G = (1+s)/(s*(1+10*s)*(1+0.1*s)^2)
%G = (1)/(s*(s+1))

G= (s^2+900)/(s*(s-30)*(s-3));

% Forma di Bode
G_zpk = zpk(G);
G_zpk.DisplayFormat='frequency'

guadagno = dcgain(G)
zero(G)
pole(G)

bode(G)
figure;
nyquist(G)
figure;

rlocus(G)
figure;

rlocus(-G)

