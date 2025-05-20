%% Esame 21-12-2020 - Esercizio 1

clear all; close all; clc;

%% Funzione di trasferimento

s = tf('s');
G = (800*(s+25))/(s*(s+0.02*s)^2*(s+200)^2)

%% Guadagno in continua Y/R

kd = 0.01;
kH = 1/kd;
