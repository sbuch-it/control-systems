
clear all
close all
clc

% impianto G in forma di Bode
s = tf('s');
G = (800*(s+25))/(s*(s+0.02*s)*(s+0.02*s)*(s+200)^2);
G = zpk(G);
G.DisplayFormat = 'frequency'; % sistema di tipo 3
kg = 0.48058;

% domanda 1
kd = 0.01;
H = 1/kd;

% domanda 2 soddisfatta per qualsiasi kc perché di tipo 3 la G;

% domanda 3
%{
Per quanto rigurda il disturbo sull'uscita, è soddisfatta  per qualsiasi kc
perché l'impianto è di tipo 3.
Per quanto riguarda il disturbo sul comando, si deve guardare il numero di
poli in 0 solo nel controllore --> si ha h=0=k --> errore = 1/kc
%}
errore_comando = 0.002; % <= --> kc >=
kc = 2/(H*errore_comando);

% scelgo kc = 500
C = kc;

% domanda 4 e 5
Mr = db2mag(3); % <=
fi_m = rad2deg((2.3-Mr)/1.25); % >=
Ts = 0.03; % <=
B3 = 3/Ts; % >=. --> wc=[50-80]
wc = 55;

G1 = C*G*H;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
%{
fase = -238°
moudlo = -14dB
%}

delta_fi_m = -180-f+fi_m;

% rete anticipatrice
n = 16;
alfa = 1/n;
wt = 2;
tau = wt/wc;
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);
% ad AA funzionano abbastanza bene, proviamo ad AC

C1 = C*C_a*C_a;
L = C1*G*H;

% AC
W = feedback(L,1);
figure(1)
bode(W);
figure(2)
step(W);
% 1°tentativo: Ts=0.0203. Mr=4.71. (wc=70)
% 2°tentativo: Ts=0.0155. Mr=2.77. (wc=55) --> GIUSTO

%{
% SBAGLIATO

clear all
close all
clc

% impianto G in forma di Bode
s = tf('s');
G = (800*(s+25))/(s*(s+0.02*s)*(s+0.02*s)*(s+200)^2);
G = zpk(G);
G.DisplayFormat = 'frequency'; % sistema di tipo 3
kg = 0.48058;

% domanda 1
kd = 0.01;
H = 1/kd;

% domanda 2 soddisfatta per qualsiasi kc perché di tipo 3 la G;

% domanda 3
%{
Per quanto rigurda il disturbo sull'uscita, è soddisfatta  per qualsiasi kc
perché l'impianto è di tipo 3.
Per quaanto riguarda il disturbo sul comando, si deve guardare il numero di
poli in 0 solo nel controllore --> si ha h=0=k --> errore = 1/kc
%}
errore_comando = 0.002; % <= --> kc >=
kc = 1/errore_comando;
% date le osservazioni precedenti, scelgo kc = 500

C = kc;

% domanda 4 e 5
Mr = db2mag(3); % <= --> fi_m >= 41°
fi_m = rad2deg((2.3-Mr)/1.25);
Ts = 0.03; % <= --> B3 >= 100rad/s
B3 = 3/Ts; % --> wc=[50-80]
wc = 65;

G1 = C*G*H;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
% bisogna aumentare sia la fase sia il modulo --> carte normalizzate

delta_fi_m = -180-f+fi_m; 

%{
% servono 2 reti che ci aumentano di 50° l'una

% rete anticipatrice
m = 9;
alfa = 1/m;
wt = 2;
tau = wt/wc;
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);
%{
Prendendo m=9 e wt=3 ottengo f=-130 e m_db=5.9
Se prendo m=9 e wt=2 si ha f=-135 e m_db=0.4 --> meglio.
%}
%}

% rete anticipatrice
alfa = (1-sind(delta_fi_m))/(1+sind(delta_fi_m));
tau = 1/(wc*sqrt(alfa));
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);

% rete ritardatrice
gamma_min = m_db;
alfa = 10^(-gamma_min/20);
tau = 100/wc;
C_r = (1+tau*alfa*s)/(1+tau*s);

G3 = G2*C_r;
[m,f] = bode(G3,wc);
m_db = 20*log10(m);

C1 = C*C_a*C_a*C_r;
L = C1*G*H;

% Proviamo ad AC
W = feedback(L,1);
figure(1)
bode(W); % Mr=4.72
figure(2)
step(W); % Ts=0.02
%{
Bisogna abbassare un pò il picco di risonanza (facendo con le carte
normalizzate).
Facendo con il calcolo allora le cose tornano.
%}
%}