function NSBgDataAll = figureS_NS(NSBgDataAll, x, platos, sizepozos, pozos, toremove,bgdataAll)
% figureS_NS(x, platos, sizepozos)
col=[.7 .2 1];
        figure(300+platos)
        clf
        subplot(2,2,1)
        hold on
        plot( x(sizepozos+1:sizepozos*2), 'o-', 'color',  col )
        if toremove
            tosave1(toremove)=NaN;
        end
        tosave1(setdiff(pozos,toremove))=x(sizepozos+1:sizepozos*2);
        NSBgDataAll(platos).s=tosave1;
        xlabel('pozos')
        ylabel('S_Noam')
    
        grid on
        subplot(2,2,3)
        hold on
        plot(x(sizepozos*2+1:sizepozos*3),'o-','color', col  )
        grid on
        if toremove
            tosave1(toremove)=NaN;
        end
        tosave2(setdiff(pozos,toremove))=x(sizepozos*2+1:sizepozos*3);
        NSBgDataAll(platos).G=tosave2;
        xlabel('pozos')
        ylabel('G_Noam')
    
        subplot(2,2,2)
        hold on
        plot(x,'-','color', col)
        title('LinSolve con todas las variables')
        hold on
        text( [sizepozos/6 sizepozos*1.15 sizepozos*2.15 sizepozos*3.15], [ones(1,4)*max(x)], {'Ax = ln(Nx/Nwt)_T_0', 'S_N_o_a_m=r_w_t- r_x', 'G_N_o_a_m=g_x- g_w_t','C_T_t'  } )
        plot([sizepozos+.5 sizepozos+.5], [max(x), min(x)],'--k')
        plot([2*sizepozos+.5 2*sizepozos+.5], [max(x), min(x)],'--k')
        plot([3*sizepozos+.5 3*sizepozos+.5], [max(x), min(x)],'--k')
        ylim([min(x)-.02, max(x)+.25])
        
        subplot(2,2,4)
        hold on
        plot( tosave1, tosave2,'o','color', col)
        [r p]=corrcoef(tosave1, tosave2);
        StatsToShow=strcat('r=',num2str( floor(r(2)*10000)/10000 ), 'pval=',num2str(floor(p(2)*10000)/10000));
        text(tosave1,tosave2,bgdataAll(platos).Names)

        legend(StatsToShow,'Location','Best')
        xlabel('S_Noam')
        ylabel('G_Noam')
    
end