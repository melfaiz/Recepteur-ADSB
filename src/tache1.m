clear all ;close all ; clc

%% INITIALISATION

Ts=1e-6;
Fe=20e6;
Te=1/Fe;
Fse=Ts/Te;
nb=1000;
bk=randi([0 1],1,nb);
Eb_N0_dB = 0:1:10;
Eb_N0_dec = 10.^(Eb_N0_dB/10);
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

for i=1:size(bk,2)
    if bk(i)==1
        sl=[sl p1];
    else
        sl=[sl p0];
    end
end

TEB = zeros(1,size(Eb_N0_dB,2));

for k=1:size(Eb_N0_dB,2)
    k
    erreur = 0;
    compteur_paquet = 0;
    while erreur < 100
        nl=[];
        yl=[];
        rm=[];
        bk_est=[];
        compteur_paquet = compteur_paquet+1;
        
        Eb = sum(p.^2);
        No = Eb / 10^(Eb_N0_dB(k)/10) ;
        sigma = sqrt(No/2) ;
        nl = sigma .* randn(1,size(sl,2)); 
        
        yl = sl+nl;
        
        rl=conv(yl,p);
        
        for i=1:size(rl,2)/Fse
            rm=[rm rl(Fse*i)];
        end
        
        seuil=0;
        
        bk_est=zeros(1,size(bk,2));
        for i=1:size(bk,2)
            if rm(i)>seuil
                bk_est(i)=0;
            else
                bk_est(i)=1;
            end
        end
        
        nb_erreur = 0;
        for i=1:size(bk_est,2)
            if (bk_est(i) ~= bk(i))
                nb_erreur = nb_erreur + 1;
            end
        end
        erreur = erreur + nb_erreur;
    end
    
    TEB(k)= erreur/(nb*compteur_paquet);
    erreur = 0;
    compteur_paquet = 0;
end

Pb = 1/2.*erfc(sqrt(Eb_N0_dec));

figure()
semilogy(Eb_N0_dB,Pb,'b','linewidth',2);
hold on;
grid on;
semilogy(Eb_N0_dB,TEB,'r','linewidth',2);
title('TEB = f(Eb/No)');
xlabel('Eb/No (db)');
ylabel('TEB (db)');
