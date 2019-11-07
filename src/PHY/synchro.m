function [ro indices ] = synchro(rl , sp,Fse,seuil)

A=[0:length(rl)-120*Fse-1];
ro=zeros(1,length(A));

for i=1:length(A)
    
    a = rl( A(i)+1:A(i)+Fse*8).*sp ;
    
    b = sum(sp.^2);
    
    c = sum(rl(A(i)+1:A(i)+Fse*8).^2) ;
    
    ro(i) = sum(a)/(sqrt(b)*sqrt(c));

end


ro=ro>seuil;
indices=find(ro);

end

