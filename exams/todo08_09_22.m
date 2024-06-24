% QUESTO E' OK 

clear all
close all
clc

% impianto in forma di bode
s = tf('s');
G = 3000/(s*(s^2+2*s+1)*(s+100));
G = zpk(G);
G.DisplayFormat = 'frequency'; % sistema di tipo 1
kg = 30;

% domanda 1
kd = 5;
H = 1/kd;

% domanda 2
errore_rampa = 2.5; % <=
kc = kd/(errore_rampa*kg); % >=0.0667

% domanda 3
%{
Per quanto riguarda il distrubo sull'uscita risulta h=1>k=0 --> per il
principio del modello interno si ha errore nullo --> reiezione completa -->
soddisfatta per qualsiasi kc.
Per quanto riguarda il distrubo sul comando, dato che bisogna guardare solo
il controllore, si ha che h=k=0 --> per il teorema del valor finale si ha:
%}
errore_comando = 0.125;
kc_disturbo = 1/errore_comando; % kc_disturbo >= 8 

% scelgo kc = 8, ovvero:
kc = kc_disturbo;
C = kc;

% domanda 4 e 5
Mr = db2mag(1); % <=
fi_m = rad2deg((2.3-Mr)/1.25); % >=
B3 = 10; % >=
wc = 5.5; % wc=[5-8]

G1 = G*C*H;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
% modulo e fase troppo bassi

delta_fi_m = -180-f+fi_m;

% rete anticipatrice (2 da 60)
m = 7;
alfa = 1/m;
wt = 3;
tau = wt/wc;
C_a = (1+tau*s)/(1+alfa*tau*s);

G2 = G1*C_a*C_a*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);
% la fase è ok ma il modulo è più alto di 16dB 

% rete ritardatrice
alfa = 10^(-m_db/20);
tau = 100/wc;
C_r = (1+tau*alfa*s)/(1+tau*s);

G3 = G2*C_r;
[m,f] = bode(G3,wc);
m_db = 20*log10(m);
% ora modulo e fase ad AA son ok.

C1 = C*C_a*C_a*C_a*C_r;
L = C1*G*H;
figure(1)
nichols(L); % risulta B3 = 12.2rad/s > 10rad/s

% spwcifiche ad AC
W = feedback(L,1);
figure(2)
bode(W); % risulta Mr = 0.96dB < 1dB
figure(3)
step(W);

%{
1° TENTATIVO 

% rete anticipatrice (3 da 45°)
m = 10;
alfa = 1/m;
wt = 7;
tau = wt/wc;
C_a = (1+tau*s)/(1+alfa*tau*s);

G2 = G1*C_a*C_a*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);
%}