function code = codeur(bk)

% INPUTS : bk 
% OUTPUTS: code


poly_crc = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1]  ; %  polynome generateur 

crc_generator = crc.generator('polynomial',poly_crc);

code = generate(crc_generator, bk');


end

