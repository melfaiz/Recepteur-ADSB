clear ;close all ; clc

load('C:\melfaiz\THOR-TS229-ComNum\data\adsb_msgs.mat');

%´ FTC: [|9,18|] U [|20,22|]-> Position vol / [|1,4|] indentification

% Coordonnees de reference (endroit de l'antenne)
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca



registre_list =  [] ;

for i=1:size(adsb_msgs,2)
    registre = bit2registre(adsb_msgs(:,i)',REF_LON,REF_LAT) ;
    registre_list = [registre_list registre];

end


lat = [];
lon = [];
alt = [];

for i=1:size(registre_list,2)
    
    registre = registre_list(i);
    if  registre.type == 6
        lat = [lat registre.latitude];
        lon = [lon registre.longitude];
        alt = [alt registre.altitude];
        
    end
   

end


figure(1);
x = linspace(-1.3581,1.7128,2048);
y = linspace(44.4542,46.1683,2048);

im = imread('fond.png');

image(x-0.3,y(end:-1:1)-0.5,im);
set(gca,'YDir','normal')
hold on
plot(REF_LON,REF_LAT,'.r','MarkerSize',30);
text(REF_LON+0.05,REF_LAT,'Actual pos','color','b');


xlabel('Longitude en degres');
ylabel('Lattitude en degres');

title("Trajectoire de l'avion 3420CA au vol IBE3405");

x = lon(1:4:end);
y = lat(1:4:end);

text(x+0.07,y ,registre.adresse,'color','b');
hold on
plot(lon,lat,'*','MarkerSize',10)

