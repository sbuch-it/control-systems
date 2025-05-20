close all
clear all
clc

s=tf('s');
G=(800*(s+7)^2)/(s*(s+20)^2*(1+s+s^2));

G = zpk(G);
G.DisplayFormat='frequency'

kc= 25;
kh=1/100;

wc=5;
fi_m=41;

L=kc*kh*G;

% bode(L);
% pulsazione circa 3 e non 5 come vogliamo

[m,f]=bode(L,wc)
% m = 0.2841 mentre dovrebbe valere 1

eps=15;
fase=-180-f+fi_m+eps;
% fase da guadagnare, risulta 83

mdb=20*log10(m); % -10.93.07

% prendo fase/2 perché ho 83 gradi da recuperare
% meglio usare 2 reti

% rete anticipatrice
a = (1-sind(fase/2))/(1+sind(fase/2));
m = 1/(a);
tau=1/wc/sqrt(1/m);

Ca = (1+tau*s)/(1+(tau/m)*s)
% Ca = (1+tau*s)/(1+0.06*s)


% 0.4452s + 1 / 0.08985 s + 1

L1 = Ca*Ca*L;
[m,f]=bode(L1,wc)

m_db=20*log10(m); % 2.9691

% photo
alpha=10^(-m_db/20);
tau=100/wc;
Cr=(1+alpha*tau*s)/(1+tau*s);

L2 = Cr*L1;

[m,f]=bode(L2,wc)
m_db=20*log10(m)


nichols(L2)
% abilito griglia e il diagramma di Nichols entra
% dentro al cerchio di 3dB quindi non sono soddisfatte
% le specifiche, si deve tornare a progettare nuovamente
% il controllore. Se si riesce a traslare Nichols più in
% alto allora esce dal cerchio e l'altezza viene influenzata
% dal modulo e si deve agire sul margine di fase.

% aumentiamo eps=7 e diventa 15

% con eps=15 il diagramma di Nichols non entra nel cerchio
% di 3 dB, possiamo anche lasciare eps=7 e modificare il
% valore di alpha 0.08985 quindi modifico e considero
% Ca = (1+tau*s)/(1+0.06*s)
% in modo che rete anticipatrice effettua uno spostamento

% poi faccio Nichols e anche in questo caso sono fuori
% da 3 dB


% poi verifichiamo l'anello chiuso
W=feedback(L2,1);
step(W)



