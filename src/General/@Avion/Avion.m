classdef Avion < handle
    properties
        displayText       = true,
        trackTrajectory   = true,
        displayTrajectory = true,
        displayLogo       = true
    end
    %% Private properties
    properties (SetAccess = private)
        latitude, % latitude de l'avion,
        longitude, % longitude de l'avion,
        altitude, % altitude de l'avion,
        adresse,  % adresse ICAO de l'avion(24 bits)
        
        nom, % nom de l'avion ('AF-1234')
        
        trajectoire,
        trames,
        
        handleFigurePlane = [],
        handleTextPlane = [],
        handleTrajectoryPlane = [];
        handleLogo = [];
    end
    
    methods
        function obj = Avion(nom,varargin)
            obj.nom = nom;
            
            switch nargin-1
                case 0
                    %% Cas Avion(nom)
                    % Dans ce cas l'avion est créé au sol sur l'aéroport de
                    % Mérignac
                    obj.longitude = [];
                    obj.latitude = [];
                    obj.altitude = [];
                    obj.adresse = '';
                    
                    
                case 2
                    %% Cas Avion(nom,lon,lat)
                    % Dans ce cas l'avion est créé au sol avec les
                    % coordonnées fournies
                    obj.longitude = varargin{1};
                    obj.latitude = varargin{2};
                    obj.altitude = [];
                    obj.adresse = '';
                    
                case 3
                    %% Cas Avion(nom,lon,lat,alt)
                    % Dans ce cas l'avion est créé au sol avec les
                    % coordonnées fournies
                    obj.longitude = varargin{1};
                    obj.latitude = varargin{2};
                    obj.altitude = varargin{3};
                    obj.adresse = '';
                    
                case 4
                    %% Cas Avion(nom,lon,lat,alt,adresse)
                    % Dans ce cas l'avion est créé au sol avec les
                    % coordonnées fournies
                    obj.longitude = varargin{1};
                    obj.latitude = varargin{2};
                    obj.altitude = varargin{3};
                    obj.adresse = varargin{4};
                    
                otherwise
                    error('Constructeur non reconnu')
            end
            if obj.trackTrajectory
                obj.trajectoire = [obj.longitude ; obj.latitude ; obj.altitude];
            else
                obj.trajectoire = [];
            end
            obj.trames = [];
            obj.handleFigurePlane = [];
            obj.handleTextPlane = [];
            obj.handleTrajectoryPlane = [];
            obj.handleLogo = [];
        end
        function setPosition(obj,lon,lat,alt)
            if nargin < 2
                error('Cette fonction prends au moins deux arguments : longitude, latitude')
            end
            if isempty(alt)
                alt  =0;
            end
            obj.longitude = lon;
            obj.latitude = lat;
            obj.altitude = alt;
            if obj.trackTrajectory
                obj.trajectoire = [obj.trajectoire, [obj.longitude;obj.latitude;obj.altitude] ];
            end
        end
        function updateWithRegister(obj,reg)
            if reg.type > 0 && reg.type <= 4
                if isempty(obj.nom) && ~isempty(reg.planeName)
                    obj.nom = reg.planeName;
                end
                if isempty(obj.adresse)
                    obj.adresse = ['0x', reg.adresse];
                end
                
            elseif reg.type>4 && reg.type<=17
                obj.setPosition(reg.longitude,reg.latitude,reg.altitude)
                if isempty(obj.adresse)
                    obj.adresse = ['0x', reg.adresse];
                end
            end
            
            
        end
        function addTrame(obj,trame)
            obj.trames = [obj.trames, trame(:)];
        end
        function setLattitude(obj,lat)
            obj.latitude = lat;
        end
        function setLongitude(obj,lon)
            obj.longitude = lon;
        end
        function setAltitude(obj,alt)
            obj.altitude = alt;
        end
        function setAdresse(obj,adresse)
            obj.adresse = adresse;
        end
        
        function varargout = plot(obj,varargin)
            varargout{1} = [];
            varargout{2} = [];
            varargout{3} = [];
            if ~isempty([obj.longitude,obj.latitude])
                if isempty(obj.nom)
                    etiquette = obj.adresse;
                else
                    etiquette = obj.nom;
                end
                obj.handleFigurePlane = plot(obj.longitude,obj.latitude,varargin{:});
                c = get(obj.handleFigurePlane,'Color');
                if obj.displayText
                    obj.handleTextPlane = text(obj.longitude,obj.latitude,etiquette,'color',c,'Margin',3,'HorizontalAlignment','center','VerticalAlignment','bottom','FontSize',12);
                end
                if obj.displayTrajectory
                    
                    obj.handleTrajectoryPlane = plot(obj.trajectoire(1,:),obj.trajectoire(2,:),'--','color',c);
                    
                end
                
                if nargout == 3
                    varargout{1} = obj.handleFigurePlane;
                    varargout{2} = obj.handleTextPlane;
                    varargout{3} = obj.handleTrajectoryPlane;
                end
            end
        end
        
        function printTrajectoireInFile(obj,fid)
            nI = size(obj.trajectoire,2);
            nM = size(obj.trajectoire,1);
            
            for i = 1:nI
                for m = 1:nM-1
                    fprintf(fid, '%f,' ,obj.trajectoire(m,i));
                end
                fprintf(fid, '%f \n' ,obj.trajectoire(nM,i));
            end
        end
        
        function printTramesInFile(obj,fid)
            nI = size(obj.trames,2);
            nM = size(obj.trames,1);
            for i = 1:nI
                for m = 1:nM-1
                    fprintf(fid, '%f,%f,' ,real(obj.trames(m,i)),imag(obj.trames(m,i)));
                end
                fprintf(fid, '%f,%f \n' ,real(obj.trames(nM,i)),imag(obj.trames(nM,i)));
            end
        end
    end
end

