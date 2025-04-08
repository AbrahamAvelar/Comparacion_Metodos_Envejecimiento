%This will find the lines where there is a change in days of experiment

function intervals = intervalsOD(bgdata,odTh,pl)

diffOD = diff(bgdata(pl).OD,1,1); %create matrix where large negative numbers indicate a change in the day of measurement
%minOD = (min(diffOD,[],2)); %sort data of minimums (2nd dim measure points not wells!) in order to get all the lines with lower od than threshold od
%ind = find(minOD<odTh); 
ind=find(nanmean(diffOD')<odTh);

intervals = [0;ind';(size(bgdata(pl).OD,1)-1)]; %intervals in each day of measurement
end


