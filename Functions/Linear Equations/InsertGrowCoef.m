function COLUMNAS=InsertGrowCoef(COLUMNAS, BgDataAll, pl, wells)
% COLUMNAS=InsertGrowCoef(COLUMNAS, BgDataAll, pl, wells);

mediciones=length(BgDataAll(pl).t);

for w=wells
    
    COLUMNAS((mediciones*(w-1))+1:(mediciones*(w)),length(wells)*2+w)=[ BgDataAll(pl).tOut BgDataAll(pl).tOut(end) ];
    
end


end