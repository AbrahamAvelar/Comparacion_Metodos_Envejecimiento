function     COLUMNAS=InsertCTtError(COLUMNAS,mediciones)
% COLUMNAS=InsertCTtError(COLUMNAS,mediciones)
tam = size(COLUMNAS,2);
for med = 1:mediciones
    
    COLUMNAS( med:mediciones:length(COLUMNAS), tam+med) = 1 ;
    
end

end