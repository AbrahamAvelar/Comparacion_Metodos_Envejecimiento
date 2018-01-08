function CleanData = CalcRelatSurv (BgDataAll, Pls )
% CleanData = CalcRelatSurv (BgDataAll, Pls )
CleanData=BgDataAll;
for pl=Pls
    figure(100+pl)
    clf
    for i=1:96
        subplot(12,8,i)
        NuevosDias=EncuentraDias(CleanData(pl), .3);
        ejex=CleanData(pl).t(NuevosDias)-CleanData(pl).t(1);
        if length(find(~isnan(CleanData(pl).RoC(:,i) ) ))>2
            m=robustfit(ejex,CleanData(pl).RoC(:,i));
            CleanData(pl).s(i,:)=m;
            plot(ejex,CleanData(pl).RoC(:,i),'ok' )
            hold on
            plot([0 20], [m(1) m(2)*18+m(1)],'r' )
            ylim([-3 3])
            xlim([-1 16])
            text(6,1.4,num2str( floor(m(2)*10000)/10000 ))
        else
            CleanData(pl).s(i,:)=[NaN NaN];
        end
    
    end
end

end