close all
clear
clc


puntos= [4 7 0; 4 1 0; 3 4 0; 5 4 0; 3.5 2 0; 4.5 2 0; 4.8 4 0; 4 6.5 0];  %vertical

%puntos = [1 3 0; 5 3 0; 3 4 0; 3 2 0];

%puntos=[ -0.6340    3.0981         0;
%          2.8301    5.0981         0;
%         0.5981    4.9641         0;
%          1.5981    3.2321         0];

scatter3(puntos(:,1),puntos(:,2),puntos(:,3),'b')

view([0 0 1])

hold on

[pos1 pos2]= MaximoSegmento(puntos);
 
punto1= puntos(pos1,:);

punto2= puntos(pos2,:);

grados= atan((punto2(2)- punto1(2))/(punto2(1)- punto1(1))); % Calcula el angulo entre la horizontal y la recta que forman los puntos más alejados. 
%Negativo significa que hay que girar en sentido contrario a las agujas del reloj 

[xcentro ycentro zcentro radio dos] = MinimoCirculo(puntos,[0 0 1], pos1, pos2);

[matriz_paso]= Giro(-grados);

centro_nuevo = matriz_paso*[xcentro; ycentro; zcentro];

puntos= matriz_paso*puntos';

puntos=puntos';

b = Elipse(puntos, centro_nuevo(1), centro_nuevo(2), radio);

scatter3(xcentro,ycentro,zcentro,'y')
DibujaElipseParam(xcentro, ycentro, grados, radio, radio)
hold on
DibujaElipseParam(xcentro, ycentro, grados, radio, b)

% con giro de 90 grados en sentido contrario a las agujas del reloj (este caso) hace
% bien el calculo

