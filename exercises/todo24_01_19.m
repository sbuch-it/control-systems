% QUESTO E' GIUSTO

close all
clear all
clc

% G in forma di bode
s = tf('s');
G = (100*(s+25))/((s^2+200*s)*(s^2+1.4*s+1)); % sistema di tipo 1
G = zpk(G);
G.DisplayFormat = 'frequency';
kg = 12.5;

% domanda 1
kd = 10;
H = 1/kd;

% domanda 2
errore_rampa = 0.16; % <=
kc = (kd^2)/(kg*errore_rampa);

% domanda 3
%{
DISTURBO SULL'USCITA: reiezione completa perché di tipo 1 --> soddisfatta
per qualsiasi kc
DISTURBO SUL COMANDO: controllore di tipo 0 --> h=k=0:
%}
errore_comando = 0.1; % <=
kc_comando = 0.4/(H*errore_comando); % >=

% scelgo kc = 50
C = kc;

% domanda 4 e 5 
B3 = 3.5; % 3<=B3<=4 --> wc=[1.75-2.8]
wc = 2;
Mr = db2mag(3); % <=
fi_m = rad2deg((2.3-Mr)/1.25); % >=

G1 = G*H*C;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
%{
fase = -223°
modulo = 17.6dB

devo anticipare la fase e ridurre il modulo --> combinazione di reti
anticipo/ritardo
%}

delta_fi_m = -180-f+fi_m+7;

% rete anticipatrice (2 da 46° con le carte)
n = 6;
alfa = 1/n;
wt = 2;
tau = wt/wc;
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);
% devo ridurre il modulo di 30dB --> 2 reti

% rete ritardatrice (2 da 15dB)
n = 6;
alfa = 1/n;
wt = 1000;
tau = wt/wc;
C_r = (1+tau*alfa*s)/(1+tau*s);

G3 = G2*C_r*C_r;
[m,f] = bode(G3,wc);
m_db = 20*log10(m);
% ad AA le cose funzionao, vediamo ad AC

C1 = C*C_a*C_a*C_r*C_r;
L = C1*G*H;
figure(1)
nichols(L); % B3=3.21rad/s --> 3<B3<4
W = feedback(L,1);
figure(2)
bode(W); % Mr=1.86dB < 3dB