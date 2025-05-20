% QUESTO E' GIUSTO

clear all
close all
clc

% G in forma di Bode
s = tf('s');
G = (100*(s+500))/((s+10)*(s+20)*(s+400)); % sistema di tipo 0
G = zpk(G);
G.DisplayFormat = 'frequency';
kg = 0.625;

% domanda 1
kd = 0.2;
H = 1/kd;

% domanda 2 (bisogna aggiungere un polo nel controllore)
errore_rampa = 10^(-3); % <=
kc = (kd^2)/(errore_rampa*kg);

% domanad 3
%{
DISTURBO SULL'SUCITA: reiezione completa perché il sistema C(s)G(s) è di
tipo 1 --> soddisfatta per qualsiasi kc
DISTURBO SUL COMADNO: reiezione completa perché il controllore è di tipo 1
--> soddisfatta per qualsiasi kc
%}

% scelgo kc = 64
C = kc/s;

% domanda 4 e 5
Mr = db2mag(3); % <=
fi_m = rad2deg((2.3-Mr)/1.25);
B3 = 35; % 30<B3<40 --> wc=[17.5-28]
wc = 22;

G1 = G*C*H;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
%{
fase = -204°
modulo = 8dB

devo anticipare la fase e ridurre il modulo --> combinazione di reti
anticipo/ritardo
%}

delta_fi_m = -180-f+fi_m+7;

% rete anticipatrice (2 da 36° con le carte)
n = 4;
alfa = 1/n;
wt = 2;
tau = wt/wc;
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);
% devo ridurre il modulo di 20dB

% rete ritardatrice
gamma_min = m_db;
alfa = 10^(-gamma_min/20);
tau = 100/wc;
C_r = (1+alfa*tau*s)/(1+tau*s);

G3 = G2*C_r;
[m,f] = bode(G3,wc);
m_db = 20*log10(m);
% ad AA le cose funzionao, vediao ad AC

C1 = C*C_a*C_a*C_r;
L = C1*G*H;
figure(1)
nichols(L); % B3=39.7rad/s
W = feedback(L,1);
figure(2)
bode(W); % Mr=2.73