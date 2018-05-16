function [bgdataEGG]=BgDataAll2bgdataEGG(BgDataAllAA,plt,NameRef, NameMut,exp)
% BgDataAll2bgdataEGG(BgDataAllAA,plt,NameRef, NameMut)
% convierte
% OD en od
% CFP en ref
% RFP en mut
% t en el formato de EGG
% el parametro exp=1 cuando se le pasan solo datos de fase% exponencial
bgdataEGG = BgDataAllAA;
    for i=plt
        
        
        bgdataEGG(i).od = BgDataAllAA(i).OD;
        bgdataEGG(i).ref = BgDataAllAA(i).(str2mat(NameRef));
        bgdataEGG(i).mut = BgDataAllAA(i).(str2mat(NameMut));
        if exp
            bgdataEGG(i).t =(BgDataAllAA(i).t')*24;
        else
            bgdataEGG(i).t =(BgDataAllAA(i).t'-BgDataAllAA(i).t(1))*24;
        end
    end
end
