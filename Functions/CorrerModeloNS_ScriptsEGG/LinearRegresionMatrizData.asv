%%
%[PLw Ww Tw tw LOGRCw RFPw CFPw];
function [Ap,Sp,Gp,coefpl,rICS,rICG,respl,wells,days]=LinearRegresionMatrizData(dataw,wref);

y=dataw(:,5); %1536x1 if there is 2 times per one day
tmpplt=dataw(:,1);
wellplt=dataw(:,2);

nPL=length(unique(dataw(:,1))); 
[uniqWells] = unique(dataw(:,2));%bajo a alto
nW=length(uniqWells); %35 95w no esta, 90 solo tiene 12 en lugar de 14

tmpTlarge=dataw(:,3);
tmptsmall=dataw(:,4);
Tt=[tmpTlarge+tmptsmall];
[tmpmeas,indTt]=unique(Tt);
tmpuniqMeas=tmptsmall(indTt);
nMM=length(unique(Tt));

uniqM=[];
uniqMok=[];
for i=1:length(dataw(:,4)); %little t
        tmp=Tt(i);
        tmp2=dataw(i,4);
        if ismember(tmp,tmpmeas) & ~ismember(tmp,uniqM); %La primera siempre se va a cumplir, No?
            uniqM=[uniqM;tmp];
            uniqMok=[uniqMok;tmp2];
        end;
end;
uniqMok=uniqMok';
nM=length(uniqMok);
colIw = nW;
rowIw = size(dataw,1); %96*2  *8days, orden [192dia1;192dia2,etc]
Iw=zeros(rowIw,colIw);  %1536*96 si estan todos los dagos
for wi = 1:nW % first row of 1 = bajow %Llena Iw que tiene a las Axs
    w = uniqWells(wi);
    f=find(dataw(:,2)==w);
    Iw(dataw(:,2)==w,wi)=1;
end
TT = diag(dataw(:,3));
tt = diag(dataw(:,4));

colIc = nM;
Ic=zeros(rowIw,colIc);
for mi = 1:nM
    m = uniqMok(mi); % ya esta ordenado por T1 tt1 T1 tt2
    Ic(dataw(:,4)==m,mi)=1;
end

wellnodata0=setdiff([1:96],unique(wellplt)); %wells for A
wellnodata=setdiff(wellnodata0,wref); % withouth controls wells
welldata=intersect([1:96],unique(wellplt)); %some of these are wref wells

wref2=setdiff(wref,wellnodata0);
indcolwt=[];% to remove
newwelldataSG=[]; %wells for TT
for i=1:nW;
    wellsall=unique(wellplt);
    tmpw=wellsall(i);
    if ismember(tmpw,wref2);
        indcolwt=[indcolwt;i];
    else
        newwelldataSG=[newwelldataSG;tmpw]; % mutant-wt
    end;
end;


TTIw=TT*Iw;
ttIw=tt*Iw;
%M = [Iw TTIw ttIw Ic]; %para aquellas placas con 8 d?as incluye nan

% remove wt columns
nTTIw=[];
nttIw=[];
for sel=1:size(TTIw,2);
    if ~ismember(sel,indcolwt);
        nTTIw=[nTTIw TTIw(:,sel)];
        nttIw=[nttIw ttIw(:,sel)];
    end;
end;
    
M = [Iw nTTIw nttIw Ic]; %Wt columns were removed of TT*Iw
lenwr=length(wref2);

%tmpplt
%wellplt
[coefw,bint,r,rint,bla]=regress(y,M); %nW+nW+nW+16-->nW+nW-8+nW-8+16

[AAx AAr]=linsolve(M,y);

%3 coef for A, 2 for B, 2 for C
lencoef=nW+nW-lenwr+nW-lenwr;
coefwi=coefw(1:lencoef); %3,2,2 coeficientes
coefwiA=coefwi(1:nW);
coefwiS=coefwi(nW+1:nW*2-lenwr);
coefwiG=coefwi(nW+1+length(coefwiS):length(coefwi));

ICcoefwi=bint(1:lencoef,:);  %3,2,2 coeficientes
ICA=ICcoefwi(1:nW,:);
ICS=ICcoefwi(nW+1:nW*2-lenwr,:);
ICG=ICcoefwi(nW+1+size(ICS,1):size(ICcoefwi,1),:);

coefpl=coefw(lencoef+1:end);
%coefp=[1:length(coefpl)];

orderesiduals;
respl;
wells;
days;

Ap=[];
Sp=[];
Gp=[];

rICS=[];
rICG=[];

tmpwr2=setdiff(wref,wref2);
count=1;
count2=1;
for i=1:96;
    if ismember(i,newwelldataSG); %welldata without lenwr
        ca=coefwiA(count2);
        cs=coefwiS(count);
        cg=coefwiG(count); 
        iccs=ICS(count,:);
        iccg=ICG(count,:);
        iccs=iccs';
        iccg=iccg';
        Ap=[Ap;ca];
        Sp=[Sp;cs];
        Gp=[Gp;cg];

        rICS=[rICS iccs];
        rICG=[rICG iccg];
        count=count+1;
        count2=count2+1;
    elseif ismember (i,wref2); %non nan wref
        ca=coefwiA(count2);
        Ap=[Ap;ca];
        Sp=[Sp;NaN];
        Gp=[Gp;NaN];
        tmpn=[NaN;NaN];
        rICS=[rICS tmpn];
        rICG=[rICG tmpn]; 
        count2=count2+1; 
    elseif ismember (i,tmpwr2); %nan ref
        Ap=[Ap;NaN];
        Sp=[Sp;NaN];
        Gp=[Gp;NaN];
        tmpn=[NaN;NaN];
        rICS=[rICS tmpn];
        rICG=[rICG tmpn];
    elseif ismember (i,wellnodata); %no mutant data
        Ap=[Ap;NaN];
        Sp=[Sp;NaN];
        Gp=[Gp;NaN];
        tmpn=[NaN;NaN];
        rICS=[rICS tmpn];
        rICG=[rICG tmpn];
    
    end;
end;
tmppa=newwelldataSG;wref2;tmpwr2;wellnodata;
clear count;
Ap=Ap';
Sp=Sp';
Gp=Gp';
rICS=rICS;
rICG=rICG;
%c=meshgrid(coefpl,1:96);
%coefp=c';



