% QUESTO E' OK.

clear all
close all
clc

% impianto in forma di bode
s = tf('s');
G = (500*(s+3))/((s+50)*(s^2+10*s+100));
G = zpk(G);
G.DisplayFormat = 'frequency'; % impianto di tipo 0
kg = 0.3;

% domanda 1
kd = 10;
H = 1/kd;

% domanda 2 sempre soddisfatta perché di tipo 1 per il controllore

% domanda 3 
%{
Bisogna aggiungere un polo nel controllore affinché il sistema diventi di
tipo 1 e si ottenga un errore finito alla rampa unitaria
%}
errore_rampa = 0.2; %<=
kc = (kd^2)/(errore_rampa*kg);

% domanda 4 sempre soddisfatta perché di tipo 1 C(s)G(s) e C(s)

C = kc/s;

% domanda 5 e 6
max_sovraelongazione = 0.15; % <= 15%
Mr = (1+max_sovraelongazione)/0.9; % scelto 0.90. Mr lineare <=
fi_m = rad2deg((2.3-Mr)/1.25); % >=
B3 = 15; % >=
wc = 9; % wc=[7.5-12]

G1 = G*C*H;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
% la fase è ok ma il modulo è troppo alto

% rete ritardatrice
gamma_min = m_db;
alfa = 10^(-gamma_min/20);
tau = 100/wc;
C_r = (1+alfa*tau*s)/(1+tau*s);

G2 = G1*C_r;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);
% specifiche ad AA rispettate

C1 = C*C_r;
L = C1*G*H;
figure(1)
nichols(L); % B3 = 15.4 > 15.

% specifiche ad AC
W = feedback(L,1);
figure(2)
step(W); % max_sovraelongazione = 12.3% < 15%.