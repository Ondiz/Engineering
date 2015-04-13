function DibujaElipseParam(centrox, centroy, angulo, a, b)

% Dibuja una elipse centrada en (centrox, centroy) 

t=[0:0.01:2*pi];

x= centrox + a*cos(t)*cos(angulo) - b*sin(t)*sin(angulo);
y= centroy + a*cos(t)*sin(angulo) + b*sin(t)*cos(angulo);

z= zeros(size(x));

axis equal

if a == b
   
    color= 'r';  % Dibuja la circunferencia en rojo

else
   
    color= 'g';  % Dibuja la elipse en verde
    
end

hold on
plot3(x,y,z,'LineWidth',2,'Color', color)
