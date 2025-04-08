function [survival] = getxvecAA(bgdata,survival,pls,od,odTh);


for pl = pls%1:length(bgdata);
intervals = intervalsOD(bgdata,odTh,pl);%intervals at time when measurement day changes

timetmp=[];
    NuevosDias=EncuentraDias(bgdata(pl), abs(odTh));

    for well = 1:96;     
        x=bgdata(pl).t(NuevosDias)-bgdata(pl).t(1);
%         for days = 1:length(intervals)-1;
%         x = bgdata(pl).t(intervals(days)+1:intervals(days+1)); %raw time vector at specific interval
%         y = bgdata(pl).OD(intervals(days)+1:intervals(days+1),well); %OD vector at specific interval
%         timetmp=[timetmp,interp1q(y,x,od)];
%         end       
        timetmp(1:length(x), well) = x;
    end

%struct
 %timetmp = reshape(timetmp,length(timetmp)/96,96);
 timetmp = timetmp-min(timetmp(:));
 survival(pl).t = timetmp;
end