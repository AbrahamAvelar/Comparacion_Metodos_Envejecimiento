function CleanData = calculaTiempos(CleanData, pls, odTh)
% BgDataAll = calculaTiempos(BgDataAll, pls, odTh)
    for pl=pls
        CleanData(pl).tOut=[];
        NuevosDias=EncuentraDias(CleanData(pl), odTh);
        NuevosDias=[NuevosDias length(CleanData(pl).t)];
        for Dia=1:length(NuevosDias)-1
            CleanData(pl).tOut=[CleanData(pl).tOut CleanData(pl).t(NuevosDias(Dia):NuevosDias(Dia+1)-1)-CleanData(pl).t(NuevosDias(Dia) )];
        end
        CleanData(pl).Tdays=CleanData(pl).t(NuevosDias)-CleanData(pl).t(1);
    end
end