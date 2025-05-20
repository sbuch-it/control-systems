close all
clear all
clc

s=tf('s');
G = ((s+100)^2)/((s^2+s+1)*(s+1))

ki=1;
C = ki/s;
%bode(C*G);

% pulsazione di attraversamento circa 10 e con questa
% pulsazione il margine di fase non è corretto cioè 125


ki=1;
kp=1;
C=(ki*(1+(kp/ki)*s))/s;
%bode(C*G);

% in questo caso riesco a spostarmi nella frequenza
% desiderata e quindi a questo punto aumento il guadagno

ki=100;
kp=100;
C=(ki*(1+(kp/ki)*s))/s;
%bode(C*G);

ki=1000;
kp=1000;
C=(ki*(1+(kp/ki)*s))/s;
%bode(C*G);

L=C*G;
W = feedback(L,1);
margin(L)
figure;
bode(W)



