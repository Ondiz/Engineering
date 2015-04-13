function [pos1 pos2]=MaximoSegmento(coordenadas)
% Calcula cuales son los dos puntos más alejados de una matriz cuyas filas
% son coordenadas de puntos

tamano=size(coordenadas);
maxlong=0;

%Inicializar (para evitar error si todas las coordenadas coinciden)

pos1=1;
pos2=1;

for i=1:(tamano(1)-1)
    
    for j=(i+1):tamano(1)
 
    segmento= coordenadas(j,:)-coordenadas(i,:);
    longitud= norm(segmento);
    
        if longitud > maxlong
            maxlong=longitud;
            pos1=i;
            pos2=j;
        end
        
    end
end

end