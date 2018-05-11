function BgDataAll = CorrectInoculeTime(BgDataAll, platos, odTh, ExcelHorasInoculos )
% BgDataAll = CorrectInoculeTime(BgDataAll, odTh, ExcelHorasInoculos )
% ExcelHorasInoculos = 'C:\Users\JAbraham\Dropbox\HorasInoculosE2Ago16.xlsx';
% con 3 columnas, Col1 con numero de plato, Col2 con dia Col3 con la hora
% por ejemplo:
%
%   1   09-ago  21:25
%   2   09-ago  21:27
%   3   09-ago  21:30
%   1   10-ago  19:05
%   2   10-ago  19:06
%   3   10-ago  19:35
%
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
