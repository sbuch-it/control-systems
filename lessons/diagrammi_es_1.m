clear all; close all; clc

%% funzione di trasferimento
s = tf('s');
G = 20*(s+2)/((s+10)*(s^2+0.2*s+1))

zeri = zero(G)
poli = pole(G)
% zero stabile in -2
% polo stabile in -10 
% due poli complessi coniugati

%% forma di Bode
G_zpk = zpk(G);
G_zpk.DisplayFormat='frequency'

% guadagno di Bode, indica dove parte
% il tracciamento del diagramma di Bode
G0 = dcgain(G)

% diagramma di Bode
bode(G)
figure;

% picco di risonanza
[gpeak,fpeak] = getPeakGain(G)
gpeak_dB = 20*log10(gpeak)

% modulo e fase per omega assegnato
omega = 5;
[m,f] = bode(G,omega)
m_dB = 20 * log10(m)

% margine di guadagno e di fase
[Gm,Pm,Wcg,Wcp] = margin(G)
margin(G)
figure;

%% diagramma di Bode del modulo
% guadagno 20*log10(4)
% poli complessi coniugati in 1 -> picco e -40dB/dec
% zero reale in 2 -> risale e arriva a 20dB/dec
% polo reale in 10 -> scende e perde 40dB/dec

%% diagramma di Bode della fase
% parte da 0
% poli complessi coniugati in 1 -> scende verso -180°
% zero reale in 2 -> risale
% polo reale in 10 -> riscende

%% diagramma di Nyquist
nyquist(G)
figure;

% visualizzare il diagramma polare, tasto destro sul
% diagramma e poi Show - Negative Frequencies

%% diagramma di Nychols
nichols(G)
figure;

%% risposta al gradino unitario ad anello aperto
step(G)
figure;

% il sistema risponde al gradino come se fosse un
% sistema del secondo ordine con una certa oscillazione
% e poi il sistema tende al guadagno in continua 4

%% risposta al gradino unitario ad anello chiuso
W = feedback(G,1)
step(W)

% il sistema ad anello aperto aveva molte oscillazioni
% per portare il sistema a regime perché era stabile
% ma aveva un polo in 0 mentre il sistema ad anello
% chiuso ha oscillazioni che sono più attenuate