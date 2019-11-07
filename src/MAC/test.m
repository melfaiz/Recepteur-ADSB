clear ;close all ; clc

load('C:\melfaiz\THOR-TS229-ComNum\data\adsb_msgs.mat');

%´ FTC: [|9,18|] U [|20,22|]-> Position vol / [|1,4|] indentification

% Initialisation des variables
registre = struct('adresse',[],'format',[],'type',[],'nom',[],'altitude',[],'timeFlag',[],'cprFlag',[],'latitude',[],'longitude',[], 'trajectoire', [], 'Caractere_1_identifiant',[],'Caractere_2_identifiant',[],'Caractere_3_identifiant',[],'Caractere_4_identifiant',[],'Caractere_5_identifiant',[],'Caractere_6_identifiant',[],'Caractere_7_identifiant',[],'Caractere_8_identifiant',[],'Categorie_appareil',[],'Identificateur_mouvement',[],'statut',[]);
decodage=struct('A',bi2de(fliplr([1,0,0,0,0,0])),'B',bi2de(fliplr([0,1,0,0,0,0])),'C',bi2de(fliplr([1,1,0,0,0,0])),'D',bi2de(fliplr([0,0,1,0,0,0])),'E',bi2de(fliplr([1,0,1,0,0,0])),'F',bi2de(fliplr([0,1,1,0,0,0])),'G',bi2de(fliplr([1,1,1,0,0,0])),'H',bi2de(fliplr([0,0,0,1,0,0,])),'I',bi2de(fliplr([1,0,0,1,0,0])),'J',bi2de(fliplr([0,1,0,1,0,0])),'K',bi2de(fliplr([1,1,0,1,0,0])),'L',bi2de(fliplr([0,0,1,1,0,0])),'M',bi2de(fliplr([0,1,1,1,0,0])),'N',bi2de(fliplr([0,1,1,1,0,0])),'O',bi2de(fliplr([1,1,1,1,0,0])),'P',bi2de(fliplr([0,0,0,0,0,1])),'Q',bi2de(fliplr([1,0,0,0,0,1])),'R',bi2de(fliplr([0,1,0,0,0,1])),'S',bi2de(fliplr([1,1,0,0,0,1])),'T',bi2de(fliplr([0,0,1,0,0,1])),'U',bi2de(fliplr([1,0,1,0,0,1])),'V',bi2de(fliplr([0,1,1,0,0,1])),'W',bi2de(fliplr([1,1,1,0,0,1])),'X',bi2de(fliplr([0,0,0,1,0,1])),'Y',bi2de(fliplr([1,0,0,1,0,1])),'Z',bi2de(fliplr([0,1,0,1,0,1])),'SP',bi2de(fliplr([0,0,0,0,1,0])),'A0',bi2de(fliplr([0,0,0,0,1,1])),'A1',bi2de(fliplr([1,0,0,0,1,1])),'A2',bi2de(fliplr([0,1,0,0,1,1])),'A3',bi2de(fliplr([1,1,0,0,1,1])),'A4',bi2de(fliplr([0,0,1,0,1,1])),'A5',bi2de(fliplr([1,0,1,0,1,1])),'A6',bi2de(fliplr([1,1,0,0,1,1])),'A7',bi2de(fliplr([1,1,1,0,1,1])),'A8',bi2de(fliplr([0,0,0,1,1,1])),'A9',bi2de(fliplr([1,0,0,1,1,1])));


 % Coordonnees de reference (endroit de l'antenne)
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca

lat = [];
lon = [];

for i=1:size(adsb_msgs,2)
    registre = bit2registre(adsb_msgs(:,i)', REF_LON,REF_LAT);
    if i == 25
        break
    end
        lat = [lat registre.latitude];
    lon = [lon registre.longitude];
end

registre
plot(lon,lat,'o')