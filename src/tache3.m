% Algorithmes de codage et de décodage de canal 

clear all ;close all ; clc

Ts=1e-6;
Fe=20e6;
Te=1/Fe;
Fse=Ts/Te;

nb=88;

p0=[];
p1=[];
p=[];
sl=[];
yl=[];  
rl=[];
bk_est=[];
rm=[];
axe_dB = 0:1:10;
axe_dec = 10.^(axe_dB/10);


% GENERATION DE Bk 
bk=randi([0 1],1,nb);


% APPLICATION DU CODEUR CRC
bk = codeur (bk);
bk = bk';

% MODULATION PPM

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

% BRUIT DU CANAL 

Eb = max(sl)*0.08;   % taux du bruit                   
sigma = sqrt((1/2)*(1./axe_dec)*Eb);

for k=1:size(sigma,2)  
    nl = sigma(k) * randn(1,size(sl,2)); 
end                                  
                                        
yl=[];
yl = sl+nl;

reel = yl;
rl=conv(yl,p);

% ECHANTILLONAGE

rm=[];
for i=1:size(rl,2)/Fse
  rm=[rm rl(Fse*i)];
end


% DECISION

seuil=4.5;

for i=1:size(bk,2)
  if rm(i)>seuil
      bk_est=[bk_est 0];
  else
      bk_est=[bk_est 1];
  end
end

 
% APPLICATION DU DECODEUR CRC

[code,error] = decodeur(bk_est);

code = code';

error

