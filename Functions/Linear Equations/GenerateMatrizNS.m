function [MATRIZ VECTOR] = GenerateMatrizNS(BgDataAll, pl, wells)
% [MATRIZ VECTOR] = GenerateMatrizNS(BgDataAll, pl, wells)
%
% wells -- debe empezar siempre en 1, puedes hacer pocos 1:10, pero nunca
% 10:20 Normalmente deber'ia ser 1:96
% plt -- solo un plato a la vez

COLUMNAS=[];
VECTOR=[];
    

mediciones = length(BgDataAll(pl).t); %saber cuantas mediciones hubo
for w = wells %llena los Axw, Sw y Gw de los pozos en las primeras length(wells)*3 columnas.
	COLUMNAS((mediciones*(w-1))+1:(mediciones*(w)),w ) = ones(mediciones,1); %Coeficientes de Ax
end
COLUMNAS=InsertBigSCoef(COLUMNAS, BgDataAll, pl, wells);
COLUMNAS=InsertGrowCoef(COLUMNAS, BgDataAll, pl, wells);
COLUMNAS=InsertCTtError(COLUMNAS, mediciones);    
    
MATRIZ=COLUMNAS;

for w=wells
    VECTOR = [VECTOR; log(BgDataAll(pl).RFP(:,w)) - log(BgDataAll(pl).CFP(:,w))] ;
end

end