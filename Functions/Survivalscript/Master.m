% Most of these functions were first programmed by Sergio Campos and later modified by Abraham Avelar
%

%% General Parameters. 
% parameters for 63% validation (highest so far) od=.28 n0= .18 nt = .4
% (también nt=.48-toma un punto más) 19 validadas

pls=[1:7]; %number of plates
od = .3; % od at interpolation ORIGINAL .28
odTh = -0.3; %ORIGINAL -0.3
n0 = .15; % minimum OD for GR ORIGINAL .18
nt = .45; % Max OD for GR ORIGINAL .48
%indexes for mutant and media
mut1NR = [1:2:96];

%% 3. Bkg medium substraction
value = .07;
bgdataClean = bkgsubstractionOD(BgDataAll,value);% Generate new matrix bgdataAll.OD

%% 4 Take number of intervals according to days of experiment and generates
% matrix with population survival data
[timeOD] = getimeAA(bgdataClean,pls,od,odTh);  %Gets matrix with time at od stated above for each well and plate
%
[gwrate] = getgr(bgdataClean,pls,n0,nt,odTh); %Gets growth rate matrix
%
[survival] = getsurv(timeOD,gwrate,pls) %Gets survival percentage matrix
%
survival = getxvec(bgdataClean,survival,pls,od,odTh) %Gets matrix into survival structure for time at which interpolation was made in days and plots percentage vs time
save survival survival   


%% GET RATE USING AN EXPONENTIAL MODEL OF THE TYPE ' y = N^rx ' where 'N' is the initial size of the population 
%'r' is the decay rate and 'x' is time. In this case 'y' represents survival percentage
    
[decayRate] = getExponentialRate(survival);
