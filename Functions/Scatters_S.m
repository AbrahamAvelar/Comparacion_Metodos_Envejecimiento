function Scatters_S (NSBgDataAll, ODBgDataAll, TBgDataAll, pls, previousS4, bgdataAll)

for platos=pls
    figure(200+platos)
    clf

    subplot(2,3,1)
    plot(NSBgDataAll(platos).s, TBgDataAll(platos).s(:,2),'o')
            [r p]=corrcoef(NSBgDataAll(platos).s, TBgDataAll(platos).s(:,2));
        StatsToShow=strcat('r=',num2str( floor(r(2)*10000)/10000 ), 'pval=',num2str(floor(p(2)*10000)/10000));
        legend(StatsToShow,'Location','Best')
    %text(tosave1,TSEC(platos).s(:,2),bgdataAll(platos).Names)
    fastLabels('S_Noam', 'S_Tfijo', 'Scatter de Ss')
        
    subplot(2,3,2)
    plot(NSBgDataAll(platos).s, ODBgDataAll(platos).s(:,2),'o')
            [r p]=corrcoef(NSBgDataAll(platos).s, ODBgDataAll(platos).s(:,2));
        StatsToShow=strcat('r=',num2str( floor(r(2)*10000)/10000 ), 'pval=',num2str(floor(p(2)*10000)/10000));
        legend(StatsToShow,'Location','Best')
    %text(tosave1,ODSEC(platos).s(:,2),bgdataAll(platos).Names)
    fastLabels('S_Noam', 'S_ODfija', 'Scatter de Ss')
        
    subplot(2,3,3)
    plot(TBgDataAll(platos).s(:,2),ODBgDataAll(platos).s(:,2),'o')
            [r p]=corrcoef(TBgDataAll(platos).s(:,2),ODBgDataAll(platos).s(:,2));
        StatsToShow=strcat('r=',num2str( floor(r(2)*10000)/10000 ), 'pval=',num2str(floor(p(2)*10000)/10000));
        legend(StatsToShow,'Location','Best')
    %text(TSEC(platos).s(:,2),ODSEC(platos).s(:,2),bgdataAll(platos).Names)
    fastLabels('S_Tfijo', 'S_ODfija', 'Scatter de Ss')

    
    
    subplot(2,3,4)
    plot(bgdataAll(platos).s4(1,:), TBgDataAll(platos).s(:,2),'o')
    valid=~isnan(bgdataAll(platos).s4(1,:));
            [r p]=corrcoef(bgdataAll(platos).s4(1,valid), TBgDataAll(platos).s(valid,2));
        StatsToShow=strcat('r=',num2str( floor(r(2)*10000)/10000 ), 'pval=',num2str(floor(p(2)*10000)/10000));
        legend(StatsToShow,'Location','Best')
   text(bgdataAll(platos).s4(1,:), TBgDataAll(platos).s(:,2),bgdataAll(platos).Names)
    fastLabels('S4-bgdataAll','S_Tfija','Scatter de Ss')
    
    subplot(2,3,5)
    plot(bgdataAll(platos).s4(1,:),NSBgDataAll(platos).s,'o')
            [r p]=corrcoef(bgdataAll(platos).s4(1,valid),NSBgDataAll(platos).s(valid));
        StatsToShow=strcat('r=',num2str( floor(r(2)*10000)/10000 ), 'pval=',num2str(floor(p(2)*10000)/10000));
        legend(StatsToShow,'Location','Best')

    text(bgdataAll(platos).s4(1,:),NSBgDataAll(platos).s,bgdataAll(platos).Names)
    fastLabels('S4-bgdataAll','S-Noam','Scatter de Ss')
    
    subplot(2,3,6)
    plot(bgdataAll(platos).s4(1,:),ODBgDataAll(platos).s(:,2),'o')
            [r p]=corrcoef(bgdataAll(platos).s4(1,valid),ODBgDataAll(platos).s(valid,2));
        StatsToShow=strcat('r=',num2str( floor(r(2)*10000)/10000 ), 'pval=',num2str(floor(p(2)*10000)/10000));
        legend(StatsToShow,'Location','Best')

    text(bgdataAll(platos).s4(1,:),ODBgDataAll(platos).s(:,2),bgdataAll(platos).Names)
    fastLabels('S4-bgdataAll','S-ODfija','Scatter de Ss')
    
    
end
end