clear all; close all; clc

% funzione di trasferimento
s = tf('s');
G = 100/((s+1)*(s+10))

G_zpk = zpk(G);
G_zpk.DisplayFormat='frequency'

pole(G)
zero(G)

bode(G)
figure;

nyquist(G)