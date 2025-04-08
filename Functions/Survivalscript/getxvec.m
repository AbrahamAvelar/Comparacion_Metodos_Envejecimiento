function [survival] = getxvec(bgdata,survival,pls,od,odTh);


for pl = pls%1:length(bgdata);
intervals = intervalsOD(bgdata,odTh,pl);%intervals at time when measurement day changes

timetmp=[];
    for well = 1:96;        
        for days = 1:length(intervals)-1;
        x = bgdata(pl).t(intervals(days)+1:intervals(days+1)); %raw time vector at specific interval
        y = bgdata(pl).OD(intervals(days)+1:intervals(days+1),well); %OD vector at specific interval
 if size(x,1)==size(y,1)
        timetmp=[timetmp,interp1q(y,x,od)];
 else
        timetmp=[timetmp,interp1q(y,x',od)];
 end    
        end
    end

%struct
 timetmp = reshape(timetmp,length(timetmp)/96,96);
 timetmp = timetmp-min(timetmp(:));
 survival(pl).t = timetmp;
 %timetmp = bsxfun(@rdivide,timetmp,24);
 %survival(pl).t = fix(timetmp); %9-sep-16
 %survival(pl).t = fix(timetmp-min(timetmp(:)));
 
%subplot(5,5,pl)

%figure(pl)


% for i=1:length(1:11)
%     colsym = [colours(mod(i-1,lc)+1), syms(mod(i-1,ls)+1)];
%     x=nanmean(survival(pl).t(:,hash.(cell2mat(keys(i)))));
%     y=nanmean(survival(pl).s(:,hash.(cell2mat(keys(i)))));
%     h= plot(x',y',colsym);
%     hold on
% end
% legend(keys)

% h = plot(survival(pl).t,survival(pl).s,'k.-'); hold on
% h = plot(survival(pl).t(:,[25:12:72 31:12:72 36:12:72]),survival(pl).s(:,[25:12:72 31:12:72 36:12:72]),'r.-');
% h = plot(survival(pl).t(:,[ 31:12:72 ]),survival(pl).s(:,[31:12:72 ]),'ro-');
% xlim([-1 12]); %change according to data
% ylim([0 110]);
% set(gca,'yscale','log');
% axis square

end
