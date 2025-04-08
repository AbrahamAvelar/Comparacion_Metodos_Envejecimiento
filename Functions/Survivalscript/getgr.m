function [gwrate] = getgr(bgdata,pls,n0,nt,odTh)

for pl = pls% 1:length(bgdata);
intervals = intervalsOD(bgdata,odTh,pl);%intervals at time when measurement day changes
gwrate0=[];
gwrateT=[];
    for well = 1:96;        
        for days = 1:length(intervals)-1;

        x=bgdata(pl).t(intervals(days)+1:intervals(days+1)); %raw time vector at specific interval
        x = x- (bgdata(pl).t(intervals(days)+1));%fixed time vector (minus hours at first point of each interval)
        y=bgdata(pl).OD(intervals(days)+1:intervals(days+1),well); %OD vector at specific interval

 if size(x,1)==size(y,1)
        gwrate0=[gwrate0,interp1q(y,x,n0)]; %Obtains time at initial OD each day n0
        gwrateT=[gwrateT,interp1q(y,x,nt)]; %Obtains time at final OD each day nt
 else
        gwrate0=[gwrate0,interp1q(y,x',n0)]; %Obtains time at initial OD each day n0
        gwrateT=[gwrateT,interp1q(y,x',nt)]; %Obtains time at final OD each day nt

 end

        
        end
    end

 time = gwrateT-gwrate0;
 %formula to obtain growth rate as time data in "time" matrix is already
 %the time difference for OD looked for at each day interval for each well
 %duplication time = logNt-logN0/log2*t 
 %let Nt be final population OD at each point
 %N0 initial population OD
 %t= delta time difference Nt-N0
 
 vectmp = ones(1,length(time));
 kratetmp = (log(nt) - log(n0))*vectmp;
 logtime = (log(2))*time;
 
 krate = [];
 for i=1:length(time);
 krate = [krate,kratetmp(i)/logtime(i)];
 end
 
 gwratetmp = [];
 for i=1:length(time);
gwratetmp = [gwratetmp,vectmp(i)/krate(i)];
 end
 

 gwratetmp = reshape(gwratetmp,length(time)/96,96);
 
 gwrate(pl) = struct('T',{gwratetmp});

end
