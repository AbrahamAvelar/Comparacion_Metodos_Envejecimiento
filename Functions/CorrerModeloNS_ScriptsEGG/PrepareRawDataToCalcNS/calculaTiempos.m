function CleanData = calculaTiempos(CleanData, pls, odTh)
% BgDataAll = calculaTiempos(BgDataAll, pls, odTh)
    for pl=pls
        CleanData(pl).tOut=[];
        NuevosDias=EncuentraDias(CleanData(pl), odTh);
        NuevosDiasA=[NuevosDias length(CleanData(pl).t)];
        NuevosDiasB=[NuevosDias length(CleanData(pl).t)+1];
        for Dia=1:length(NuevosDiasB)-1
            CleanData(pl).tOut=[CleanData(pl).tOut CleanData(pl).t(NuevosDiasB(Dia):NuevosDiasB(Dia+1)-1)-CleanData(pl).t(NuevosDiasB(Dia) )];
        end
        CleanData(pl).Tdays=CleanData(pl).t(NuevosDiasA)-CleanData(pl).t(1);
    end
end