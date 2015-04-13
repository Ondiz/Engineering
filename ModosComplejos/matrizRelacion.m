% clear all
% close all
% clc

% A=xlsread('filtr.xls');
% modos=xlsread('modos_filtr.xlsx');
% Freq1=A(:,1);
% Freq1(1,:)=[];
% Freq2=A(1,:)';
% Freq2(1,:)=[];
% MAC_d=A;
% MAC_d(1,:)=[];
% MAC_d(:,1)=[];
% figure(1)
% bar3(MAC_d);
% ylabel('Cold disc modes');
% xlabel('Hot disc modes');
% tam1=size(MAC_d,1)+1;
% tam2=size(MAC_d,2);
% MAC_d(:,tam1:tam2)=[];
% f2=figure(2)
% h=bar3(MAC_d);
% ylabel('Cold disc modes');
% xlabel('Hot disc modes');

% placaRectangularSigma

% h=bar3(relacion>1);

h=bar3(relacion);

for i = 1:length(h)
    zdata = ones(6*length(h),4);
    k = 1;
    for j = 0:6:(6*length(h)-6)
        zdata(j+1:j+6,:) = relacion(k,i);
        k = k+1;
    end
    set(h(i),'Cdata',zdata)
end

%colormap cool
%c=colormap('gray');
c=colormap('jet');
%c=flipud(c); % de blanco a negro en vez de negro a blanco
colormap(c)
colorbar

for i = 1:numel(h)
  index = logical(kron(relacion(:,i) < 0.1,ones(6,1)));
  zData = get(h(i),'ZData');
  zData(index,:) = nan;
  set(h(i),'ZData',zData);
end

%xlim([0 n_Max+1])
%ylim([0 m_Max+1])
%view([0 90])
%saveas(f2,'MAC100','png')