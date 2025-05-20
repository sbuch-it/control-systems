% QUESTO E' GIUSTO

clear all
close all
clc

% G in forma di bode
s = tf('s');
G = (250*(s+100))/(s*(s+5)*(s+50)^2); % sistema di tipo 1
G = zpk(G);
G.DisplayFormat = 'frequency';
kg = 2;

% domanda 1
kd = 0.1;
H = 1/kd;

% domanda 2
errore_rampa = 2*10^-3; % <=
kc = (kd^2)/(errore_rampa*kg); % >=

% domanda 3
%{
DISTURBO SULL'USCITA: reiezione completa perché sistema di tipo 1.
DISTRUBO SUL COMANDO: controllore di tipo 0 --> h=0=k --> errore fintio:
%}
errrore_comando = 0.04; % <=
kc_comando = 0.8/(H*errrore_comando); % >=

% scelgo kc = 2.5
C = kc;

% domanda 4 e 5
Mr = db2mag(1); % <=
fi_m = rad2deg((2.3-Mr)/1.25); % >=
Ts = 0.1; % <=
B3 = 3/Ts; % >=. --> wc=[15-24]
wc = 20;

G1 = G*C*H;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
%{
fase = -198°
moudlo = -5dB

dev anticipare la fase ed aumentare il modulo --> carte normalizzate
%}

delta_fi_m = -180-f+fi_m+7; % 72°

% rete anticipatrice
n = 5;
alfa = 1/n;
wt = 2;
tau = wt/wc;
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);

% rete ritardatrice
gamma_min = m_db;
alfa = 10^(-gamma_min/20);
tau = 100/wc;
C_r = (1+alfa*tau*s)/(1+tau*s);

G3 = G2*C_r;
[m,f] = bode(G3,wc);
m_db = 20*log10(m);
% ad AA le cose funzionano, vediamo ad AA

C1 = C*C_a*C_a*C_r;
L = C1*G*H;
W = feedback(L,1);
figure(1)
bode(W); % Mr=0.293dB < 1dB.
figure(2)
step(W); % Ts=0.095s < 0.1s