function [eje_peq] = Elipse(coordenadas, centrox, centroy, radio)

% Calcula el eje peque�o de una elipse que contiene los puntos de la matriz
% coordenadas (cada fila representa las coordenadas de un punto), sabiendo 
% el centro y el radio del c�rculo que contiene dichos puntos.
% Los ejes de la elipse son paralelos a los ejes coordenados
% El centro de la elipse coincide con el del m�nimo c�rculo que engloba
% todos los puntos y su eje mayor es igual al radio de dicho c�rculo

   eje_peq = radio;
   
   b = (coordenadas(:,2)- centroy)./ (1-((coordenadas(:,1)-centrox)/radio).^2).^0.5;   % parte positiva de la elipse
   b1 = (coordenadas(:,2)- centroy)./ -(1-((coordenadas(:,1)-centrox)/radio).^2).^0.5;  % parte negativa de la elipse
   
   B = [b; b1];

   numero=size(B);

   %elegir el b m�s peque�o para el que todos los puntos est�n dentro 

            for i=1:numero(1)


                distancias= ( ((coordenadas(:,1)-centrox)./radio).^2 + ((coordenadas(:,2)-centroy)./B(i)).^2 ) <= 1 ;


                    if all (distancias) && (abs(B(i)) < eje_peq) 

                        eje_peq = abs(B(i));

                    end

            end


end
