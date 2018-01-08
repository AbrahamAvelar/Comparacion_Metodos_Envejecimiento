function [TBgDataAll, ODBgDataAll NSBgDataAll] = CompareSCoeffs( BgDataAll, odTh,tfijo, ExOD, minOD, maxOD, pozos, platos, horasExponencial, figuras, toremove, previousS4, bgdataAll)
% [TBgDataAll, ODBgDataAll NSBgDataAll] = CompareSCoeffs( BgDataAll, ...
% odTh,tfijo,ExOD,minOD,maxOD,pozos,platos,horasExponencial,figuras, ...
% toremove, bgdataAll) el último es si tienes una s calculada por SEC
    
    TBgDataAll = RoCtFijo(BgDataAll,tfijo, horasExponencial, odTh, platos, pozos, figuras);
    TBgDataAll = CalcRelatSurv(TBgDataAll, platos);
    
    ODBgDataAll = RoCODFija(BgDataAll, ExOD, minOD, maxOD, platos,odTh);
    ODBgDataAll = CalcRelatSurv(ODBgDataAll, platos);

    for pl=platos;
        [MATRIZ VECTOR] = GenerateMatrizNS(ODBgDataAll, pl, pozos);
        if toremove
            [MATRIZ VECTOR]=removeWellEquations(MATRIZ, VECTOR, toremove, length(ODBgDataAll(pl).t), length(pozos) ) ;
        end
        NSBgDataAll(pl).matrix = MATRIZ;
        NSBgDataAll(pl).vector = VECTOR;
        sizepozos=length(pozos)-length(toremove);
        x = linsolve(MATRIZ, VECTOR);
        NSBgDataAll(pl).LinSoln = x;
        NSBgDataAll = figureS_NS(NSBgDataAll, x, pl, sizepozos, pozos,toremove);
    end %Este hace la parte de NS
    
    if ~previousS4 % Scatter de comparacion entre Ss
        Scatters_S(NSBgDataAll, ODBgDataAll, TBgDataAll, platos)
    else
        Scatters_S(NSBgDataAll, ODBgDataAll, TBgDataAll, platos, previousS4, bgdataAll)
    end

end