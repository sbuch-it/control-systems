% QUESTO E' OK (VEDERE CURIOSITA')
%{
N.B. 
- diminuendo la wc ho diminuito anche il Ts
- se aumento il guadagno kc aumento la banda passante perché (sposto in
alto il grafico) e non distrubo la fase --> aumento Mr. diminuisco il Ts.
%}

clear all
close all
clc

% G in forma di Bode
s = tf('s');
G = (s+200)/(s*(s+400)*(s+1)^2); % sistema di tipo 1
G = zpk(G);
G.DisplayFormat = 'frequency';
kg = 0.5;

% domanda 1
kd = 10;
H = 1/kd;

% domanda 2
errore_rampa = 0.1; % <=
kc = kd/(errore_rampa*kg); % >=

% domanda 3
%{
Per quanto riguarda il distrubo sull'uscita, si ha reiezione completa -->
soddisfatta per qualsiasi kc (perché il sistema C(s)G(s) è di tipo 1).
Per quanto riguarda il distrubo sul comando, bisogna controllare il numero
 di poli nell'origine al controllore, ovvero h=0=k --> 
%}
errore_distrubo = 0.05; % <=
kc_disturbo = 1/(errore_distrubo*H);

% scelgo kc = 200;
C = kc;

% domanda 4 e 5
Mr = db2mag(2); % <=
fi_m = rad2deg((2.3-Mr)/1.25); % >=
Ts = 0.3; % <=
B3 = 3/Ts; % >= 10rad/s --> wc=[5,8]
wc = 5.5;

G1 = G*C*H;
[m,f] = bode(G1, wc);
m_db = 20*log10(m);
%{
fase = -251°
modulo = 29dB
%}

delta_fi_m = -180-f+fi_m; % --> 3 reti che guadagnao circa 45° l'una

% rete anticipatrice
m = 6;
alfa = 1/m;
wt = 3;
tau = wt/wc;
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a*C_a*C_a;
[m,f] = bode(G2, wc);
m_db = 20*log10(m);
%{
f = -116 dunque ok
m_db = -1.8

Il modulo non è ancora del tutto perfetto ma siccome wc appartiene ad un
range possiamo provare a vedere se ad AC le cose funzionano lo stesso
%}

C1 = C*C_a*C_a*C_a;
L = C1*G*H;
figure(3)
nichols(L);

% specifiche ad AC
W = feedback(L,1);
figure(1)
bode(W); 
figure(2)
step(W); 
% 1°: Ts = 0.372; Mr = 0.909dB < 2dB (wc=6.5)
% 2°: Ts = 0.469; Mr = 1.22dB < 2dB (wc=7)
% 3°: Ts = 0.245; Mr = 3.97 > 2dB /wc=5)
% 4°: Ts = 0.271; Mr = 1.5 < 2dB /wc=5.5) --> QUESTO E' OK

%{
Siccome il tempo di salita risulta 0.372 > 0.3 posso provare ad aumentare
un po la pulsazione di attraversamento wc in modo da aumentare la banda
passante ed ottenere, dunque, un sistema più reattivo. 
prendo wc=7 (prima era 6.5). Aumenta il Ts se aumento la wc --> provo a
diminuirla ad wc=5.
%}