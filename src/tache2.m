clear all;
close all;
clc;

addpath('PHY')
%% Initialisation des variables

Fp = 1.09*10^6; %fréquence porteuse
Fe = 20*10^6;
Te = 1/Fe;
Ts = 1*10^(-6);
Ds = 1/Ts;
moy_fft = 100;
Fse = Ts/Te; % 20 échantillons
NFFT = 1000; % nombre de point par fft
Nb = 5; % nombre de bits % nombre de FFT
bk=randi([0 1],1,NFFT*Nb);
f = linspace(-Fe/2,Fe/2,NFFT);
sl=[];

%% GENERATION IMPULSIONS

p0=[];
p1=[];
p=[];
for i=1:Fse/2
    p0=[p0 0];
    p1=[p1 1];
    p=[p -0.5];
end
for i=1:Fse/2
    p0=[p0 1];
    p1=[p1 0];
    p=[p 0.5];
end

p=fliplr(p);

for i=1:NFFT*Nb
    if bk(i)==1
        sl=[sl p1];
    else
        sl=[sl p0];
    end
end

%% Calcul DSP

[DSP,f] = Mon_Welch(sl,NFFT,Fe); % dsp experimentale

%% affichage de la DSP

figure();
semilogy(f,DSP,'r','linewidth',2);
title('DSP expérimentale de Sl');
xlabel('Fréquence');
ylabel('Amplitude de Sl');
hold on

DSP_th = Ds/2 * (sinc(f/2).^2).*(sin(pi*f/2).^2); %DSP theorique
hold on;
grid on;

semilogy(f,DSP_th,'b','linewidth',2);
title('DSP théorique (bleu) et expérimentale (rouge) de Sl');
xlabel('Fréquence');
ylabel('Amplitude de Sl');
