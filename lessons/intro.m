%% Introduzione a MATLAB

% Assegnazione scalare
a=13; % il ; blocca la visualizzazione nella command window

% Visulizzazione variabili workspace
who % visulizza tutte le variabili
whos % visualizzazione con descrizione struttura

% Eliminazione variabili dal workspace
clear
clear a;

% Pulizia command window
clc

% Chiusura figure aperte
close all

%% Definizione di matrici e vettori
A = [0 1 0; 0 0 1; 0 -6 -5];
B = [0 0 1].'; % vettore colonna
B = [0;0;1]; % vettore colonna
C=[1 0 0]; % vettore riga
D = 0;

% I nomi delle variabili sono case sensitive. Gli
% scalari lettera minuscola, matrici lettera maiuscola

%% Operatori aritmetici

% Scalari
a=10;
b=20;
sum = a+b;
pro = a*b;
diff = a-b;
div = a/b;
div_inv = a\b; % = b/a

% Matrici
A = [2 3; 1 0];
B = [20 10; 1 9];
sum = A+B; % A_ij + B_ij 
diff = A-B; % A_ij - B_ij
pro = A*B; % prodotto riga colonna
pro_ele = A.*B; % prodotto per elemento A_ij*B_ij
div = A/B;  % = A*B^-1
div_inv = A\B; % = A^-1*B;
div_ele = A./B; % = A_ij/B_ij

%% Matrici elementari
m=3; % numero di righe
n=2; % numero di colonne
A = zeros(m,n); % matrice m x n di zeri
A = ones(m,n); % matrici m x n di 1
A = eye(n); % matrice identità n x n

%% Informazioni matrici
[m,n] = size(A);
M = length(A);
isequal(A,B) % ritorna 1 se A = B
A==B % ritorna 1 nella posizione ij se A_ij = B_ij

%% Manipolazione matrici
A = diag([1 2 3]); % matrice diagonale
x = 0:0.1:2; % vettore con passo 0.1 x = 0, 0.1, 0.2 ... 2;
%sottomatrici
A = rand(4); %crea una matrice random 4x4
A1r = A(1,:); % seleziona la prima riga di A
A2c = A(:,2); % seleziona la seconda colonna di A
A_1 = A(1:2,:); % selezione le prime 2 righe e tutte le colonne di A
% concatenazione 
B1 = rand(2);
B2 = rand(2);
A1 = [B1 B2]; % orizzontale matrice 2x4 
A2 = [B1;B2]; % verticale matrice 4x2

%% Altre operazioni matrici
r = rank(A); %rango
inversa = inv(A); % inversa
determinante=det(A);
[V,D] = eig(A); % V contiene gli autovettori, D matrice diagonale autovalori A*V=V*D 
nA = norm(A); % norma della matrice A = max(sqrt(eig(X'*X))) 
v=rand(5,1); nv = norm(v); % norma del vettore v = sqrt(v'*v)

% maggiori informazioni
help elmat % tutte le funzioni per le matrici

%% Plot funzione
x = 0:0.1:1; 
y = 10*x + 1;
figure(1) % per indicizzare le figure
plot(x,y) %plot semplice interpolato
hold on %plotta sulla stessa figura
plot(x,y,'r*') %plot dei punti calcolati

%% Polinomi
poly = [2 -2 5]; % coefficienti del polinomio 2*x^2-2*x+5
p = roots(poly); % radici
v = polyval(poly,0); % valore in nel punto zero
x = 0:.1:1;
figure, plot(x, polyval(poly,x));

%% Definizione sistema dinamico LTI
% tempo continuo
A = [-1 0;3 -4];
B = [2 1]';
C = [1 2];
D = 0;
mysys = ss(A,B,C,D); % crea sistema dinamico partendo dalle matrici A,B,C,D
%tempo discreto
mysys_d = ss(A,B,C,D,1) % sistema tempo discreto con tempo di campionamento = 1;

% Funzione di trasferimento TC
s = tf('s');
G = (s+1)/(s^2+s+1); % definizione della tf (mettere sempre le parentesi)
G = tf([1 1],[1 1 1]); % altra definizione di G

% Funzione di trasferimento TD
z = tf('z',1);
G_z = (z+1)/(z^2+2);
G_z = tf([1 1],[1 0 2],1);

% Passaggio i/s/o --> i/o
[num,den]=ss2tf(A,B,C,D);
myG=tf(num,den);

% Passaggio i/o --> i/s/o
[Ar,Br,Cr,Dr]=tf2ss(num,den); % notare che le matrici sono diverse... 
[numr,denr]=ss2tf(Ar,Br,Cr,Dr);
myGr=tf(numr,denr); % ... ma la tf ? la stessa

% Analisi dei sistemi
t = 0:0.01:1;
figure, impulse(mysys); %plot risposta impulsiva
[y,t] = impulse(mysys); %calcolo risposta impulsiva
[y,t] = step(mysys); %calcola risposta al gradino
figure, step(mysys)
figure, bode(myG); %diagramma di bode 

% risposta libera e forzata
t = 0:0.01:40;
y_l = initial(mysys,[10 10],t); %risposta libera
u = sin(1/2*t);
y_f = lsim(mysys,u,t); %risposta forzata
y_tot = lsim(mysys,u,t,[10 10]');  % risposta totale
[mag,pha]=bode(myG,1/2) % calcola i valori dei diagrammi di Bode per omega=1/2 
y_perm=mag*sin(1/2*t+pha*pi/180); % risposta di regime permanente (fase in radianti)

% visualizzazione
plot(t,y_l,'b',t,y_f,'g',t,y_tot,'r',t,y_perm,'c--')
legend('risposta libera','risposta forzata','risposta totale','regime permanente')

% interconnessioni
s = tf('s');
G1 = 1/s;
G2 = 1/(s+1);
G3 = 1/(s+2);
H = (s+3)/s;
S = G1*G2;  % connessione in serie
P = S+G3;   % connessione in parallelo
W = P/(1+H*P) % connessione in retroazione negativa
W = minreal(W) % eventuale cancellazione poli-zeri
[zeri,poli,guadagno] = zpkdata(W) % forma zeri-poli (attenzione: zeri e poli sono in formato cell)
zeri{1}     % mostra gli zeri
poli{1}     % mostra i poli