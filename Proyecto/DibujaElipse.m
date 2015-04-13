  
function DibujaElipse(centrox, centroy, a, b)

% Dibuja una elipse centrada en (centrox, centroy) y cuyos ejes son
% paralelos a los ejes coordenados

x=[(centrox-a): 0.003 :(centrox+ a)];
y= b * ((1-((x - centrox)./a).^2).^0.5) + centroy;
yneg= - b * ((1-((x - centrox)./a).^2).^0.5) + centroy;

z= zeros(size(x));

axis equal

if a == b
   
    color= 'r';

else
   
    color= 'g';
    
end

hold on
plot3(x,y,z,'LineWidth',2,'Color', color)
plot3(x,yneg,z,'LineWidth',2,'Color', color)