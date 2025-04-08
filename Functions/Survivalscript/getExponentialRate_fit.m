% GET RATE USING AN EXPONENTIAL MODEL OF THE TYPE ' y = N^rx ' where 'N' is the initial size of the population 
%'r' is the decay rate and 'x' is time. In this case 'y' represents
%survival percentage
function [decayRate] = getdecayRate(survival,plts);

%We generate decay rate data for each well using survival time and
%percentage

for i = plts; %1:length(survival); %cambiado 27Marzo18
    X = survival(i).t;%we generate these vectors to fit them later to an exponential fit
    Y = survival(i).s;   
    tmpRate = [];
    for w = 1:96;
        f = find(~isnan(Y(:,w))); %index created to elminate NaN
        if length(f)<3;%fit needs at least more than 2 data points
            tmpfit.b = NaN;%if this is the case then 'b' or rate equals NaN 
        else
                tmpfit = fit(X(f,w),Y(f,w),'exp1'); %Exponential Fit
        end
           tmpRate = [tmpRate,tmpfit.b];%Decay Rate
           decayRate(i) = struct('r',tmpRate);%Matrix containing decay rate for each well acording to time and survival.s
     
    end
     
end

