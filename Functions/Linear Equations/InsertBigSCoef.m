function COLUMNAS=InsertBigSCoef(COLUMNAS, BgDataAll, pl, wells)
% COLUMNAS=InsertBigSCoef(COLUMNAS, BgDataAll, pl, wells);


dias=[find(BgDataAll(pl).tOut==0) length(BgDataAll(pl).t) ];
vec=[];

for i=1:length(dias)-1
    
    vec=[vec ones( 1,dias(i+1)-dias(i) )*BgDataAll(pl).Tdays(i) ];
    
end
vec(length(BgDataAll(pl).t))=BgDataAll(pl).Tdays(i);
mediciones=length(vec);

for w=1:length(wells)
    COLUMNAS((mediciones*(w-1))+1:(mediciones*(w)),length(wells)+w) = vec' ;%Coeficientes de Big_Snoam
end

end

