function [ intervals ] = intervalCriteriaS_NS(od,odThresh)
%cuando perdiste la mayor parte de lecturas finales en un d?a

if nargin < 2
    odThresh=-0.22;
end

diffod=diff(od,1,1);
[p,q]=sort(min(diffod,[],2));
indTemp=q(p<odThresh);
intervals=[0;sort(indTemp);size(od,1)];
end