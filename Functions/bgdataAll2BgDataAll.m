function BgDataAll = bgdataAll2BgDataAll (bgdataAll, platos)
%  BgDataAll = bgdataAll2BgDataAll (bgdataAll, platos)
%
%  Convierte los bgdataAll que salen de los scripts de SEC y los convierte
%  en los BgDataAll que salen de ReadTecanFiles de JAAR; esto es necesario
%  porque los scripts para hacer lo de Noam y/o las comparaciones entre
%  RoCtFijo vs RoCODFija.


for pl = platos
    
    BgDataAll(pl).OD=bgdataAll(pl).od;
    BgDataAll(pl).CFP=bgdataAll(pl).cfp;
    BgDataAll(pl).RFP=bgdataAll(pl).rfp;
    BgDataAll(pl).t= bgdataAll(pl).t'/24;
    BgDataAll(pl).Tdays=bgdataAll(pl).tDays';

end
end