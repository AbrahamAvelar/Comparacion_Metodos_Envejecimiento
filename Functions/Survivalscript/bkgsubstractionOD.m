function bgdata = bkgsubstractionOD (bgdata,value)
for i= 1:length(bgdata);
    bgdata(i).OD=bgdata(i).OD-value;
end
end
