% QUESTO E' GIUSTO

clear all
close all
clc

% G in forma di bode
s = tf('s');
G = (-100*(s+1))/(s^3+15*s^2+50*s); % sistema di tipo 1
G = zpk(G);
G.DisplayFormat = 'frequency';
kg = -2;

% domanda 1
kd = 2;
H = 1/kd;

% domanda 2: kc<=25.

% domanda 3
errore_rampa = 0.1; % (nona regime). <=
kc = kd/(errore_rampa*kg); % >=

% scelgo kc = -10
C = -8;

% domanda 4 e 5
Mr = db2mag(3); % <=
fi_m = rad2deg((2.3-Mr)/1.25); % >=
B3 = 100; % >=. --> wc=[50-80]
wc = 65;

G1 = G*C*H;
[m,f] = bode(G1,wc);
m_db = 20*log10(m);
%{
fase = -167°
modulo = -18dB
%}

delta_fi_m = -180-f+fi_m;

% rete anticipatrice
m = 13;
alfa = 1/m;
wt = 20;
tau = wt/wc;
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);
%{
f = -137
m_db = 2
Provo lo stesso ad AC
%}

C1 = C*C_a;
L = C1*G*H;
figure(1)
nichols(L); 

% specifiche ad AC
W = feedback(L,1);
figure(2)
bode(W); 
% 1°: B3=118rad/s > 100rad/s. Mr = 3.81 > 3dB (kc=-10)--> Mr troppo alto
% 2°: B3=102rad/s > 100rad/s. Mr = 2.89 < 3dB (kc=-8)--> GIUSTO

%{
1° TENTATIVO

m = 9;
alfa = 1/m;
wt = 20;
tau = wt/wc;
C_a = (1+tau*s)/(1+tau*alfa*s);

G2 = G1*C_a;
[m,f] = bode(G2,wc);
m_db = 20*log10(m);

f = -146
m_db = -0.3685
devo aniticipare ancora un pò la fase
%}