function [BgDataAll] = restarFondoFPs( BgDataAll, plts, OnlyMutStrain, OnlyRefStrain )
% [BgDataAll] = restarFondoFPs( BgDataAll, plts, OnlyMutStrain, OnlyRefStrain )

    for pl = plts
        x = robustfit (BgDataAll(pl).od(:,OnlyMutStrain), BgDataAll(pl).ref(:,OnlyMutStrain) );
        mREF= x(1);
        bREF= x(2);
        x = robustfit (BgDataAll(pl).od(:,OnlyRefStrain), BgDataAll(pl).mut(:,OnlyRefStrain) ); 
        mMUT= x(1);
        bMUT= x(2);
        
        BgDataAll(pl).mut=BgDataAll(pl).mut-(mMUT*BgDataAll(pl).od+bMUT);
        BgDataAll(pl).mut(BgDataAll(pl).mut<0)=0;
        BgDataAll(pl).ref=BgDataAll(pl).ref-(mREF*BgDataAll(pl).od+bREF);
        BgDataAll(pl).ref(BgDataAll(pl).ref<0)=0;
    end
end

