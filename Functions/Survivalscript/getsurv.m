function [survival] = getsurv(timeOD,gwrate,pl)
%function for formula survival = 1/2^(delta_Time/duplication_time)*100

for i = pl%1:length(pl)
  tmp =   bsxfun(@rdivide,timeOD(i).t,gwrate(i).T); %delta time divided by duplication time %introduce fix to assume a constant GR i.e.= nanmean(GR)
  tmp2 = 2.^tmp;
  
  tmp3 = bsxfun(@rdivide,1,tmp2)*100;%formula division using rdivide
  
  
  survival(i) = struct('s',{tmp3});%we turn matrix into structure containing each plate
  
end
  
  
