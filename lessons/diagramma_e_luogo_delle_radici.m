clear all; close all; clc

% funzione di trasferimento
s = tf('s');
G = 20*(s+2)/((s+10)*(s^2+0.2*s+1))

% forma poli-zeri
G_zpk = zpk(G)
zero(G) % zeri di G
pole(G) % poli di G

% forma di Bode
G_zpk.DisplayFormat='frequency'

% guadagno in continua - guadagno di Bode
G0 = dcgain(G)

% diagramma di Bode
bode(G)
figure;

% picco di risonanza
[gpeak,fpeak] = getPeakGain(G)
gpeak_dB = 20*log10(gpeak)

% modulo e fase di G(s) calcolati in omega
omega = 5;
[m,f] = bode(G,omega)
m_dB = 20 * log10(m)

% diagramma di Nyquist
nyquist(G)
figure;

% diagramma di Nichols
nichols(G)
figure;

% luogo delle radici
rlocus(G)
figure;
% rlocus(-G) è il complementare

%% consideriamo la funzione di trasferimento
G2 = 3 * (s^2 + 9)/((1+s)*(s^2+4)*(1+0.2*s))
nyquist(G2)

% la funzione ha poli puramente immaginari quindi
% il sistema va a infty, tasto destro nel grafico
% per vedere solo le frequenze negative (Show) e 
% poi fare lo zoom nel punto (-1, 0)

% si parte con un certo guadagno, poi il ramo tende
% a +infty, poi ritorna, va a 0 e poi esce e va a 0