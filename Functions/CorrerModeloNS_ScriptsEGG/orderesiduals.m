
%tmpplt
%wellplt
%[coefw,bint,r,rint,bla]

%tmpTlarge=dataw(:,3);
%tmptsmall=dataw(:,4);
days=unique(tmpTlarge)
respl=nan(length(days),96.*2); % without WT wells
wells=nan(length(days),96.*2); % without WT wells
for i=1:length(days);
    tmp=days(i);
    f=find(tmpTlarge==tmp);
    res=r(f)';
    w=wellplt(f)';
    count=0;
    for tw=1:96;
        g=find(tw==w);
        if ~isempty(g);
            leng=length(g);
            respl(i,count+1:count+leng)=res(g);
            wells(i,count+1:count+leng)=w(g);
            count=count+2;
        else;
            count=count+2;
        end;
    end;
    %respl(i,1:length(res))=res;
    %wells(i,1:length(res))=w;
end;



