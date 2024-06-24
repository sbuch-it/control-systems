clear all; close all; clc

% funzione di trasferimento
s = tf('s');
G = (s+1)/(s^2+s+1)

% guadagno del controllore
C = 10;

% funzione ad anello aperto
L = C*G

% funzione ad anello chiuso
H = 1;
W = feedback(L, H)