function registre= bit2registre(adsb_msg,REF_LON,REF_LAT)

[~,erreur] = decodeur(adsb_msg);

registre = struct('adresse',[],'format',[],'type',[],'nom',[],'timeFlag',[],'cprFlag',[],'latitude',[],'longitude',[],'altitude',[]);

registre.format = bi2de(adsb_msg(1:5));
     

if (erreur==0)
    
    
    registre.adresse = dec2hex(bin2dec(int2str(adsb_msg(9:32)))); % adresse OACI de l'avion
   
    registre.type = bi2de(adsb_msg(33:37));
    
    
            
    registre.altitude = 0;
    registre.latitude = 0;
    registre.longitude = 0;
    
  
    if( ( registre.type > 8 && registre.type < 19 ) || ( registre.type < 23  && registre.type > 19 ) ) % Position de vol
        
        
        registre.nom='';
        registre.timeFlag=0;
        
        registre.cprFlag=adsb_msg(54);

       
        % Latitude
        
        nz=15;
        nb=17;
        
        LAT=bi2de(fliplr(adsb_msg(55:71)));
        
        latitude_d=360/(nz-registre.cprFlag);
        
        modulo=REF_LAT-latitude_d*floor(REF_LAT/latitude_d);
        j= floor(REF_LAT/latitude_d)+floor(0.5+modulo/latitude_d -LAT/(2^nb));
        laitude=latitude_d*(j+ LAT/2^(nb));
        
        registre.latitude=laitude;
        
        % Longitude
        longitude=bi2de(fliplr(adsb_msg(72:88)));
        if cprNL(laitude)-registre.cprFlag >0
            longitude_d=360/(cprNL(laitude)-registre.cprFlag);
        elseif cprNL(laitude)-registre.cprFlag == 0
            longitude_d=360;
        end
        modulo=REF_LON-longitude_d*floor(REF_LON/longitude_d);
        m = floor(REF_LON/longitude_d)+floor(0.5+ modulo/longitude_d - longitude/(2^nb));
        lon=longitude_d*(m + longitude/2^(nb));
        
        registre.longitude=lon;
        
        % Altitude
        
         
         Ra = adsb_msg(41:52);
         Ra = [Ra(1:7) Ra(9:12)];
         altitude = 25*bi2de(flip(Ra)) - 1000;
         registre.altitude = altitude;
     
  
        
    elseif ( registre.type>0 &  registre.type<5 ) % Identification
        
        
        
        
        
        c1=dec2char(bi2de(adsb_msg(41:46),'left-msb'));
        c2=dec2char(bi2de(adsb_msg(47:52),'left-msb'));
        c3=dec2char(bi2de(adsb_msg(53:58),'left-msb'));
        c4=bi2de(adsb_msg(59:64),'left-msb');
        c5=bi2de(adsb_msg(65:70),'left-msb');
        c6=bi2de(adsb_msg(71:76),'left-msb');
        c7=bi2de(adsb_msg(77:82),'left-msb');
        c8=bi2de(adsb_msg(83:88),'left-msb');
        
        registre.nom = strcat(c1,c2,c3,c4,c5,c6,c7,c8);
        
        registre.latitude = [] ;
        registre.longitude = [];
        
    elseif ( registre.type>4 &  registre.type<9 ) % Position au sol
        
        

        registre.timeFlag=adsb_msg(53);
        
        registre.cprFlag=adsb_msg(54);
        
        
        
        % Latitude
        nz=15;
        nb=17;
        LAT=bi2de(fliplr(adsb_msg(55:71)));
        
        latitude_d=360/(4*nz-registre.cprFlag);
        modulo=REF_LAT-latitude_d*floor(REF_LAT/latitude_d);
        j= floor(REF_LAT/latitude_d)+floor(0.5+modulo/latitude_d -LAT/(2^nb));
        laitude=latitude_d*(j+ LAT/(2^nb));
        registre.latitude=laitude;
        
        % Longitude
        longitude=bi2de(fliplr(adsb_msg(72:88)));
        if (cprNL(laitude)-registre.cprFlag >0)
            longitude_d=360/(cprNL(laitude)-registre.cprFlag);
        elseif cprNL(laitude)-registre.cprFlag == 0
            longitude_d=360;
        end
        
        modulo= REF_LON-longitude_d*floor(REF_LON/longitude_d);
        m = floor(REF_LON/longitude_d)+floor(0.5+ modulo/longitude_d - longitude/(2^nb));
        lon = longitude_d*(m + longitude/(2^nb));
        registre.longitude=lon;
        
        % Altitude
                 
        Ra = adsb_msg(41:52);
        Ra = [Ra(1:7) Ra(9:12)];
        altitude = 25*bi2de(flip(Ra)) - 1000;
        registre.altitude = altitude;
     

    end
end
end