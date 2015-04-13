function [xcentro ycentro zcentro radio dos] = MinimoCirculo(coordenadas,normal, pos1, pos2)


    % Inicialización de matrices
    
     centros_x = 0;
     centros_y = 0;
     centros_z = 0;
     centros_r = 0;

    % las coordenadas están en filas

    dos= false; % Inicilizar valor. Si la circunferencia la definen 2 puntos será true
    tamano= size(coordenadas);

    % Comprobación de que todas las coordendas no sean iguales
    
    comp = zeros(tamano(1)-1 , 3);
    
    for j = 2: tamano(1)
        comp(j-1,:) = (coordenadas(j,:)== coordenadas(1,:));
    end

    if (~all(all(comp)))

        switch tamano(1)

            case 1  % si solo hay un punto centro=punto r=0

                xcentro=coordenadas(1,1);
                ycentro=coordenadas(1,2);
                zcentro=coordenadas(1,3);
                radio=0;

            case 2 % si hay dos puntos centro en la mitad, r por pitagoras

              %radio= segmento que une dos puntos cualquiera 

                a=coordenadas(pos1,:);
                b=coordenadas(pos2,:);
                [xcentro ycentro zcentro radio] = RadioSegmento(a,b);
                dos = true;

            case 3 % si hay tres puntos el centro estará donde se crucen las mediatrices de las rectas que se logran juntando los puntos 2 a 2

                a=coordenadas(1,:);
                b=coordenadas(2,:);
                c=coordenadas(3,:);
                [xcentro ycentro zcentro radio] = TresPuntos(a,b,c,normal);

            otherwise

                %mínimo círculo de entre todas las posibilidades 2 y 3

                %2) calcular los círculos que se definen con un segmento cualquiera.
                %el círculo mínimo será el de menor radio que contenga todos los
                %puntos. Será el círculo que definan los dos puntos más separados.


                [xcentro ycentro zcentro radio] = RadioSegmento(coordenadas(pos1,:),coordenadas(pos2,:));

                %comprobar que todos los puntos están dentro (si están all(distancias)==1)

                distancias = (((coordenadas(:,1)-xcentro)./radio).^2 + ((coordenadas(:,2)-ycentro)./radio).^2+((coordenadas(:,3)-zcentro)./radio).^2) <= 1;

                %3) calcular los círculos que se definen con tres puntos cualquiera.
                %el círculo mínimo será el de menor radio que contenga todos los
                %puntos

                dos = true;

                cont=1;

                if ~all(distancias)                                  


                    for i=1:(tamano(1)-2)
                        a=coordenadas(i,:);

                        for j=(i+1):(tamano(1)-1)

                            b=coordenadas(j,:);

                            for k=(j+1):tamano(1)

                                c=coordenadas(k,:);

                                [xc yc zc rc] = TresPuntos(a,b,c,normal);

                                 %comprobar si todos los puntos están dentro del círculo:
                                 %(x-xcentro)^2+(y-ycentro)^2+(z-zcentro)^2 < radio^2

                                 distancias= ((coordenadas(:,1)-xc).^2 + (coordenadas(:,2)-yc).^2+(coordenadas(:,3)-zc).^2) <= (rc^2 + eps);


                                 if all(distancias)

                                     centros_x(cont)= xc;
                                     centros_y(cont)= yc;
                                     centros_z(cont)= zc;
                                     centros_r(cont)= rc;

                                     cont=cont+1;



                                 end

                            end
                        end
                    end


                [minimo posicion]= min(centros_r); 

                xcentro=centros_x(posicion);
                ycentro=centros_y(posicion);
                zcentro=centros_z(posicion);

                radio=minimo;

                dos=false;

                end


        end


    else
        
        a=coordenadas(pos1,:);
        b=coordenadas(pos2,:);
        [xcentro ycentro zcentro radio] = RadioSegmento(a,b);
        
    
    end
    
    
end
