% function [Registres] = tache8(Registres,buffer,Fe,Fse,REF_LON,REF_LAT)

clear all ;
close all ;
clc;


load('buffers.mat');


Fse = 4;
Fe = 4 * 10^6 ;

% Coordonnees de reference (endroit de l'antenne)
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca



% Filtre adapté
for i=1:(Fse/2)
    P(i)=0.5;
    
end
for i=(Fse/2)+1:Fse
    P(i)=-0.5;
end


% preambule
preambule = [ones(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2)];





buffer = buffers(:);
    
% Le module au carré
Yl = buffer';
Rl=abs(Yl).^2;

% Estimation des indices ( synchronisation)
seuil = 0.7;
[ro , indices ] = synchro(Rl, preambule ,Fse,seuil) ;

Registres = [];
for i=1:length(indices)   

    Rl_i=Rl(indices(i)+8*Fse:indices(i)+Fse*112-1+8*Fse);
    
    % Filtre de reception adapté
    Vl=conv(Rl_i,P);
    
    % Echantillonage de V par Fse
    Vm=Vl(Fse:Fse:end);
    
    % Decision
    B_est = Vm < 0 ;

    % Registre
    registre = bit2registre(B_est,REF_LON,REF_LAT);
    
    % accepter les registres utiles
    if isstruct(registre) & registre.format == 17 & ~isempty(registre.longitude)
        Registres=[Registres registre];
    end
end


%% Tracer
% Coordonnees de reference (endroit de l'antenne)
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca


figure(1);
x = linspace(-1.3581,1.7128,2048);
y = linspace(44.4542,46.1683,2048);
im = imread('fond.png');
image(x-0.2,y(end:-1:1)-0.5,im);
set(gca,'YDir','normal')
hold on
plot(REF_LON,REF_LAT,'.r','MarkerSize',30);
text(REF_LON+0.07,REF_LAT,'Actual pos','color','b');
hold on

xlabel('Longitude en degres');
ylabel('Lattitude en degres');

registre_liste = Registres;
for i=1:size(registre_liste,2)
    registre = registre_liste(i);
    
    if ( isempty(registre.longitude) == 0)
        plot(registre.longitude,registre.latitude,'.b','MarkerSize',30);
        hold on;
        
    end
    
    
end

