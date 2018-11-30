%======================================================================
function [data,data2]= ModelASGC(data,plt,wref, MUTFP, REFFP, medicionesminimas, ExtractExp, extraplateREFS)
%   CalculaModeloNS_ScriptEGG_DatosSECTF
%   logarithmicCocientAJG3editedWR_wo1day_data_example
%Esta funcion toma el ajuste del los backgrounds y los resta para
%primeramente calcular R/C y posteriormente hacer la interpolacion
%==========================================================
% Se itera sobre cada placa
for p = 1:length(plt);%p = 1:length(plt);
    dataplt=[];
    PL=[];
    W=[];
    timeT=[];
    timet=[];
    OD=[];
    RFP=[];
    CFP=[];
    LOGRC=[];
    OUTG=[];
    np_OUTG=[];
 
    % Obtenemos el rango para las mediciones de cada dia
    pl=data(plt(p));
    intervals=intervalCriteriaS_NS(pl.od);
    days=length(intervals)-1;%el '-1' es porque en un rato hay que recorrer intervals y se necesita 'parar a tiempo'
    %%%  Aquí no queda claro por qué decidieron que algunos días no se
    %%%  contaran 14/03/15¿8 JAAR
    
    %data along all days
    REFC=pl.ref;
    MUTC=pl.mut;
    ODall=pl.od; 
    
    %Calculamos razon logarimica  

%     % Nos quitamos de elementos cuya se?al RFP es baja
[LimiteMUT_FP  LimiteREF_FP] = FPLimits(data, MUTFP, REFFP, extraplateREFS, p);

    REFC(MUTC<LimiteMUT_FP) = NaN;%antes era <600
    MUTC(MUTC<LimiteMUT_FP) = NaN;
    REFC(REFC<LimiteREF_FP) = NaN;%antes era <500
    MUTC(REFC<LimiteREF_FP) = NaN;
    
    RoC= log(MUTC./REFC);
    RoC(MUTC<LimiteMUT_FP) = NaN;
    RoC(REFC<LimiteREF_FP) = NaN;
    %Iteramos sobre cada dia %for longevity data only
    tDays=[];
    for in = 1:(days)
      
        % Rango de mediciones para el dia
        start=intervals(in)+1;
        finish=intervals(in+1);
        
        %for longevity data, obtain time points.
        tDays = [tDays,pl.t(start)/24]; %entre 24, el tiempo viene en h
        
        for w=1:96;
            x=pl.t(start:finish);
            x=(x-min(x));
            tmpod=ODall(start:finish,w);
            y=RoC(start:finish,w);
            y2=REFC(start:finish,w);
            y3=MUTC(start:finish,w);
           
            tmpplt=ones(length(x),1).*plt(p);
            tmpw=ones(length(x),1).*w;
            tmpT=ones(length(x),1).*(tDays(in)-tDays(1));
            no_point=ones(length(x),1).*[1:length(x)]';
            nday=ones(length(x),1).*in;
            
            %Put data in vectors
            PL=[PL; tmpplt]; %3x96=288*8days*2304
            W=[W; tmpw];
            OD=[OD; tmpod];
            timeT=[timeT; tmpT];
            timet=[timet;x];
            RFP=[RFP;y3];
            CFP=[CFP;y2];
            LOGRC=[LOGRC;y];
            OUTG=[OUTG;nday];
            np_OUTG=[np_OUTG;no_point];
        end
    end
    
    %Estimate coefficientes in all one plate
%jaar    f=find(ismember(np_OUTG,[2:3])); % esto creo que es muy especifico de garay, podria ser que aqui es donde hay que dejar solo los puntos de fase exponencial
    if ExtractExp %si los datos vienen de haber extraido la fase exponencial dejando el primer punto de cada dia.
        f=find(ismember(np_OUTG,[2:max(np_OUTG)])); %aquí solo quito la primera medicion de cada dia
    else
        f=find(ismember(np_OUTG,[1:max(np_OUTG)])); %aquí dejo todas las mediciones
    end
    
    PL=PL(f); %1536x1
    W=W(f);
    OD=OD(f);
    timeT=timeT(f);
    timet=timet(f);
    RFP=RFP(f);
    CFP=CFP(f);
    LOGRC=LOGRC(f);
    OUTG=OUTG(f);
    np_OUTG=np_OUTG(f);
    
    dataplt=[PL W timeT timet LOGRC RFP CFP]; %1536*7
    
    %seleccionar mutantes con mas de 4 días de medición
    fwu=unique(W);
    remw=[];
    for tmpw=1:length(fwu);
        welli=fwu(tmpw);
        ftmp=find(ismember(W,welli));
        if sum(isnan(LOGRC(ftmp)))>medicionesminimas; %2*4dias %NUMERO Mágico! cuantos NaNs estás dispuesto a tolerar para que un pozo se siga procesando 
            remw=[remw;welli];
        end;
    end;

    tmpwell=dataplt(:,2);
    ff=find(ismember(tmpwell,remw));
    fsd=setdiff([1:length(dataplt)]',ff);
    dataplt1=dataplt(fsd,:);
    
    % seleccionar solo non is nan data
    tmplogrc=dataplt1(:,5);
    f=find(~isnan(tmplogrc));
    dataplt2=dataplt1(f,:);
%    save PL1 dataplt2
    %Falta depurar filas donde no todos los valores son NaN
    [Aplt,Splt,Gplt,Cplt,ICS,ICG,res2,wells2,days2]=LinearRegresionMatrizData(dataplt2, [wref] ); 

    data(plt(p)).A=Aplt;
    data(plt(p)).S=Splt;
    data(plt(p)).G=Gplt;
    data(plt(p)).C=Cplt;
    data(plt(p)).icS=ICS;
    data(plt(p)).icG=ICG;
    
    data2(plt(p)).res=res2;
    data2(plt(p)).w=wells2;
    data2(plt(p)).tDays=days2;
    
    plt(p)
   clear Aplt; clear Splt; clear Gplt; clear Cplt;
   clear ICS; clear ICG;

end
clear PL; clear W; clear timeT; clear timeT; clear LOGRC; clear RFP; clear CFP;
clear dataplt; clear dataplt1; clear f
end
%%
function [LimiteMUT_FP  LimiteREF_FP] =  FPLimits(data, MUTFP, REFFP, extraplate, p)
% Gets the uppest and lowest background signals from wells MUTFP and REFFP
% extraplate has the plate of ony references. If extraplate = NULL or 0,
% then it is assumed that each plate has its own background references
if extraplate
	
    LimiteMUT_FP = max( max( data(extraplate).mut(:,REFFP) )); %limit of the mutant's Fluorescence Protein
    LimiteREF_FP = max( max( data(extraplate).ref(:,MUTFP ) ));
    
else
    
    LimiteMUT_FP = max(max(data(p).mut(:,REFFP))); %limit of the mutant's Fluorescence Protein
    LimiteREF_FP = max(max(data(p).ref(:,MUTFP)));
    
end

end
