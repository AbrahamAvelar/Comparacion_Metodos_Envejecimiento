function ExpBgDataAll = ExtractExponentialPoints(BgDataAll, platos, fig,pozos,Tiempo0)
% ExpBgDataAll = ExtractExponentialPoints(BgDataAll, platos)
    
    
    for pl=platos
        PuntosExponencial = EncuentraExponencial(BgDataAll(pl).OD, BgDataAll(pl).t, 0);
        if Tiempo0
            NuevosDias=EncuentraDias(BgDataAll(pl), .22 );
            PuntosExponencial = sort([PuntosExponencial NuevosDias]);
        end
        ExpBgDataAll(pl).OD = BgDataAll(pl).OD(PuntosExponencial,:) ;
        ExpBgDataAll(pl).CFP = BgDataAll(pl).CFP(PuntosExponencial,:) ;
        ExpBgDataAll(pl).RFP = BgDataAll(pl).RFP(PuntosExponencial,:) ;
        ExpBgDataAll(pl).t = BgDataAll(pl).t(PuntosExponencial)-BgDataAll(pl).t(1) ;
        
        figure(1000+pl)
        if fig
            plot( BgDataAll(pl).OD(:,pozos), 'k' )
            hold on
            plot(PuntosExponencial, BgDataAll(pl).OD(PuntosExponencial,pozos), 'o-g' )
            
            plot( log10(BgDataAll(pl).RFP(:,pozos))-3, 'm' )
            hold on
            plot(PuntosExponencial, log10(BgDataAll(pl).RFP(PuntosExponencial,pozos))-3, 'o-r' )
            
            plot( log10(BgDataAll(pl).CFP(:,pozos))-3, 'c' )
            hold on
            plot(PuntosExponencial, log10(BgDataAll(pl).CFP(PuntosExponencial,pozos))-3, 'o-b' )
            
        end
    end
    
    
end