function [code,error] = decodeur(bk_est)

% INPUT : bk_est
% OUTPUT : code , error(boolean)

poly_crc = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1]  ; %  polynome generateur 

crc_detector = crc.detector('polynomial',poly_crc);

[code,error] = detect(crc_detector, bk_est');

end

