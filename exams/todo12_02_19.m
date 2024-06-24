clear all
close all
clc

% G in forma di bode
s = tf('s');
G = (s+5)/(s*(s+1)*(s^2+15*s+100)); % sistema di tipo 1
G = zpk(G);
G.DisplayFormat = 'frequency';
kg = 0.05;

% domanda 1
kd = 4;
H = 1/kd;

% domanda 2 (soddisfatta per qualsiasi kc)

% domanda 3
errore_rampa = 0.8; % <=
kc = kd^2/(kg*errore_rampa); % >=

% domanda 4
%{
DISTURBO SULL'USCITA: soddisfatta per qualsiasi kc perché il sistema è di
tipo 1
DISTURBO SUL COMANDO: il controllore è di tipo 0 --> h=k=0 -->
%}
errore_comando = 0.01; % <=
kc_comando = 0.06/(H*errore_comando); % >=

% scelgo kc = 400
C = kc;

% domanda 5 e 6
Mr = db2mag(2); % <=
fi_m = rad2deg((2.3-Mr)/1.25);
Ts = 0.1; % <=
B3 = 3/Ts; % >=. --> wc=[15-24]
wc = 40;

G1 = C*G*H;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
%{
fase = -236°
modulo = -38dB

devo aumentare sia la fase che il modulo --> CARTE NORMALIZZATE
%}

delta_fi_m = -180-f+fi_m;

% rete anticipatrice (2 da 55)
n = 6;
alfa = 1/n;
wt = 6;
tau = wt/wc;
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a*C_a*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);

%{
% rete anticipatrice (2 da 7dB)
n = 3;
alfa = 1/n;
wt = 3;
tau = wt/wc;
C_a2 = (1+tau*s)/(1+tau*alfa*s);

G3 = G2*C_a2*C_a2;
[m,f] = bode(G3,wc);
m_db = 20*log10(m);
% le cose ad AA funzionano, vediamo ad AC
%}

C1 = C*C_a*C_a*C_a;
L = C1*G*H;
W = feedback(L,1);
figure(1)
bode(W); % Mr = 0.3
figure(2)
step(W); % Ts = 0.9