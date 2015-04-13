function [matriz_paso]= Giro(grados, eje)

%GIRO: se gira el sistema de coordenadas alrededor del 'eje'
 
switch eje
    
     case 'x'
         matriz_paso = [1 0 0; 0 cos(grados) sin(grados); 0 -sin(grados) cos(grados)];
         
     case 'y'
         matriz_paso = [cos(grados) -sin(grados) 0; 0 1 0; sin(grados) cos(grados) 0]; 
         
     case 'z'
          matriz_paso = [cos(grados) sin(grados) 0; -sin(grados) cos(grados) 0; 0 0 1];

end
 
end