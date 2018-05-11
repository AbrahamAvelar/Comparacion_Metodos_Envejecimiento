function CleanData = RoCtFijo (CleanData, t, tExponencial, odTh, pls, pozos, figura)
% BgDataAll = RoCtFijo (CleanData, t, tExponencial, odTh, pls, pozos, figura)
% t es un vector con 2 tiempos: donde empiezan y terminan las mediciones
% a tomar en cuenta. Idealmente seria la fase exponencial
% tExponencial es la hora a la que se hace la interpolacion.
% Ejemplo: CleanData = RoCtFijo(CleanData,7.5, [5 18], .3, 1:4, 1)
horaInt=tExponencial;
ExT=t;
mapita=JET;
for pl=pls%[10:13]
%    CleanData(pl).tOut=[];  comment and use calculaTiempos instead 8-feb-18
    NuevosDias=EncuentraDias(CleanData(pl), odTh);
    NuevosDias=[NuevosDias length(CleanData(pl).t)];
    difcol=floor( length(mapita)/(length(NuevosDias)-1) );
    for Dia=1:length(NuevosDias)-1
        for w=pozos
            tiempos=24*(CleanData(pl).t(NuevosDias(Dia):NuevosDias(Dia+1)-1)-CleanData(pl).t(NuevosDias(Dia)));
            cfps=log(CleanData(pl).CFP(NuevosDias(Dia):NuevosDias(Dia+1)-1,w)); cfps(isinf(cfps))=NaN;
            rfps=log(CleanData(pl).RFP(NuevosDias(Dia):NuevosDias(Dia+1)-1,w)); rfps(isinf(rfps))=NaN;
            ODs=(CleanData(pl).OD(NuevosDias(Dia):NuevosDias(Dia+1)-1,w)); ODs(isinf(ODs))=NaN;
            validas = find(tiempos>horaInt(1) & tiempos<horaInt(2));
            if sum(~isnan(cfps(validas)))>2 && sum(~isnan(rfps(validas))) >2
                m=robustfit(tiempos(validas), rfps(validas)-cfps(validas)); RedOverCyan=(m(2)*ExT)+m(1); CleanData(pl).RoC(Dia,w)=RedOverCyan;
            elseif sum(~isnan(cfps(validas)))>2 && sum(~isnan(rfps(validas))) >1
                RedOverCyan=interp1(tiempos(validas), rfps(validas)-cfps(validas), ExT ); CleanData(pl).RoC(Dia,w)=RedOverCyan;
            else
                CleanData(pl).RoC(Dia,w)=NaN;
            end
            if figura & sum(~isnan(cfps(validas)))>2 && sum(~isnan(rfps(validas))) >2
%                 figure(w)
%                 hold on
%                 plot(tiempos(1:end),ODs(1:end), '.-','color',mapita(difcol*Dia,:))
%                 hold on %plot(tiempos(validas),rfps(validas)-9, 'or') %plot(tiempos(validas),cfps(validas)-9, 'oc')
%                 plot( tiempos(1:end), rfps(1:end)-cfps(1:end), 'x-', 'color', mapita(difcol*Dia,:))
%                 plot(ExT, RedOverCyan, 'or','MarkerFaceColor', mapita(difcol*Dia,:))
%                 FastLabels('tiempo','RoC y OD','Resumen de datos')
%                 %legend( 'RFP', 'OD','CFP','RoCs','RoC at ExT','location','best' )
%                 figure(100+w)
%                 hold on
%                 plot3(ODs, tiempos, rfps-cfps,'o-', 'color', mapita(difcol*Dia,:))
%                 xlabel('OD')
%                 ylabel('horas')
%                 zlabel('RoC')

                figure(200+w)
                subplot(1,2,1)
                hold on
                plot( tiempos, rfps-cfps,'o-', 'color', mapita(difcol*Dia,:))
                plot( tiempos(validas), rfps(validas)-cfps(validas),'S-', 'color', mapita(difcol*Dia,:))%'MarkerFaceColor', mapita(difcol*Dia,:),
                FastLabels('tiempo','RoC','OD y RoC')
                plot([t t], [1 -3.5])
                ylim([-3.5 1])
                plot(tiempos,ODs, '.-','color',mapita(difcol*Dia,:))
                plot(tiempos(validas),ODs(validas), 's-','color',mapita(difcol*Dia,:))
                grid on
                subplot(1,2,2)
                hold on
                plot( ODs, rfps-cfps,'o-', 'color', mapita(difcol*Dia,:) )
                plot( ODs(validas), rfps(validas)-cfps(validas),'s-', 'color', mapita(difcol*Dia,:) )
                FastLabels('OD','RoC','Resumen de datos')
                ylim([-3.5 1])
                grid on
                %plot(tiempos(validas(1)-1:validas(end)),ODs(validas(1)-1:validas(end)), '.-','color',mapita(difcol*Dia,:) )
                %plot( tiempos(validas), rfps(validas)-cfps(validas), 'x-', 'color', mapita(difcol*Dia,:) )
                
            end
        end
%        CleanData(pl).tOut=[CleanData(pl).tOut CleanData(pl).t(NuevosDias(Dia):NuevosDias(Dia+1)-1)-CleanData(pl).t(NuevosDias(Dia) )];  comment and use calculaTiempos instead 8-feb-18
    end
%	CleanData(pl).Tdays=CleanData(pl).t(NuevosDias)-CleanData(pl).t(1);  comment and use calculaTiempos instead 8-feb-18
end
end
