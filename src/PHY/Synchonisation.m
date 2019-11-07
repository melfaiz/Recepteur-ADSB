function [ro, ind, rl]=Synchonisation(yl,Fe)
%% Paramètres

Te = 1/Fe;
Ts = 1e-6; 
Fse = Ts/Te;

% Signal du filtre

p = [zeros(1,Fse/2) ones(1,Fse/2)];
for i=1:size(p,2)
if p(i)== 1
p(i) = 0.5;
else
p(i) = -0.5;
end
end

% Signal préambule

preambule_zeros=zeros(1,Fse/2);
preambule_ones=ones(1,Fse/2);
preambule=[ones(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) ones(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2) zeros(1,Fse/2)];

%% Chaine de communication en reception

% Module au carré
rl = abs(yl).^2;

%Estimation de delta

ro=[];
b = sum(abs(preambule).^2);
for i=1:length(rl)-length(preambule)
    c =sum(abs(rl(i:i+length(preambule)-1)).^2);
    a =sum(rl(i:i+length(preambule)-1).*conj(preambule));
    ro=[ro a/(sqrt(b).*sqrt(c))];
end

[ro_max, indice]=max(ro);
ind=indice-1;


end