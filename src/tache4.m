clear all;
close all;
clc;

%% INITIALISATION

Ts=1e-6;
Fe=20e6;
Te=1/Fe;
Fse=Ts/Te;
nb=112;
np=8;

df=1000;
delta_f= -df+2*df*rand;

n=round(rand*100);
delta_t=n*Te;
delai=zeros(1,n);

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


preambule_zeros=zeros(1,Fse/2);
preambule_ones=ones(1,Fse/2);
preambule=[ones(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2)];

sl=[preambule sl];
sl=[delai sl];

t = 1:1:size(sl,2); 
yl = sl.*exp(-1i*2*pi*delta_f*t) ;

[delta ind]=Synchonisation(yl,Fe);

sl2=sl(np*Fse+ind+1:end);

rl=conv(sl2,p);

rm=[];
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
        
% pour voir qu'on estime bien le décalage regarder ind et n : ils sont
% égaux


