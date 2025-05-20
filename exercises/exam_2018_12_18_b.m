% QUESTO E'GIUSTO.

clear all
close all
clc

% G in forma di bode
s = tf('s');
G = (2*(s+1))/((2*s+1)*(8*s+1)*(100*s+1)); % sistema di tipo 0
G = zpk(G);
G.DisplayFormat = 'frequency';
kg = 2;

% domanda 1
kd = 5;
H = 1/kd;

% domanda 2 (bisogna aggiungere un polo nel controllore)
errore_rampa = 0.5; % <=
kc = (kd^2)/(errore_rampa*kg);

% domanda 3
%{
DISTRUBO SULL'USCITA: reiezione completa perché il sistema C(s)G(s) è di
tipo 1 --> soddisfatta per qualsiasi kc
DISTURBO SUL COMANDO: reiezione completa perché il controllore C(s) è di
tipo 1 --> soddisfatta per qualsiasi kc
%}

% scelgo kc=25
C = kc/s;

% domanda 4 e 5 
Mr = db2mag(2); % <=
fi_m = rad2deg((2.3-Mr)/1.25); % >=
Ts = 25; % <=
B3 = 3/Ts; % >=. --> wc=[0.06-0.096]
wc = 0.08;

G1 = G*H*C;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
%{
fase = -210°
modulo = 22dB

devo anticipare la fase e ridurre il modulo --> combinazione reti
anticipo/ritardo.
%}

delta_fi_m = -180-f+fi_m+7; % 84° con epsilon = 7

% rete anticipatrice (2 da 42°)
n = 7;
alfa = 1/n;
wt = 3;
tau = wt/wc;
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);
% devo ridurre il modulo di 43dB

% rete ritardatrice (2 da 21.5dB)
n = 10;
alfa = 1/n;
wt = 1000;
tau = wt/wc;
C_r = (1+tau*alfa*s)/(1+tau*s);

G3 = G2*C_r*C_r;
[m,f] = bode(G3,wc);
m_db = 20*log10(m);
% ad AA funziona, proviamo ad AC

C1 = C*C_a*C_a*C_r*C_r;
L = C1*G*H;
W = feedback(L,1);
figure(1)
bode(W); 
figure(2)
step(W); 
%{
Siccome il picco è troppo alto, provo adu aumentare il margie di fase -->
nella rete anticipatrice anziché prendere n=6 e wt=4 prendo n=7 e wt=3 così
ottengo una fase maggioer(-113 contro i -125). Facendo così ottengo anche
un modulo leggermente minore da dover diminuire ( 40dB contro i 43dB) -->
nella rete ritardatrice preno n=7 anziché n=12.
PRIMA DELLE MODIFICHE AVEVO: 
- Mr=2.52dB > 2dB. TROPPO ALTO. Ts=24.8s < 25s.
DOPO LE MODIFICHE:
- Ts=22.4s < 25s. Mr=0.64dB < 2dB -->  GIUSTO
%}