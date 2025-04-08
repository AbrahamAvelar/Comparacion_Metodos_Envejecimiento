function [timeOD] = getime(bgdata,pls,od,odTh)

for pl = pls %1:length(bgdata);
intervals = intervalsOD(bgdata,odTh,pl);%intervals at time when measurement day changes

timeODtmp=[];

    for well = 1:96
        
        for days = 1:length(intervals)-1;


        x=bgdata(pl).t(intervals(days)+1:intervals(days+1)); %raw time vector at specific interval
        x = x- (bgdata(pl).t(intervals(days)+1));%fixed time vector (minus hours at first point of each interval)
        y=bgdata(pl).OD(intervals(days)+1:intervals(days+1),well); %OD vector at specific interval
% 
%  pl 
%  well
%  days
%  x
%  y
 if size(x,1)==size(y,1)
 timeODtmp=[timeODtmp,interp1q(y,x,od)];
 else
     timeODtmp=[timeODtmp,interp1q(y,x',od)];
 end
 
        end
       

    end

%struct
 timeODtmp = reshape(timeODtmp,length(timeODtmp)/96,96);
 timeODtmp = bsxfun(@minus,timeODtmp,timeODtmp(1,:));
 
 %modification to take negative times to 0, creating later survival curves
 %with a maximum of 100% even when there was no saturation in the first
 %days
 for w = 1:96 ;
     for row = 1:length(timeODtmp(:,w));
         
     f = find(timeODtmp(row,w)<0);
     if sum(f)>0;
      timeODtmp(:,w) = bsxfun(@minus,timeODtmp(:,w),timeODtmp(row,w));
     else
         timeODtmp = timeODtmp;
     end
     end
 end
%end of fix
 
 timeOD(pl) = struct('t',{timeODtmp});
 end


