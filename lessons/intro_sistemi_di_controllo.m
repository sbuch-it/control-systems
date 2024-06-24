clear all; close all; clc

% matrici del sistema
A = [0 1 0; 0 0 1; 0 -6 -5];
B = [0 0 1]';
C = [1 0 0];
D = 0;

% sistema a tempo continuo
sistemaTC = ss(A,B,C,D);

% funzione di trasferimento
s = tf('s');
G = (s+1)/(s^2+s+1)

G_num = [1 1];
G_den = [1 1 1];
G_pol = tf(G_num, G_den)

% radici di un polinomio dati i coefficienti
pol = [1 2 3];
roots(pol)
