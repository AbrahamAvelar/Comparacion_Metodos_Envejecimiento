function [MATRIZ VECTOR] = removeWellEquations(MATRIZ,VECTOR, wells, mediciones, lengthpozos)
con=0;

linesToDelete=[wells wells+lengthpozos wells+lengthpozos*2];

for w=wells
    MATRIZ( (mediciones*(w-1))+1-con:(mediciones*(w))-con,:)=[];%zeros(size( MATRIZ( (mediciones*(w-1))+1:(mediciones*(w)),:) ) , size(MATRIZ,2) );
    VECTOR( (mediciones*(w-1))+1-con:(mediciones*(w))-con )=[];
    
    
end
MATRIZ(:,linesToDelete)=[];
end