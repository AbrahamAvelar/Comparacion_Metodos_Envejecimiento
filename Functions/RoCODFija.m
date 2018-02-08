function CleanData = RoCODFija( CleanData, ExOD, minOD, maxOD, pls,odTh)
%   BgDataAll = RoCODFija( CleanData, ExOD, minOD, maxOD, pls,odTh)
for pl=pls %[1:4 10:13]
%    CleanData(pl).tOut=[]; comment and use calculaTiempos instead 8-feb-18
    NuevosDias=EncuentraDias(CleanData(pl), odTh);
    NuevosDias=[NuevosDias length(CleanData(pl).t) ];
    for Dia=1:length(NuevosDias)-1
        for w=1:96
            ods=CleanData(pl).OD(NuevosDias(Dia):NuevosDias(Dia+1)-1,w);
            cfps=log(CleanData(pl).CFP(NuevosDias(Dia):NuevosDias(Dia+1)-1,w));
            cfps(isinf(cfps))=NaN;
            rfps=log(CleanData(pl).RFP(NuevosDias(Dia):NuevosDias(Dia+1)-1,w));
            rfps(isinf(rfps))=NaN;
            validas=find(ods>minOD & ods<maxOD);
            if validas
                if validas(1)>1
                %validas = validas-1;
                end
            end
%             colo=[0+1/Dia*(1/15) .3 (Dia)*(1/15)];
%             figure(w)
%             hold on
%             Figuritas(ods, cfps, rfps,validas,w, colo)
%             pause            
            if sum(~isnan(cfps(validas)))>2 && sum(~isnan(rfps(validas))) >2
                m=robustfit(ods(validas), rfps(validas)-cfps(validas) );
                RedOverCyan=(m(2)*ExOD)+m(1);
                CleanData(pl).RoC(Dia,w)=RedOverCyan;
            else
                CleanData(pl).RoC(Dia,w)=NaN;
            end
        end
%        CleanData(pl).tOut=[CleanData(pl).tOut CleanData(pl).t(NuevosDias(Dia):NuevosDias(Dia+1)-1)-CleanData(pl).t(NuevosDias(Dia) )]; comment and use calculaTiempos instead 8-feb-18
    end
%    CleanData(pl).Tdays=CleanData(pl).t(NuevosDias)-CleanData(pl).t(1);  comment and use calculaTiempos instead 8-feb-18
end

end
