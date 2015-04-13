function [matriz_paso]= CambioPlanoPerpendicular(n)

%CAMBIO DE COORDENADAS: Se pasa de un sistema de coordenadas XYZ a otro 
%donde z = normal al plano, X' Y' pertenecen al plano.
%Datos: vector normal del plano (vector fila)
% SE DIBUJAN LOS PLANOS

n=n/norm(n);

a=[1 0 0];

if all(a == n)
    a = [0 0 1];
end

u= cross(n,a);
u= u/norm(u);

v= cross(u,n);
v= v/norm(v);

if n(3)~=0
        
        [x,y] = meshgrid(-10:.5:10, -10:.5:10);  %cambiar estos límites según valor de sigma                              
        z=(-n(1)*x-n(2)*y)/n(3);                                      
        surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)

    else 
        if n(1)~=0
            
            [y,z] = meshgrid(-10:.5:10, -10:.5:10);  %cambiar estos límites según valor se sigma                              
            x=(-n(2)*y-n(3)*z)/n(1);                                      
            surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)
            
        else
            
            [x,z] = meshgrid(-10:.5:10, -10:.5:10);  %cambiar estos límites según valor se sigma                              
            y=(-n(1)*x-n(3)*z)/n(2);                                      
            surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)

        end
    
end 
    
hold on

axis equal

quiver3(0,0,0,n(1),n(2),n(3))
quiver3(0,0,0,u(1),u(2),u(3))
quiver3(0,0,0,v(1),v(2),v(3))

matriz_paso= [u; v;n];

% Comprobación de que se pasa a un plano z'=0

nuevo_n = matriz_paso*n';

figure(2)
hold on

if nuevo_n(3)~=0
        
        [x,y] = meshgrid(-10:.5:10, -10:.5:10);  %cambiar estos límites según valor de sigma                              
        z=(-nuevo_n(1)*x-nuevo_n(2)*y)/nuevo_n(3);                                      
        surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)

    else 
        if n(1)~=0
            
            [y,z] = meshgrid(-10:.5:10, -10:.5:10);  %cambiar estos límites según valor se sigma                              
            x=(-nuevo_n(2)*y-nuevo_n(3)*z)/nuevo_n(1);                                      
            surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)
            
        else
            
            [x,z] = meshgrid(-10:.5:10, -10:.5:10);  %cambiar estos límites según valor se sigma                              
            y=(-nuevo_n(1)*x-nuevo_n(3)*z)/nuevo_n(2);                                      
            surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)

        end
        
end

quiver3(0,0,0,nuevo_n(1),nuevo_n(2),nuevo_n(3))


