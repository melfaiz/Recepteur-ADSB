clear 
close all
clc

addpath('../PHY');
%% 
Fe = 20e6; % Frequence d'echantillonnage (imposee par le serveur)
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles

%% Chaîne TX
b = [1 0 0 1 0];
s_l = modulatePPM(b,Fse);

%% test de modulate
t = (0:length(s_l)-1)/Fe;
plot(t * 1e6,s_l)
xlabel('Temps en micro-secondes')
ylabel('s_l')
grid on
ylim([-0.15, 1.15])

%% Chaine RX
b_rec = demodulatePPM(s_l,Fse);

%% test de demodulate
nb_erreur = sum(b ~= b_rec);
disp(['Nombre d''erreurs observees : ', num2str(nb_erreur)])