% QUESTO E' GIUSTO

clear all
close all
clc

% G in forma di Bode
s = tf('s');
G = (s+20)/(s*(s+3)*(s^2+1.5*s+1));
G = zpk(G);
G.DisplayFormat = 'frequency'; % sistema di tipo 1
kg = 6.6667;

% domanda 1
kd = 7;
H = 1/kd;

% domanda 2
errore_rampa = 0.1; % e_ramp <= 0.1
kc = kd^2/(errore_rampa*kg); % kc>=73.4

% domadna 3
%{
DISTRUBO SULL'USCITA: il sitema C(s)G(s) ha 1 polo in 0 --> h>k --> errore
nullo --> soddisfatta per ogni kc.
DISTURBO SUL COMANDO: il controllore ha 0 poli in 0 --> h=k e errore=1/kc
%}
errore_comando = 0.4; % errore <= 0.4
kc_disturbo = 0.8/(H*errore_comando); % kc_disturbo >=14

% scelgo kc = 74
C = kc;

% domanda 4 e 5
Mr = db2mag(3); % <=
fi_m = rad2deg((2.3-Mr)/1.25); % >=
Ts = 2.5; % <=
B3 = 3/Ts; % >=. --> wc=[0.6-0.96]
wc = 0.9;

G1 = C*G*H;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
%{
fase = -175.0°
modulo = 36dB
--> combinazioni di reti anticipo/ritardo
%}

delta_fi_m = -180-f+fi_m+20;

% rte anticipatrice
alfa = (1-sind(delta_fi_m))/(1+sind(delta_fi_m));
tau = 1/(wc*sqrt(alfa));
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);
% siccome devo guadagnare 44dB che è alto --> 2 reti ritardatrici

% rete ritardatrice (con le carte)
n = 16;
alfa = 1/n;
wt = 350;
tau = wt/wc;
C_r = (1+alfa*tau*s)/(1+tau*s)

G3 = G2*C_r*C_r;
[m,f] = bode(G3,wc);
m_db = 20*log10(m);
% non perfettamente funzionante ad AA, vediamo lo stesso ad AC

C1 = C*C_a*C_r*C_r;
L = C1*G*H;
W = feedback(L,1);
figure(1)
bode(W);
figure(2)
step(W);
figure(3)
nichols(L);
% 1° tentativo: Mr=7dB(troppo alto) e Ts=2.13
% 2) Mr=2.95 e Ts=2.49 (n=16,wt=350,wc=0.9,epsilon=20) --> GIUSTO


%{
% SBAGLIATO

clear all
close all
clc

% G in forma di Bode
s = tf('s');
G = (s+20)/(s*(s+3)*(s^2+1.5*s+1));
G = zpk(G);
G.DisplayFormat = 'frequency'; % sistema di tipo 1
kg = 6.6667;

% domanda 1
kd = 7;
H = 1/kd;

% domanda 2
errore_rampa = 0.1; % e_ramp <= 0.1
kc = kd^2/(errore_rampa*kg); % kc>=73.4

% domadna 3
%{
DISTRUBO SULL'USCITA: il sitema C(s)G(s) ha 1 polo in ' --> h>k --> errore
nullo --> soddisfatta per ogni kc.
DISTURBO SUL COMANDO: il controllore ha 0 poli in 0 --> h=k e errore=1/kc
%}
errore_comando = 0.4; % errore <= 0.4
kc_disturbo = 1/errore_comando; % kc_disturbo >=2.5

% scelgo kc = 73.44996;
C = kc;

% domanda 4 e 5
Mr = db2mag(3); % Mr<=3dB
fi_m = rad2deg((2.3-Mr)/1.25); % fi_m>=41°
Ts = 2.5; % Ts<=2.5s
B3 = 3/Ts; % B3>=1.2 --> wc=[0.6-0.96]
wc = 0.85;

G1 = C*G*H;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
%{
Bisogna anticipare la fase e ridurre il modulo --> combinazione di reti
anticipatrici/ritardatrici
%}

delta_fi_m = -180-f+fi_m+7;

% rete anticipatrice
alfa = (1-sind(delta_fi_m))/(1+sind(delta_fi_m));
tau = 1/(wc*sqrt(alfa));
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a;
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
% devo diminuire sia la fase che il modulo

m = 8;
alfa = 1/m;
wt = 1;
tau = wt/wc;
C_a1 = (1+tau*s)/(1+tau*alfa*s);

G4 = G3*C_a1;
[m,f] = bode(G4,wc);
m_db = 20*log10(m);
%}