% QUESTO E'GIUSTO

clear all
close all
clc

% G in forma di bode
s = tf('s');
G = (s+20)/(s*(3*s+1)*(s+10)^2); % sistema di tipo 1
G = zpk(G);
G.DisplayFormat = 'frequency';
kg = 0.2;

% domanda 1
kd = 5;
H = 1/kd;

% domanda 2
errore_rampa = 0.01; % <=
kc = (kd^2)/(kg*errore_rampa); % >=

% domanda 3
%{
DISTURBO SULL'USCITA: il sistema C(s)G(s) è di tipo 1 --> reiezione
completa --> soddisfatta per qualsiasi kc
DISTURBO SUL COMANDO: il controllore è di tipo 0 --> h=k=0 e di conseguenza
si ha:
%}
errore_comando = 0.2; % <=
kc_comando = 0.8/(H*errore_comando);

% scelgo kc = 12500
C = kc;

% domanda 4 e 5
B3 = 12; % >=. --> wc=[6-9.6]
wc = 8;
sovraelongazione = 0.25; % <=
Mr = (1+sovraelongazione)/0.9; % <=
Mr_db = mag2db(Mr);
fi_m = rad2deg((2.3-Mr)/1.25); % >=

G1 = G*H*C;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
%{
fase = -233°
moudlo = 4.6

devo anticipare la fase e ridurre il modulo --> combinazione rete
anticipo/ritardo
%}

delta_fi_m = -180-f+fi_m+7;

% rete anticipatrice (2 da 55 con le carte)
n=12;
alfa = 1/n;
wt = 3;
tau = wt/wc;
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);
% fase ampliamente ok; devo ridurre il modulo di 24dB

% rte ritardatrice
gamma_min = m_db;
alfa = 10^(-gamma_min/20);
tau = 100/wc;
C_r = (1+tau*alfa*s)/(1+tau*s);

G3 = G2*C_r;
[m,f] = bode(G3,wc);
m_db = 20*log10(m);
% specifiche ad AA ok, vediamo ad AC

C1 = C*C_a*C_a*C_r;
L = C1*G*H;
figure(1)
nichols(L); % B3 = 15.5rad/s > 12rad/s
W = feedback(L,1);
figure(2)
step(W); % sovraelogazione=24.6% <= 25%
% TUTTO OK ANCHE AD AC