function BgDataAll = CorrectInoculeTime(BgDataAll, platos, odTh, ExcelHorasInoculos )
% BgDataAll = CorrectInoculeTime(BgDataAll, odTh, ExcelHorasInoculos )
% odTh=.3;%cu'anto tiene que bajar la od en promedio para que sea considerado otro dia
horasInoculos=ExcelHorasInoculos;
[NUM TXT]= xlsread(horasInoculos);

    for pl=platos
    NuevosDias=EncuentraDias(CleanData(pl), odTh);
    ind=find(NUM(:,1)==pl)';
    
    y=cell2mat(TXT(ind,2));
    dias=datenum([y(:,end-1:end) y(:,3) y(:,4:6) y(:,1:2)  ]);
    diahora=dias+NUM(ind,3);
    
    CleanData(pl).t(NuevosDias)=diahora;
    end
end