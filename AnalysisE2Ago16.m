%% GENERA BGDATA ALL SOLO CON ESTE C'ODIGO, ES LENTO PERO NO LLORA POR
%% OVERS, PLATOS INCOMPLETOS, NANS, NI OTRAS COSILLAS
cd 'JAAR E2Ago16\'
%cd 'New folder\'
archivos=dir('*.xls*');
length(archivos)
preplato=0; %esto sirve para borrar todo y volver a cargar desde el principio 
for i=1:length(archivos)
    y=tic;
    nombre=strsplit(archivos(i).name, '-');
    temp=cell2mat(nombre(1));
    plato=str2num(temp(3:end));
    x=cell2mat(nombre(2));
    diahora=datenum(strcat(x(1:2),'/',x(3:4),'/',x(5:6),'-',x(7:8),':',x(9:10),':',x(11:12) ));
% 	if preplato~=plato %como entran en orden alfabetico, esto hace que vaya creando nuevos espacios para cada plato
%          BgDataAll(plato).OD=[];
%          BgDataAll(plato).CFP=[];
%          BgDataAll(plato).RFP=[];
%          BgDataAll(plato).t=[];
%      end   

  if find(BgDataAll(plato).t==diahora)
	continue  
  else
	i/length(archivos)
    %if plato<3
	[NUM TXT RAW]=xlsread( archivos(i).name);
    od=(NUM(9:16,:));
    toc(y)
        if length(NUM)>80
            clear rfp cfp
            rfp=(NUM(42:49,:));
            cfp=(NUM(75:82,:));
        else
            clear rfp cfp
            rfp(1:96,1)=0;
            cfp(1:96,1)=0;
        end
        BgDataAll(plato).CFP=[BgDataAll(plato).CFP; cfp(:)'];
        BgDataAll(plato).RFP=[BgDataAll(plato).RFP; rfp(:)'];
    %end
	BgDataAll(plato).OD=[BgDataAll(plato).OD; od(:)'];
	BgDataAll(plato).t=[BgDataAll(plato).t diahora];
    preplato=plato;
  end

end
cd ..
save Data BgDataAll

%% ELIMINAR LAS LECTURAS QUE TENGAN CEROS (esto pasa cuando falla el robot)
CleanData=BgDataAll;
for pl=1:length(BgDataAll)
    for t=1:length(BgDataAll(pl).t)
        if length(CleanData(pl).t)>t %porque una vez que quita uno de CleanData puede regarla al final
            val=nanmean(CleanData(pl).OD(t,:));
            if val<0.001;
                CleanData(pl).OD(t,:) = [];
                CleanData(pl).t(t)    = [];
                if pl<3
                    CleanData(pl).CFP(t,:)= [];
                    CleanData(pl).RFP(t,:)= [];
                end
            end
        end
    end
end

%% %poner las horas correctamente
horasInoculos='C:\Users\JAbraham\Dropbox\PhD\Experimentos (ExMonth15)\E2Ago16 Comparacion entre metodos de longevidad 2do intento\HorasInoculosE2Ago16.xlsx';
[NUM TXT]= xlsread(horasInoculos);
odTh=.3;%cu'anto tiene que bajar la od en promedio para que sea considerado otro dia
for pl=[1:4 10:18] %ESTA PARTE ACOMODA LAS HORAS DE INOCULACION
    
    NuevosDias=EncuentraDias(CleanData(pl), odTh);
    ind=find(NUM(:,1)==pl)';
    
    y=cell2mat(TXT(ind,2));
    dias=datenum([y(:,end-1:end) y(:,3) y(:,4:6) y(:,1:2)  ]);
    diahora=dias+NUM(ind,3);
    
    CleanData(pl).t(NuevosDias)=diahora;
    
end

%% plot de todas las ODs
close all
for i=[1:4 10:18]
    figure(i+100)
    hold on
 %   plot(BgDataAll(i).t-BgDataAll(i).t(1),  BgDataAll(i).OD(:,1:2:95),'.-k')
   plot((CleanData(i).t-CleanData(i).t(1))*24, CleanData(i).OD(:,:),'o-')
   grid on
 %  xlim([0 40])
   ylim([0 .9])
end
%% PLOT FLUORESCENCIAS 96 plots por plato
%close all
for hide=1
swr1=[1 14 26 31 56 59 76]; 
msn4=[9 22 39 42 67 84 72];
ras2=[5 25 38 55 50 80 83];
ste12=[33 66 91 21 46 63];
rim15=[49 74 4 29 62 79];
tor1=[57 90 12 45 70 87];
hap3=[73 11 28 53 86 8];
rps16a=[81 19 36 69 94 24];
atg1=[2 7 35 52 77 32];
msn2=[18 15 43 62 93 48];
refs=[3 6 10 13 16 17 20 23 27 30 34 37 40 41 44 47 51 54 58 61 64 65 68 71 75 78 82 85 88 92 95];
refcfp=96;
refrfp=89;
todas=1:96;
end
%% PLOT de OD, RFP, CFP, RoC, RoC-Refs, 
pozos=refs;
titulo='refs';
for i=[1:4 10:13]
figure(i)
    hold off
    for w=pozos%1:48
%       subplot(12,4,w)
        plot((CleanData(i).t-CleanData(i).t(1))*24, log10(CleanData(i).RFP(:,w)./CleanData(i).CFP(:,w)),'o-k')
        hold on
        plot((CleanData(i).t-CleanData(i).t(1))*24, log10(CleanData(i).RFP(:,w))-3,'.-m')
        plot((CleanData(i).t-CleanData(i).t(1))*24, log10(CleanData(i).CFP(:,w))-3,'.-c')
        plot((CleanData(i).t-CleanData(i).t(1))*24, (CleanData(i).OD(:,w)),'.-g')
%        plot((CleanData(i).t-CleanData(i).t(1))*24,
%        CleanData(i).RFP(:,w),'.-r')
        grid on
    end
    plot((CleanData(i).t-CleanData(i).t(1))*24, log10(CleanData(i).RFP(:,refs)./CleanData(i).CFP(:,refs)),'--r')
	title(titulo)
    ylabel('rfp/cfp')
      % ylim([-2 2])
  % xlim([0 40])
end

%%%% CODIGO FLUORESCENCIAS
%%%% QUE INCORPORE NUEVAS LECTURAS RAPIDO
%% PLOT FLUORESCENCIAS 2 plots por plato
close all
for i=[1:8 10:18]
    figure(i)
    hold on
    subplot(1,2,1)
   plot((CleanData(i).t-CleanData(i).t(1))*24, CleanData(i).CFP(:,:),'o-c')
   subplot(1,2,2)
   plot((CleanData(i).t-CleanData(i).t(1))*24, CleanData(i).RFP(:,:),'o-r')

   grid on
%   xlim([0 15])
%   ylim([0 .7])
end

%% PLOT de OD vs Fluorescencias
pozos=msn2;
titulo='msn2';
for i=[1:4 10:13]
    figure(200+i)
    hold off
    for w=pozos %1:48
%       subplot(12,4,w)
        plot(CleanData(i).OD(:,w), log10(CleanData(i).CFP(:,w)),'o-c');
        hold on
        plot(CleanData(i).OD(:,w), log10(CleanData(i).RFP(:,w)),'o-r')
        grid on
    end
    %plot((CleanData(i).t-CleanData(i).t(1))*24, log10(CleanData(i).RFP(:,refs)./CleanData(i).CFP(:,refs)),'--r')
	title(titulo)
    ylabel('cfp|rfp')
    xlabel('OD')
  % ylim([-2 2])
  % xlim([0 40])
end

%% DECAY FROM SERGIO's MASTER


pls=[1:4 10:18]; %number of plates
od = .28; % od at interpolation ORIGINAL .28
odTh = -0.3; %ORIGINAL -0.3
n0 = .22; % minimum OD for GR ORIGINAL .18
nt = .45; % Max OD for GR ORIGINAL .48
% 3. Bkg medium substraction
value = .07;
for i=1:18
    value = min([min(CleanData(i).OD) value]);
end


bgdataClean = bkgsubstractionOD(CleanData,value);% Generate new matrix bgdataAll.OD
[timeOD] = getimeAA(bgdataClean,pls,od,odTh);  %Gets matrix with time at od stated above for each well and plate
[gwrate] = getgr(bgdataClean,pls,n0,nt,odTh); %Gets growth rate matrix
%%
[survival] = getsurv(timeOD,gwrate,pls); %Gets survival percentage matrix
survival = getxvec(bgdataClean,survival,pls,od,odTh); %Gets matrix into survival structure for time at which interpolation was made in days and plots percentage vs time
%%
[decayRate] = getExponentialRate(survival);
%save survival survival   
% Curvas decaimento Survival pls 3:7

%% plot Growth rates
%close all
for hide=1
muts.swr1=[1 14 26 31 56 59 76]; 
muts.msn4=[9 22 39 42 67 84 72];
muts.ras2=[5 25 38 55 50 80 83];
muts.ste12=[33 66 91 21 46 63];
muts.rim15=[49 74 4 29 62 79];
muts.tor1=[57 90 12 45 70 87];
muts.hap3=[73 11 28 53 86 8];
muts.rps16a=[81 19 36 69 94 24];
muts.atg1=[2 7 35 52 77 32];
muts.msn2=[18 15 43 62 93 48];
muts.refs=[3 6 10 13 16 17 20 23 27 30 34 37 40 41 44 47 51 54 58 61 64 65 68 71 75 78 82 85 88 92 95];
muts.cenrefs=[10 13 20 23 27 30 34 37 44 47 51 54 58 61 68 71 75 78 82 85 ];
end
names=fieldnames(muts);

for i=1:length(names)
mut=muts.(cell2mat(names(i)));
titulo=names(i);
figure(i+100)
%clf
con=0;
for pl=[14:17]
  con=con+1;
  subplot(2,2,con)
  hold on
    NuevosDias=EncuentraDias(CleanData(pl), .3);
	plot(BgDataAll(pl).t(NuevosDias)-BgDataAll(pl).t(1), gwrate(pl).T(:,refs),'.--m')            
    hold on
	plot(BgDataAll(pl).t(NuevosDias)-BgDataAll(pl).t(1), gwrate(pl).T(:,mut),'o--c')
    ylim([0.1 .25])
    title( strcat(num2str(pl), '-', titulo ) )
    grid on
end 
end



%% plot Survival curves
%close all
for hide=1
muts.swr1=[1 14 26 31 56 59 76]; 
muts.msn4=[9 22 39 42 67 84 72];
muts.ras2=[5 25 38 55 50 80 83];
muts.ste12=[33 66 91 21 46 63];
muts.rim15=[49 74 4 29 62 79];
muts.tor1=[57 90 12 45 70 87];
muts.hap3=[73 11 28 53 86 8];
muts.rps16a=[81 19 36 69 94 24];
muts.atg1=[2 7 35 52 77 32];
muts.msn2=[18 15 43 60 93 48];
muts.refs=[3 6 10 13 16 17 20 23 27 30 34 37 40 41 44 47 51 54 58 61 64 65 68 71 75 78 82 85 88 92 95];
muts.cenrefs=[10 13 20 23 27 30 34 37 44 47 51 54 58 61 68 71 75 78 82 85 ];
end
names=fieldnames(muts);
for i=1:length(names)
mut=muts.(cell2mat(names(i)));
titulo=names(i);
figure(i+100)
clf
con=0;
for pl=[14:17]
    %figure(100+pl)
    %clf
  con=con+1;
  subplot(2,2,con)
    NuevosDias=EncuentraDias(CleanData(pl), .3);
    %for well=swr1
        %plot(survival(pl).s(:,well+1),'o-r')
        plot(BgDataAll(pl).t(NuevosDias)-BgDataAll(pl).t(1), survival(pl).s(:,mut),'o-k')
        hold on
        plot(BgDataAll(pl).t(NuevosDias)-BgDataAll(pl).t(1), survival(pl).s(:,refs),'.--r')
        ylim([0 110])
        title(titulo)
        grid on
    %end
end %8x12 curvas de decaimiento

end

%%  SURVIVAL CURVES, MEDIA Y ERROR

for i=1:length(names)
mut=muts.(cell2mat(names(i)));
titulo=names(i);
figure(i+100)
clf
hold on    
con=0;
for pl=[14:17]
    %for well=swr1
        con=con+1;
        subplot(2,2,con)
        %plot(survival(pl).s(:,well+1),'o-r')
        stderror=nanstd(survival(pl).s(:,mut)')./sqrt(length(survival(pl).s(:,mut)'));
        meansurv=nanmean(survival(pl).s(:,mut)');
        NuevosDias=EncuentraDias(CleanData(pl), .3);
        x=CleanData(pl).t(NuevosDias)-CleanData(pl).t(1);
        PlotConError(x,meansurv, meansurv+stderror,meansurv-stderror,'k')
        hold on
        stderror=nanstd(survival(pl).s(:,refs)')./sqrt(length(survival(pl).s(:,refs)'));
        meansurv=nanmean(survival(pl).s(:,refs)');
        PlotConError(x,meansurv, meansurv+stderror,meansurv-stderror,'r')
        ylim([0 110])
        %xlim([0 15])
        title(titulo)
        grid on
    %end
end %8x12 curvas de decaimiento

end

%%  SURVIVAL CURVES, MEDIA Y ERROR por plato

for pl=17 %i=1:length(names)
    figure(i+100)
    clf
    hold on    
    con=0;
    for i=1:length(names) %pl=14%[14:17]
        mut=muts.(cell2mat(names(i)));
        titulo=strcat('PL:', num2str(pl), '-', names(i));
        con=con+1;
        subplot(4,3,con)
        stderror=nanstd(survival(pl).s(:,mut)')./sqrt(length(survival(pl).s(:,mut)'));
        meansurv=nanmean(survival(pl).s(:,mut)');
        NuevosDias=EncuentraDias(CleanData(pl), .3);
        x=CleanData(pl).t(NuevosDias)-CleanData(pl).t(1);
        PlotConError(x,meansurv, meansurv+stderror,meansurv-stderror,'k')
        %set(gca,'Color', [.5 .5 .5])
        hold on
        stderror=nanstd(survival(pl).s(:,refs)')./sqrt(length(survival(pl).s(:,refs)'));
        meansurv=nanmean(survival(pl).s(:,refs)');
        PlotConError(x,meansurv, meansurv+stderror,meansurv-stderror,'r')
        ylim([0 110])
        %xlim([0 15])
        title(titulo)
        grid on
    end %8x12 curvas de decaimiento
end

%% RFP/CFP.. SE GENERA CleanData.RoC 
odTh=.3;
ExOD=.35; %OD de extrapolacion
minOD=.25;
maxOD=.55;
%rmfield(CleanData, {'RoC','s'})
for pl=[1:4 10:13]
    NuevosDias=EncuentraDias(CleanData(pl), odTh);
    NuevosDias=[NuevosDias length(CleanData(pl).t) ];
    for Dia=1:length(NuevosDias)-1
        for w=1:96
            ods=CleanData(pl).OD(NuevosDias(Dia):NuevosDias(Dia+1)-1,w);
            cfps=log10(CleanData(pl).CFP(NuevosDias(Dia):NuevosDias(Dia+1)-1,w));
            cfps(isinf(cfps))=NaN;
            rfps=log10(CleanData(pl).RFP(NuevosDias(Dia):NuevosDias(Dia+1)-1,w));
            rfps(isinf(rfps))=NaN;
            validas=find(ods>minOD & ods<maxOD);
%             colo=[0+1/Dia*(1/15) .3 (Dia)*(1/15)];
%             figure(w)
%             hold on
%             Figuritas(ods, cfps, rfps,validas,w, colo)
%             pause            
            if sum(~isnan(cfps(validas)))>2 && sum(~isnan(rfps(validas))) >2
                m=robustfit(ods(validas), rfps(validas)./cfps(validas) );
                RedOverCyan=(m(2)*ExOD)+m(1);
                CleanData(pl).RoC(Dia,w)=RedOverCyan;
            else
                CleanData(pl).RoC(Dia,w)=NaN;
            end
        end
    end
end
%% RFP/CFP a TIEMPO FIJOO.. SE GENERA CleanData.RoCt 
odTh=.3;
%horaInt =[12 17];
%ExT=15;
horaInt=[6 10];
ExT=7.5; %para pls 1:4 es diferente por la dilucion %Tiempo, en horas de interpolacion
%rmfield(CleanData, {'RoC','s'})
for pl=[10:13]
    NuevosDias=EncuentraDias(CleanData(pl), odTh);
    NuevosDias=[NuevosDias length(CleanData(pl).t) ];
    for Dia=1:length(NuevosDias)-1
        for w=1:96
            
            tiempos=24*(CleanData(pl).t(NuevosDias(Dia):NuevosDias(Dia+1)-1)-CleanData(pl).t(NuevosDias(Dia)));            
            cfps=log10(CleanData(pl).CFP(NuevosDias(Dia):NuevosDias(Dia+1)-1,w));
            cfps(isinf(cfps))=NaN;
            rfps=log10(CleanData(pl).RFP(NuevosDias(Dia):NuevosDias(Dia+1)-1,w));
            rfps(isinf(rfps))=NaN;
            validas=find(tiempos>horaInt(1) & tiempos<horaInt(2));

            if sum(~isnan(cfps(validas)))>2 && sum(~isnan(rfps(validas))) >2
                m=robustfit(tiempos(validas), rfps(validas)./cfps(validas) );
                RedOverCyan=(m(2)*ExT)+m(1);
                CleanData(pl).RoCt(Dia,w)=RedOverCyan;
            elseif sum(~isnan(cfps(validas)))>2 && sum(~isnan(rfps(validas))) >1
                RedOverCyan=interp1(tiempos(validas), rfps(validas)./cfps(validas), ExT );
                CleanData(pl).RoCt(Dia,w)=RedOverCyan;
            else
                CleanData(pl).RoCt(Dia,w)=NaN;
            end
            
        end
    end
end

%% HAY QUE PONER UN UMBRAL MINIMO Y MAXIMO DE RoC, PARA ESO VAMOS A USAR
% TANTO LAS REFERENCIAS COMO LOS POZOS VACIOS
%% CUALES SON LOS HUMBRALES DE ROC y genera RoC2
close all
minthreshold=[];
maxthreshold=[];
for pl=[1:4 10:13]
    maxthreshold = min([CleanData(pl).RoC(:,89)' maxthreshold ]);
	minthreshold = max([CleanData(pl).RoC(:,96)' minthreshold ]);
end
maxthreshold=1.4; %lo puse de acuerdo a lo que se ve en las gr'aficas.
close all
for pl=[1:4 10:13]
    figure(pl)
    index=find(CleanData(pl).RoC<minthreshold);
    CleanData(pl).RoC2=CleanData(pl).RoC;
    CleanData(pl).RoC2(index)=NaN;
    plot(CleanData(pl).RoC(:,89),'o-r')
    hold on
    plot(CleanData(pl).RoC(:,:),'.-k')
    plot(CleanData(pl).RoC(:,96),'o-b') 
    
    plot(CleanData(pl).RoC2(:,:),'.--g')
    plot(CleanData(pl).RoC2(:,89),'--m')
    plot(CleanData(pl).RoC2(:,96),'--c') 

end

%% plot de los 96 pozos con su m %%%%AQUI SE GENERÓ .s y .s2%%%%%

for pl=[1:4 10:13]
    figure(pl)
    clf
for i=1:96
    subplot(12,8,i)
    NuevosDias=EncuentraDias(CleanData(pl), .3);
    ejex=CleanData(pl).t(NuevosDias)-CleanData(pl).t(1);
    if length(find(~isnan(CleanData(pl).RoCt(:,i) ) ))>2
        
        m=robustfit(ejex,CleanData(pl).RoCt(:,i));
        CleanData(pl).st(i,:)=m;
        plot(ejex,CleanData(pl).RoCt(:,i),'ok' )
        hold on
        plot([0 20], [m(1) m(2)*18+m(1)],'r' )
        ylim([.5 1.6])
        xlim([-1 16])
        text(6,1.4,num2str( floor(m(2)*10000)/10000 ))
    else
        CleanData(pl).st(i,:)=[NaN NaN];
    end
    
end
end
%% CDFPlot de los 9 platos con competencia en fluorimetria
close all
for i=1:length(names)
mut=muts.(cell2mat(names(i)));
titulo=names(i);
figure(500+i)
clf
hold on    
con=0;
for pl=[1:4 10:13]
    con=con+1;
    subplot(2,4,con)
    cdfplotAA(CleanData(pl).s(mut,2),'k')
    hold on
    cdfplotAA(CleanData(pl).s(refs,2),'r')
    
    %cdfplotAA(CleanData(pl).st(mut,2),'c')
    %cdfplotAA(CleanData(pl).st(refs,2),'m')
    
    title(strcat('pl',num2str(pl), '-', titulo ) )
    xlim([-.06 .06])
    
end %8x12 curvas de decaimiento
legend('mutante','referencia')
end

%%  POR OD Y POR FLUORIMETRIA JUNTAS cdfplots .s y .s2
%close all
cenrefs=[10 13 20 23 27 30 34 37 44 47 51 54 58 61 68 71 75 78 82 85];
for i=1:length(names)
mut=muts.(cell2mat(names(i)));
titulo=names(i);
figure(500+i);
clf
hold on
con=0;
for pl=[1:4 10:17 ]
    if pl<14
        con=con+1;
        subplot(3,4,con)
        cdfplotAA(CleanData(pl).s(mut,2),'b')
        hold on
        cdfplotAA(CleanData(pl).s(refs,2),'r')
        if ~isempty(find(~isnan(CleanData(pl).st(mut,2))))
            cdfplotAA2(CleanData(pl).st(mut,2),'k')
            cdfplotAA2(CleanData(pl).st(refs,2),'m')
        end
        title(strcat(titulo, '-PL' ,num2str(pl)))
        xlim([-.03 .03])
    end
    if pl>13
        con=con+1;
        subplot(3,4,con)
        stderror=nanstd(survival(pl).s(:,mut)')./sqrt(length(survival(pl).s(:,mut)'));
        meansurv=nanmean(survival(pl).s(:,mut)');
        NuevosDias=EncuentraDias(CleanData(pl), .3);
        x=CleanData(pl).t(NuevosDias)-CleanData(pl).t(1);
        PlotConError(x,meansurv, meansurv+stderror,meansurv-stderror,'b')
        hold on
        stderror=nanstd(survival(pl).s(:,refs)')./sqrt(length(survival(pl).s(:,refs)'));
        meansurv=nanmean(survival(pl).s(:,refs)');
        PlotConError(x,meansurv, meansurv+stderror,meansurv-stderror,'r')
        ylim([0 110])
        %xlim([0 15])
        title(strcat(titulo, '-PL' ,num2str(pl)))
        grid on
    end
end %8x12 curvas de decaimiento
legend('mutante','referencia')
end


%%
%CÓMO CAMBIA LA S CUANDO TOMO DIFERENTES DÍAS. ESTO ME PODRÍA AYUDAR A
%HACER ALGO COMO LO QUE DICE CEI DE IR DESDE LAS MEDICIONES DE
%FLUORESCENCIAS HACIA LAS TASAS DE DECAIMIENTO?
%% Ver como va cambiando la s conforme avanzan los dias del dia 3 al dia N

for hide=1
muts.swr1=[1 14 26 31 56 59 76]; 
muts.msn4=[9 22 39 42 67 84 72];
muts.ras2=[5 25 38 55 50 80 83];
muts.ste12=[33 66 91 21 46 63];
muts.rim15=[49 74 4 29 62 79];
muts.tor1=[57 90 12 45 70 87];
muts.hap3=[73 11 28 53 86 8];
muts.rps16a=[81 19 36 69 94 24];
muts.atg1=[2 7 35 52 77 32];
muts.msn2=[18 15 43 60 93 48];
muts.refs=[3 6 10 13 16 17 20 23 27 30 34 37 40 41 44 47 51 54 58 61 64 65 68 71 75 78 82 85 88 92 95];
muts.cenrefs=[10 13 20 23 27 30 34 37 44 47 51 54 58 61 68 71 75 78 82 85 ];
end
close all
names=fieldnames(muts);
for pl=11%[1:4 10:13]
    %figure(pl)
    %clf  
	for j=1:length(names)-2
    mut=muts.(cell2mat(names(j)));
    con=0;
    figure(j+100)
    %clf
    for i=mut
        con=con+1;
        subplot(2,4,con)
        hold on
        NuevosDias=EncuentraDias(CleanData(pl), .3);
        %clf
    
        for lim=3:length(NuevosDias)
            ejex=CleanData(pl).t(NuevosDias(1:lim))-CleanData(pl).t(1);
            if length(find(~isnan(CleanData(pl).RoC(1:lim,i))))>2
                m=robustfit(ejex,CleanData(pl).RoC(1:lim,i));
                CleanData(pl).sSlide(i,lim-2)=m(2);
                plot(ejex,CleanData(pl).RoC(1:lim,i),'ob' );
                hold on
                p=plot([0 20], [m(1) m(2)*18+m(1)],'r' );
                set(p,'Color',[0 1 lim/length(NuevosDias)] )
                ylim([.9 1.1])
%                text(6,lim/length(NuevosDias),num2str( floor(m(2)*10000)/10000 ) )
            end
            
            if length(find(~isnan(CleanData(pl).RoC2(1:lim,i))))>2
                m=robustfit(ejex,CleanData(pl).RoC2(1:lim,i));
                CleanData(pl).sSlide2(i,lim-2)=m(2);
                plot(ejex,CleanData(pl).RoC2(1:lim,i),'*c' );
                hold on
                p=plot([0 20], [m(1) m(2)*18+m(1)],'--m' );
                %set(p,'Color',[0 1 lim/length(NuevosDias)] )
                ylim([.9 1.1])
                xlim([-1 17])
             %   text(6,lim/length(NuevosDias),num2str( floor(m(2)*10000)/10000 ) )
            end
	title(strcat('PL:', num2str(pl),'-', names(j), '-well-',num2str(i) ))

            
        end
    end
    end
end

%% Ver como va cambiando la s conforme avanzan los dias del dia N-3 al dia N

close all
names=fieldnames(muts);
for pl=10:13%[1:4 10:13]
    for j=1:length(names)-2
    mut=muts.(cell2mat(names(j)));
    con=0;
    figure(j)
    %clf
    for i=mut
        title(names(j))
        con=con+1;
        subplot(2,4,con)
        NuevosDias=EncuentraDias(CleanData(pl), .3);
        %clf
    
        for lim=3:length(NuevosDias)
            ejex=BgDataAll(pl).t(NuevosDias(lim-2:lim))-BgDataAll(pl).t(1);
            if length(find(~isnan(CleanData(pl).RoC(lim-2:lim,i))))>2
                m=robustfit(ejex,CleanData(pl).RoC(lim-2:lim,i));
                CleanData(pl).sSlide3point(i,lim-2)=m(2);
                plot(ejex,CleanData(pl).RoC(lim-2:lim,i),'ok' );
                hold on
                p=plot([0 20], [m(1) m(2)*18+m(1)],'r' );
                set(p,'Color',[mod(pl,2) 1-mod(pl,2) lim/length(NuevosDias)] )
                ylim([.5 1.6])
                xlim([-1 17])
                %text(6,lim/length(NuevosDias),num2str( floor(m(2)*10000)/10000 ) )
            end
        end
    end
    end
end

%% Plots de correlacion de todas las S, un plato a a vez mutante por mutante
platosComp=[10 12 1:4 10:13];
con=0;
figure(123); clf;
for pl=1:length(platosComp)
    for pl2=1+pl:length(platosComp)
        for j=1:length(names)
        mut=muts.(cell2mat(names(j)));
        con=con+1;
%        subplot(8,8,con)
        clf
        p=plot(CleanData(platosComp(pl)).s(:,2), CleanData(platosComp(pl2)).s(:,2),'ok','MarkerSize',5);
        hold on
        p=plot(CleanData(platosComp(pl)).s(mut,2), CleanData(platosComp(pl2)).s(mut,2),'ob','MarkerSize',5);
        p=plot(CleanData(platosComp(pl)).s(refs,2), CleanData(platosComp(pl2)).s(refs,2),'or','MarkerSize',5);
        [r,p]=corrcoef(CleanData(platosComp(pl)).s(:,2), CleanData(platosComp(pl2)).s(:,2));
        ylim([-.03 .02])
        xlim([-.03 .02])
        axis square
        grid on
        %if pl==1
        %title(platosComp(pl2))
        title(names(j))
        %end
        %if pl2==1
        ylabel(platosComp(pl2))
        xlabel(platosComp(pl))
        %end
        text(-.02,.015, num2str( floor(r(2)*10000)/10000 ))
        text(-.02,-.025, num2str( floor(p(2)*10000)/10000 ))
        grid off
        pause
        end
    end
end

%Por qué pasa que no hay correlacion entre los 2 platos que se están
%agitando?
%% Plots de correlacion de todos los platos de S
platosComp=[1:4 10:13];
con=0;
figure(123)
clf
for pl=1:length(platosComp)
    for pl2=1:length(platosComp)
        con=con+1;
        subplot(8,8,con)
        p=plot(CleanData(platosComp(pl)).s(:,2), CleanData(platosComp(pl2)).s(:,2),'or','MarkerSize',3);
        indices = intersect(find(~isnan(CleanData(platosComp(pl)).s(:,2))),find(~isnan(CleanData(platosComp(pl2)).s(:,2))));
        [r,p]=corrcoef(CleanData(platosComp(pl)).s(indices,2), CleanData(platosComp(pl2)).s(indices,2));
        if r(2) > 0.5
            set(gca,'Color', [.8, .6, 1-abs(r(2))])
        elseif r(2) < -.5
            set(gca,'Color', [.2, .6, 1-abs(r(2))])
        end
        ylim([-.05 .04])
        xlim([-.05 .04])
       %ylabel(platosComp(pl2))
       %xlabel(platosComp(pl))
        axis square
        grid on
        if pl==1
        title(platosComp(pl2))
        end
        if pl2==1
        ylabel(platosComp(pl))
        end
        text(-.04,.03, strcat ('r=', num2str(floor(r(2)*10000)/10000) ))
        text(-.04,-.04, strcat ('p=', num2str(floor(p(2)*10000)/10000) ))
        set(gca,'xtick',[],'ytick',[])
    end
    %con=con+pl;
end

figure(124)
clf
con=0;
for pl=1:length(platosComp)
    for pl2=1:length(platosComp)
        con=con+1;
        subplot(8,8,con)
        p=plot(CleanData(platosComp(pl)).st(:,2), CleanData(platosComp(pl2)).st(:,2),'or','MarkerSize',1);
        indices = intersect(find(~isnan(CleanData(platosComp(pl)).st(:,2))),find(~isnan(CleanData(platosComp(pl2)).st(:,2))));
        [r,p]=corrcoef(CleanData(platosComp(pl)).st(indices,2), CleanData(platosComp(pl2)).st(indices,2));
        if r(2) > 0.5
            set(gca,'Color', [.8, .6, 1-abs(r(2))])
        elseif r(2) < -.5
            set(gca,'Color', [.2, .6, 1-abs(r(2))])
        end
        ylim([-.05 .04])
        
        xlim([-.05 .04])
        %set(gca,'XTick','')
        axis square
        grid on
        if pl==1
        title(strcat('st, PL:', num2str(platosComp(pl2))) )
        end
        if pl2==1
        ylabel(platosComp(pl))
        end
        text(-.04,.03, num2str(floor(r(2)*1000)/1000))
        text(-.04,-.04, num2str(floor(p(2)*1000)/1000))
        set(gca,'xtick',[],'ytick',[])
    end
    %con=con+pl;
end


%%
% %%%REVISAR POZO POR POZO SI ES QUE HUBIERA ALGO RARO
% -CONTAMINACION EN LAS PLACAS
% -LOS OUTLIERS
% -POR QUÉ ESTÁ TAN RARO EL RAS2 DE 1 PLATO Y EL RIM15 DE UN TIEMPO??
%VER PL185R
%Qu'e con hap3 en competencia, se ve bien que es super aceleradora de
%envejecimiento?
%%
%%%%%%%%%%  CITOMETRIA %%%%%%%%%%%%%%%
%%  ANALISIS DE LOS DATOS DEL CITOMETRO DEL EXCEL
%%%%    CARGA LOS DATOS   %%%%%
archivo='E2Ago16_Cit.xlsx';
[NUM TXT RAW]=xlsread(archivo);
P3=xlsread(archivo,'I2:I9889'); %AZULES
P4=xlsread(archivo,'K2:K9889'); %ROJAS
P5=xlsread(archivo,'M2:M9889'); %SIN COLOR
P6=xlsread(archivo,'O2:O9889'); %DOUBLETS
%
% Going from slopes (S) to relative survival (little_s) and implications on epistasis analysis
% Conclusion: -ln(1-S/ro)
%% Los guarda en la estructura Data(plato).GATE
clear Data
con=[0 0 0 0];
for i=1:length(P3) 
    x=str2mat(TXT(i+1,1));%porque el txt tiene encabezados.
    plato=str2num(x(end));%solo funciona si los PL son menores a 10
    if con(plato)==0;
        Data(plato).P3=[];
        Data(plato).P4=[]; 
        Data(plato).P5=[]; 
        Data(plato).P6=[];
        Data(plato).nombre=[];
        Data(plato).Pozonombre=[];
        Data(plato).PozoNum=[];
        pozoanterior=[];
    end
    if plato
        con(plato)=con(plato)+1;
        Data(plato).P3=[Data(plato).P3 P3(i)];
        Data(plato).P4=[Data(plato).P4 P4(i)]; 
        Data(plato).P5=[Data(plato).P5 P5(i)]; 
        Data(plato).P6=[Data(plato).P6 P6(i)];
        Data(plato).nombre=[Data(plato).nombre TXT(i+1,1)];
        Data(plato).Pozonombre=[Data(plato).Pozonombre TXT(i+1,2) ];
        pozo=str2mat(TXT(i+1,2));
%         if strcmp(pozoanterior, 'H12') && ~strcmp(pozo, 'A1') esto es  porque habia una incosistencia en el numero de platos
%             x
%             pause
%         end
%         pozoanterior=pozo;
        Data(plato).PozoNum=[ Data(plato).PozoNum str2num(pozo(2:end))] ;
        
    end
end

Data= rmfield(Data, 'PozoNum')
Data= rmfield(Data, 'Pozonombre')
%%
%% los acomoda de 96 en 96 para separar cada medicion
for pl=1:4
    con=0;
    for i=1:96:length(Data(pl).P3)-1
        con=con+1;
        Data(pl).fixP3(con,1:96) = Data(pl).P3(i:i+95);
        Data(pl).fixP4(con,1:96) = Data(pl).P4(i:i+95);
        Data(pl).fixP5(con,1:96) = Data(pl).P5(i:i+95);
        Data(pl).fixP6(con,1:96) = Data(pl).P6(i:i+95);
        Data(pl).Dias(con)=Data(pl).nombre(i);
        
    end
end

%% Calcula el cociente Rojo sobre Cyan RoC.

for plato=1:4
    Data(plato).RoC = Data(plato).fixP4 ./ Data(plato).fixP3;
end


%% Acomoda las horas de acuerdo a la inoculaci'oon Genera Data(pl).hora con
horasInoculos='C:\Users\JAbraham\Dropbox\PhD\Experimentos (ExMonth15)\E2Ago16 Comparacion entre metodos de longevidad 2do intento\HorasInoculosE2Ago16.xlsx';
[NUM TXT]= xlsread(horasInoculos);
for pl=1:4 %ESTA PARTE ACOMODA LAS HORAS DE INOCULACION
    NuevosDias=1:3:26 ;
    ind=find(NUM(:,1)==pl)';
    y=cell2mat(TXT(ind,2));
    dias=datenum([y(:,end-1:end) y(:,3) y(:,4:6) y(:,1:2)  ]);
    diahora=dias+NUM(ind,3);
    con=0;
    
    for i=NuevosDias
        if i<25
        con=con+1;
        x=str2mat(Data(pl).Dias(i:i+2));
        diahoraPlato=datenum(strcat(x(:,5:6),'/',x(:,1:2),'/',x(:,3:4), x(:,7:9),':',x(:,10:11)));
        smallt=diahoraPlato-diahora(con);
        Data(pl).hora(i:i+2)=smallt;
        else
            con=con+1;
            x=str2mat(Data(pl).Dias(i:end));
            diahoraPlato=datenum(strcat(x(:,5:6),'/',x(:,1:2),'/',x(:,3:4), x(:,7:9),':',x(:,10:11)));
            smallt=diahoraPlato-diahora(con);
            Data(pl).hora(i:i+length(smallt)-1 )=smallt;
        end
    end
    
end

%%
for i=1:4
Data(i).CFP=Data(i).fixP3
Data(i).RFP=Data(i).fixP4
Data(i).SINCOLOR=Data(i).fixP5
Data(i).DOUBLETS=Data(i).fixP6
end
%%  Interpolacion de ROC a distintas horas Genera Data.RoC y Data.s
IntTime=15;
cienes(1:3,1:96)=100;
for pl=1:4;
    con=0;
    NuevosDias=1:3:24 ;
for i=NuevosDias
    %temp=Data(pl).RFP(i:i+2,:)./(cienes-Data(pl).RFP(i:i+2,:))
    temp=(Data(pl).RFP(i:i+2,:)./Data(pl).CFP(i:i+2,:));
    temp(isinf(temp))= NaN;%max(x(~isinf(temp(:))))+1;
    Data(pl).RoC(i:i+2,:) = temp ;
    y=Data(pl).RoC(i:i+2,:);
    x=Data(pl).hora(i:i+2)'*24;
    con=con+1;
    %figure(pl)
    for j=1:length(y)
        if length(find(~isnan(y(:,j)))) > 2
            m=robustfit(x,y(:,j));
            %subplot(8,12,j)
            %plot(x,y(:,j),'o');
            %hold on
            %plot([5 9 12], m(2)*[5 9 12]+m(1),'r' )
            RedOverCyan=m(2)*IntTime+m(1);
            Data(pl).IntRoC(con,j)=RedOverCyan;
        end
        %pause
    end
end
end
%%  PLOT DE LOS 96 POZOS, LA RoC Y LA S interpolada
%ejex=[1 2 3 5 7 9 11 14];
%%%%%%%%%%%%%%%% FALTA HACER QUE EL DIA QUE PUSE MAL LAS LECTURAS SE
%%%%%%%%%%%%%%%% ACOMODE BIEN LA HORA %%%%%%%%%%%%%%%%%%ya qued'o
for pl=1:4
    Data(pl).s=[];
    figure(pl)
    NuevosDias=EncuentraDias(CleanData(pl), .3);
    for w=1:96
        y=Data(pl).IntRoC(:,w);
        ejex=CleanData(pl).t(NuevosDias(1:8))-CleanData(pl).t(1);
        x=ejex;
        m=robustfit(x,y);
        Data(pl).s(w,:)=m;
        subplot(8,12,w)
        plot(x,y,'or')
        hold on
        plot(ejex, m(2)*ejex+m(1),'b')
        title( num2str(floor(m(2)*10000)/10000))
        %ylim([-10 10])
        ylim([-.3 1])
        xlim([0 15])
    end
end

%%
for hide=1

mutsC.swr1=[1 16 32 46 62 76 91];
mutsC.msn4=[2 18 33 47 63 77 93];
mutsC.ras2=[4 19 35 49 65 79 94];
mutsC.ste12=[5 21 36 51 66 80];
mutsC.rim15=[7 22 37 52 68 82];
mutsC.tor1=[8 24 38 54 69 83];
mutsC.hap3=[10 26 40 55 71 85];
mutsC.rps16a=[11 27 41 57 72 87];
mutsC.atg1=[13 29 43 58 73 88];
mutsC.msn2=[15 30 44 60 74 90];
mutsC.refs= [3 6 9 14 17 20 23 25 28 31 34 39 42 45 48 50 53 56 59 61 64 67 70 75 78 81 84 86 89 92 95];
mutsC.cenrefs = [ 14 17 20 23  28 31 34 39 42 45 50 53 56 59 64 67 70 75 78 81];
%mutsC.RFPsola=[12];
%mutsC.CFPsola=[96];
namesC=fieldnames(mutsC)
end

%% CDFPlot de los 8 platos con competencia en citometria y fluorescencia
%Data.s, CleanData.s y CleanData.st

%cdfplots_SurvMuts(data,pls,muts,refs,colmut, colref, sizey, sizex, lims)
pls=[1:4 10:13];
cdfplots_SurvMuts(CleanData, 's', pls, muts, muts.refs, 'k', 'r',5,4, .03,'s,Fluo',0 )
cdfplots_SurvMuts(CleanData,'st', [1:4 10:13], muts, muts.cenrefs, 'k', 'r',5,4,.03, 'st,Flu',8)
pls=[1:4];
cdfplots_SurvMuts(Data,'s', pls, mutsC, mutsC.cenrefs, 'k', 'r',5,4,.1, 's,Cit',16)
%%
cdfplots_SurvMuts(CleanData, 's', [2 4 11 13], muts, muts.refs, 'k', 'r',2,2, .03,'s,Fluo',0 )

%%  CDFPLOTS CITOMETRIA Y FLUORIMETRIA JUNTOS XXXX

for i=1:length(names)
    mutF=muts.(cell2mat(names(i)));
    mutC=mutsC.(cell2mat(names(i)));
    refF=muts.refs;
    refC=mutsC.refs;
    titulo=names(i);
    figure(i+100)
    clf
    con=0;
for pl=[1 3 2 4]
    con=con+1;
    subplot(2,4,con)
    [h p]=kstest2(Data(pl).s(mutC,2)-nanmedian(Data(pl).s(refC,2)),Data(pl).s(refC,2)-nanmedian(Data(pl).s(refC,2)) );
    cdfplotAA(Data(pl).s(mutC,2)-nanmedian(Data(pl).s(refC,2)) ,'k')
    hold on
    cdfplotAA(Data(pl).s(refC,2)-nanmedian(Data(pl).s(refC,2)),'r')
    title(strcat('PL:', num2str(pl), ' Cit-', titulo))
    text(0, .2, strcat('KS p=', num2str((floor(p*100000))/100000)))
	[h p]=ranksum(Data(pl).s(mutC,2)-nanmedian(Data(pl).s(refC,2)),Data(pl).s(refC,2)-nanmedian(Data(pl).s(refC,2)) );
    text(0, .1, strcat('W p=', num2str((floor(h*100000))/100000)))
    xlim([-.08 .08])
    grid off
    pl=pl+9;
    subplot(2,4,con+4)
    [h p]=kstest2(CleanData(pl).s(mutF,2)-nanmedian(CleanData(pl).s(refF,2)), CleanData(pl).s(refF,2)-nanmedian(CleanData(pl).s(refF,2)) );
    cdfplotAA(CleanData(pl).s(mutF,2)-nanmedian(CleanData(pl).s(refF,2)),'k');
    hold on
    cdfplotAA(CleanData(pl).s(refF,2)-nanmedian(CleanData(pl).s(refF,2)),'r');
    title(strcat('PL:', num2str(pl), ' Flu-', titulo) )
	text(0, .2, strcat('KS p=',num2str((floor(p*100000))/100000)))
	[h p]=ranksum(CleanData(pl).s(mutF,2)-nanmedian(CleanData(pl).s(refF,2)), CleanData(pl).s(refF,2)-nanmedian(CleanData(pl).s(refF,2)) );
    text(0, .1, strcat('W p=',num2str((floor(h*100000))/100000)))
    xlim([-.03 .03])
    grid off
end
legend('mut', 'ref')
end

%%
figure()
mutante=ras2;
titulo='ras2';
for i=1:4
    for j=i:4
    clf

    index=find(Data(i).s(:,2)<.5 & Data(j).s(:,2)<.5 &  Data(i).s(:,2)>-.5 & Data(j).s(:,2)>-.5);
    
    plot( Data(i).s(index,2),Data(j).s(index,2),'.c' )
    hold on
    plot( Data(i).s(CenRefsCit,2),Data(j).s(CenRefsCit,2),'.r')
    
	plot( Data(i).s(mutante,2),Data(j).s(mutante,2),'.b')

    [r p] = corrcoef(Data(i).s(index,2),Data(j).s(index,2));
    text([-.2],[.2 ],num2str(r(2)) );
    text([-.2],[-.3],num2str(p(2)) );
    xlabel(i); ylabel(j)
    legend('Mutantes','Referencias')
    title(titulo)
    xlim([-.4 .4])
    ylim([-.4 .4])
    %grid on
    pause
    end
end

% considerar doublets
% considerar no fluorescentes
% cambiar los gates

%%
names=fieldnames(muts);
namesC=fieldnames(mutsC);

%% SCATTER PLOT comaraciones de plato en citometr[ia vs plato fluorimetria  XXXXXXXXXX
for i=1:length(names)
    mutF=muts.(cell2mat(names(i)));
    mutC=mutsC.(cell2mat(names(i)));
    
    refF=muts.refs;
    refC=mutsC.refs;
    
    titulo=names(i);
    figure(i+100)
    clf
    
for pl=[1:4]
    subplot(2,2,pl)
	plot(Data(pl).s(:,2), CleanData(pl).s(:,2),'.c' );
    hold on
    plot(Data(pl).s(mutC,2), CleanData(pl).s(mutF,2),'.' );
    plot(Data(pl).s(refC,2), CleanData(pl).s(refF,2),'.r' );
    xlabel(strcat('Cit PL', num2str(pl) ))
    ylabel(strcat('Flu PL', num2str(pl) ))
    ylim([-.2 .1] )
    xlim([-.2 .1 ])
    title(titulo)
    
end
end

%% ya que no da tan parecido, en que punto es si ploteo RoCs sale mejor?

for i=1:length(names)
    mutF=muts.(cell2mat(names(i)));
    mutC=mutsC.(cell2mat(names(i)));
    
    refF=muts.refs;
    refC=mutsC.refs;
    
    titulo=names(i);
    figure(i+100)
    clf
    
for pl=[1:4]
    subplot(2,2,pl)
	plot(Data(pl).s(:,2), CleanData(pl).s(:,2),'.c' );
    hold on
    plot(Data(pl).s(mutC,2), CleanData(pl).s(mutF,2),'.' );
    plot(Data(pl).s(refC,2), CleanData(pl).s(refF,2),'.r' );
    xlabel(strcat('Cit PL', num2str(pl) ))
    ylabel(strcat('Flu PL', num2str(pl) ))
    ylim([-.4 .2] )
    xlim([-.4 .2 ])
    title(titulo)
    
end
end

%% Cuenta cu'antas veces aparece cada pato en todo el experimento. 
cuentas(1:4)=zeros;%es del 1 al4 porque tenemos 4 platos, cada casilla de este vector representa un plato
for renglon=2:length(TXT)
    platoCell=strsplit( str2mat(TXT(renglon,1)), 'PL' );
    platoNum=str2num(cell2mat(platoCell(2)));
    cuentas(platoNum)=cuentas(platoNum)+1;
     if cuentas(2)-cuentas(3)>96
         platoCell
         pause
     end
    %pause
end
% Todas las mediciones de longevidad 
for i=1:length(names)
    mutF=muts.(cell2mat(names(i)));
    mutC=mutsC.(cell2mat(names(i)));
    refF=muts.refs;
    refC=mutsC.refs;
    titulo=names(i);
    figure(i+100)
    clf
    con=0;
for pl=[1 2 3 4]
    con=con+1;
    subplot(4,4,con)
    [h p]=kstest2(Data(pl).s(mutC,2)-nanmedian(Data(pl).s(refC,2)),Data(pl).s(refC,2)-nanmedian(Data(pl).s(refC,2)) );
    cdfplotAA(Data(pl).s(mutC,2)-nanmedian(Data(pl).s(refC,2)) ,'b')
    hold on
    cdfplotAA(Data(pl).s(refC,2)-nanmedian(Data(pl).s(refC,2)),'r')
    title(strcat('PL:', num2str(pl), ' Cit-', titulo))
    text(0, .2, num2str((floor(p*100000))/100000))
    xlim([-.06 .06])
    %pl=pl+9;
    subplot(4,4,con+4)
    [h p]=kstest2(CleanData(pl).s(mutF,2)-nanmedian(CleanData(pl).s(refF,2)), CleanData(pl).s(refF,2)-nanmedian(CleanData(pl).s(refF,2)) );
    cdfplotAA(CleanData(pl).s(mutF,2)-nanmedian(CleanData(pl).s(refF,2)),'b');
    hold on
    cdfplotAA(CleanData(pl).s(refF,2)-nanmedian(CleanData(pl).s(refF,2)),'r');
    title(strcat('PL:', num2str(pl), ' Flu-', titulo) )
	text(0, .2, num2str((floor(p*100000))/100000))
    xlim([-.06 .06])    

end
legend('mut', 'ref')

mut=muts.(cell2mat(names(i)));
titulo=names(i);
figure(100+i);
con=8;
for pl=[10:17]
    if pl<14
        con=con+1;
        subplot(4,4,con)
        [h p]=kstest2(CleanData(pl).s(mut,2)-nanmedian(CleanData(pl).s(refs,2)), CleanData(pl).s(refs,2)-nanmedian(CleanData(pl).s(refs,2)))
        cdfplotAA(CleanData(pl).s(mut,2)-nanmedian(CleanData(pl).s(refs,2)),'b')
        hold on
        cdfplotAA(CleanData(pl).s(refs,2)-nanmedian(CleanData(pl).s(refs,2)),'r')
        text(0, .2, num2str((floor(p*100000))/100000))
%         if ~isempty(find(~isnan(CleanData(pl).s2(mut,2))))
%             cdfplotAA2(CleanData(pl).s2(mut,2),'c')
%             cdfplotAA2(CleanData(pl).s2(refs,2),'m')
%         end
        title(strcat(titulo, '-PL' ,num2str(pl)))
        xlim([-.06 .06])
    end
    if pl>13
        con=con+1;
        subplot(4,4,con)
        stderror=nanstd(survival(pl).s(:,mut)')./sqrt(length(survival(pl).s(:,mut)'));
        meansurv=nanmean(survival(pl).s(:,mut)');
        NuevosDias=EncuentraDias(CleanData(pl), .3);
        x=CleanData(pl).t(NuevosDias)-CleanData(pl).t(1);
        PlotConError(x,meansurv, meansurv+stderror,meansurv-stderror,'b')
        hold on
        stderror=nanstd(survival(pl).s(:,refs)')./sqrt(length(survival(pl).s(:,refs)'));
        meansurv=nanmean(survival(pl).s(:,refs)');
        PlotConError(x,meansurv, meansurv+stderror,meansurv-stderror,'r')
        ylim([0 110])
        xlim([0 15])
        title(strcat(titulo, '-PL' ,num2str(pl)))
        grid on
    end
end %8x12 curvas de decaimiento


end %diluciones 1:10
%%  POR QUÉ SON LAS DIFERENCIAS ENTRE RIM15CIT Y RIM15FLU
% PLOT DE LAS 4 MEDICIONES DE UNA MISMA MUTANTE
pl=2;
for i=5%1:length(names)
    mutF=muts.(cell2mat(names(i)));    mutC=mutsC.(cell2mat(names(i)));
    refF=muts.refs;    refC=mutsC.refs;
    titulo=names(i);    figure(i+100);
    clf;    con=0;
    con=con+1;
    subplot(2,2,con)
    [h p]=kstest2(Data(pl).s(mutC,2)-nanmedian(Data(pl).s(refC,2)),Data(pl).s(refC,2)-nanmedian(Data(pl).s(refC,2)));
    cdfplotAA(Data(pl).s(mutC,2)-nanmedian(Data(pl).s(refC,2)) ,'b')
    hold on
    cdfplotAA(Data(pl).s(refC,2)-nanmedian(Data(pl).s(refC,2)),'r')
    title(strcat('PL:', num2str(pl), ' Cit-', titulo))
    text(0, .2, num2str((floor(p*100000))/100000))
    xlim([-.06 .06])    
    con=con+1;
    subplot(2,2,con)
    [h p]=kstest2(CleanData(pl).s(mutF,2)-nanmedian(CleanData(pl).s(refF,2)), CleanData(pl).s(refF,2)-nanmedian(CleanData(pl).s(refF,2)));
    cdfplotAA(CleanData(pl).s(mutF,2)-nanmedian(CleanData(pl).s(refF,2)),'b');
    hold on
    cdfplotAA(CleanData(pl).s(refF,2)-nanmedian(CleanData(pl).s(refF,2)),'r');
    title(strcat('PL:', num2str(pl), ' Flu-', titulo) )
	text(0, .2, num2str((floor(p*100000))/100000))
    xlim([-.06 .06])
    
legend('mut', 'ref')
mut=muts.(cell2mat(names(i)));
titulo=names(i);
figure(100+i);
for pl=[13 17]
    if pl<14
        con=con+1;
        subplot(2,2,con)
        [h p]=kstest2(CleanData(pl).s(mut,2)-nanmedian(CleanData(pl).s(refs,2)), CleanData(pl).s(refs,2)-nanmedian(CleanData(pl).s(refs,2)));
        cdfplotAA(CleanData(pl).s(mut,2)-nanmedian(CleanData(pl).s(refs,2)),'b')
        hold on
        cdfplotAA(CleanData(pl).s(refs,2)-nanmedian(CleanData(pl).s(refs,2)),'r')
        text(0, .2, num2str((floor(p*100000))/100000))
%         if ~isempty(find(~isnan(CleanData(pl).s2(mut,2))))
%             cdfplotAA2(CleanData(pl).s2(mut,2),'c')
%             cdfplotAA2(CleanData(pl).s2(refs,2),'m')
%         end
        title(strcat(titulo, '-PL' ,num2str(pl)))
        xlim([-.06 .06])
    end
    if pl>13
        con=con+1;
        subplot(2,2,con)
        stderror=nanstd(survival(pl).s(:,mut)')./sqrt(length(survival(pl).s(:,mut)'));
        meansurv=nanmean(survival(pl).s(:,mut)');
        NuevosDias=EncuentraDias(CleanData(pl), .3);
        x=CleanData(pl).t(NuevosDias)-CleanData(pl).t(1);
        PlotConError(x,meansurv, meansurv+stderror,meansurv-stderror,'b')
        hold on
        stderror=nanstd(survival(pl).s(:,refs)')./sqrt(length(survival(pl).s(:,refs)'));
        meansurv=nanmean(survival(pl).s(:,refs)');
        PlotConError(x,meansurv, meansurv+stderror,meansurv-stderror,'r')
        ylim([0 110])
        xlim([0 15])
        title(strcat(titulo, '-PL' ,num2str(pl)))
        grid on
    end
end %8x12 curvas de decaimiento

end %diluciones 1:10

%% ver los RoCs de la mutante
%close all
names=fieldnames(muts);
plato=2;
j=5
for pl=[plato plato+9]%[1:4 10:13]
    figure()
    clf  
	%j=1;%1:length(names)
    mut=muts.(cell2mat(names(j)));
    con=0;
    for i=mut
        title(strcat(names(j),'-PL:', num2str(pl) )  )
        con=con+1;
        subplot(2,4,con)
        NuevosDias=EncuentraDias(CleanData(pl), .3);
        for lim=length(NuevosDias)
            ejex=CleanData(pl).t(NuevosDias(1:lim))-CleanData(pl).t(1);
            if length(find(~isnan(CleanData(pl).RoC(1:lim,i))))>2
                m=robustfit(ejex,CleanData(pl).RoC(1:lim,i));
                CleanData(pl).sSlide(i,lim-2)=m(2);
                plot(ejex,CleanData(pl).RoC(1:lim,i),'o-b' );
                hold on
                plot(ejex,CleanData(pl).RoC(1:lim,muts.cenrefs ),'.--r' );
                
                p=plot([0 20], [m(1) m(2)*18+m(1)],'r' );
                set(p,'Color',[0 1 lim/length(NuevosDias)])
                ylim([.5 1.5])
                xlim([-1 15])
          %      text(6,lim/length(NuevosDias),num2str( floor(m(2)*10000)/10000 ) )
            end
        end
    end
end
figure()
for pl = plato
    mutC=mutsC.(cell2mat(names(j)));
    con=0;
    for i=mutC
        con=con+1;
        subplot(2,4,con)
        plot( ejex(1:8), Data(pl).IntRoC(:,i), 'o-b')
        hold on
        plot( ejex(1:8), Data(pl).IntRoC(:,mutsC.cenrefs), 'o--r')
        ylim([-.3 1.4])
        title(strcat(names(j),'-PL-', num2str(pl) ) )
        xlim([-1 15])
    end
end



%%  SCATTERS entre s de citometro
platosComp=[1:4];
con=0;
figure(321)
clf
for pl=platosComp
    for pl2=platosComp
        con=con+1;
        %subplot(4,4,con)
        indices=find(Data(pl).s(:,2)>-.2 & Data(pl).s(:,2)<.1 & Data(pl2).s(:,2)>-.2 & Data(pl2).s(:,2)<.1 );        
        [r,p]=corrcoef(Data(pl).s(indices,2), Data(pl2).s(indices,2));
        plot(Data(pl).s(:,2), Data(pl2).s(:,2), 'ok' );
        hold on
        plot(Data(pl).s(mutsC.refs,2), Data(pl2).s(mutsC.refs,2), 'or' )
        
	    if r(2) > 0.5
        %    set(gca,'Color', [.8, .6, 1-abs(r(2))])
        elseif r(2) < -.5
            set(gca,'Color', [.2, .6, 1-abs(r(2))])
        end
        
        xlabel(strcat('Cit PL:', num2str(pl) ))
        ylabel(strcat('Cit PL:', num2str(pl2) ))
        text(.0,.07, num2str(floor(r(2)*1000)/1000) )
        text(.0,-.15, num2str(floor(p(2)*1000)/1000) )
        xlim([-.25 .15])
        ylim([-.25 .15])
        pause
        clf
    end    
end

%%  SCATTERS entre s de citometro vs fluorimetro

platosComp=[1:4];
con=0;
figure(333)
clf
for pl=platosComp
    for pl2=platosComp
        con=con+1;
        subplot(4,4,con)
        indices=find(Data(pl).s(:,2)>-.2 & Data(pl).s(:,2)<.2 & CleanData(pl2).s(:,2)>-.2 & CleanData(pl2).s(:,2)<.2 );        
        [r,p]=corrcoef(Data(pl).s(indices,2), CleanData(pl2).s(indices,2));
        plot(Data(pl).s(:,2), CleanData(pl2).s(:,2), '.k' );
        hold on
        plot(Data(pl).s(mutsC.refs,2), CleanData(pl2).s(muts.refs,2), '.r' )
        
	     if r(2) > 0.5
            set(gca,'Color', [.8, .6, 1-abs(r(2))])
        elseif r(2) < -.5
            set(gca,'Color', [.2, .6, 1-abs(r(2))])
        end
        
        xlabel(strcat('Cit PL:', num2str(pl) ))
        ylabel(strcat('Flu PL:', num2str(pl2) ))
        text(-.15,.1, strcat('r=', num2str(floor(r(2)*1000)/1000)) )
        text(-.15,-.1, strcat('p=', num2str(floor(p(2)*1000)/1000)) )
        axis square
        xlim([-.2 .2])
        ylim([-.2 .2])        
    end    
end
con=0;
figure(334)
clf
for pl=platosComp
    for pl2=platosComp
        con=con+1;
        subplot(4,4,con)
        indices=find(Data(pl).s(:,2)>-.2 & Data(pl).s(:,2)<.2 & CleanData(pl2).st(:,2)>-.2 & CleanData(pl2).st(:,2)<.2 );        
        [r,p]=corrcoef(Data(pl).s(indices,2), CleanData(pl2).st(indices,2));
        plot(Data(pl).s(:,2), CleanData(pl2).st(:,2), '.k' );
        hold on
        plot(Data(pl).s(mutsC.refs,2), CleanData(pl2).st(muts.refs,2), '.r' )
        
	     if r(2) > 0.5
            set(gca,'Color', [.8, .6, 1-abs(r(2))])
        elseif r(2) < -.5
            set(gca,'Color', [.2, .6, 1-abs(r(2))])
        end
        
        xlabel(strcat('s, Cit PL:', num2str(pl) ))
        ylabel(strcat('st, Flu PL:', num2str(pl2) ))
        text(-.15,.1, strcat('r=', num2str(floor(r(2)*1000)/1000)) )
        text(-.15,-.1, strcat('p=',num2str(floor(p(2)*1000)/1000)) )
        xlim([-.2 .2])
        ylim([-.2 .2])        
        axis square
    end    
end

%% CORRELACION DE  st vs st
platosComp=[11 13]
figure(124)
clf
con=0;
for pl=1:length(platosComp)
    for pl2=1:length(platosComp)
        con=con+1;
        %subplot(8,8,con)
        p=plot(CleanData(platosComp(pl)).st(:,2), CleanData(platosComp(pl2)).st(:,2),'ok','MarkerSize',3);
        hold on
        p=plot(CleanData(platosComp(pl)).st(muts(pl).refs,2), CleanData(platosComp(pl2)).st(muts(pl).refs,2),'or','MarkerSize',3);
        indices = intersect(find(~isnan(CleanData(platosComp(pl)).st(:,2))),find(~isnan(CleanData(platosComp(pl2)).st(:,2))));
        [r,p]=corrcoef(CleanData(platosComp(pl)).st(indices,2), CleanData(platosComp(pl2)).st(indices,2));
        ylim([-.05 .04])
        xlim([-.05 .04])
        %set(gca,'XTick','')
        axis square
        grid on
        if pl==1
            title(strcat('st, PL:', num2str(platosComp(pl2))) )
        end
        if pl2==1
            ylabel(platosComp(pl))
        end
        text(-.04,.03, num2str(floor(r(2)*1000)/1000))
        text(-.04,-.04, num2str(floor(p(2)*1000)/1000))
        set(gca,'xtick',[],'ytick',[])
        pause 
        clf
    end
end


%% VER TODOS LOS POZOS DE UNA SOLA MUTANTE PARA DETECTAR CUAL ES EL OUTLIER Y POR QUE

for hide=1
muts.swr1=[1 14 26 31 56 59 76]; 
muts.msn4=[9 22 39 42 67 84 72];
muts.ras2=[5 25 38 55 50 80 83];
muts.ste12=[33 66 91 21 46 63];
muts.rim15=[49 74 4 29 62 79];
muts.tor1=[57 90 12 45 70 87];
muts.hap3=[73 11 28 53 86 8];
muts.rps16a=[81 19 36 69 94 24];
muts.atg1=[2 7 35 52 77 32];
muts.msn2=[18 15 43 60 93 48];
muts.refs=[3 6 10 13 16 17 20 23 27 30 34 37 40 41 44 47 51 54 58 61 64 65 68 71 75 78 82 85 88 92 95];
muts.cenrefs=[10 13 20 23 27 30 34 37 44 47 51 54 58 61 68 71 75 78 82 85 ];
end
names=fieldnames(muts);
for pl=1%[1:4 10:13]
    %figure(pl)
    %clf
	for j=1:length(names)-2
    mut=muts.(cell2mat(names(j)));
    con=0;
    figure(j+100)
    clf
    for i=mut
        con=con+1;
        subplot(2,4,con)
        hold on
        NuevosDias=EncuentraDias(CleanData(pl), .3);
        %clf
    
        for lim=3:length(NuevosDias)
            ejex=CleanData(pl).t(NuevosDias(1:lim))-CleanData(pl).t(1);
            if length(find(~isnan(CleanData(pl).RoC(1:lim,i))))>2
                m=robustfit(ejex,CleanData(pl).RoC(1:lim,i));
                CleanData(pl).sSlide(i,lim-2)=m(2);
                plot(ejex,CleanData(pl).RoC(1:lim,i),'ob' );
                hold on
                p=plot([0 20], [m(1) m(2)*18+m(1)],'r' );
                set(p,'Color',[0 1 lim/length(NuevosDias)] )
                %ylim([.9 1.1])
%                text(6,lim/length(NuevosDias),num2str( floor(m(2)*10000)/10000 ) )
            end
            
            if length(find(~isnan(CleanData(pl).RoC2(1:lim,i))))>2
                m=robustfit(ejex,CleanData(pl).RoC2(1:lim,i));
                CleanData(pl).sSlide2(i,lim-2)=m(2);
                plot(ejex,CleanData(pl).RoC2(1:lim,i),'*c' );
                hold on
                p=plot([0 20], [m(1) m(2)*18+m(1)],'--m' );
                %set(p,'Color',[0 1 lim/length(NuevosDias)] )
                %ylim([.9 1.1])
                xlim([-1 17])
             %   text(6,lim/length(NuevosDias),num2str( floor(m(2)*10000)/10000 ) )
            end
	title(strcat('PL:', num2str(pl),'-', names(j), '-well-',num2str(i) ))

            
        end
    end
    end
end







