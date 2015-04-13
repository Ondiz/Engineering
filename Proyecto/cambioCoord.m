function [matriz_paso]= cambioCoord(n)

%CAMBIO DE COORDENADAS: Se pasa de un sistema de coordenadas XYZ a otro 
%donde z' = normal al plano,
%      x' y' pertenecen al plano.
%Datos: vector normal del plano (vector fila) -> n

n=n/norm(n); % Convertir n en unitario

a=[1 0 0];   % a -> cualquier vector (si se multiplica vectorialmente n por cualquier vector se consigue un vector que pertenece al plano)

if all(a == n)  % si a = n se coge otro a
    a = [0 0 1]; 
end

u= cross(n,a);   % se consigue un primer vector que pertenezca al plano
u= u/norm(u);    % unitario

v= cross(u,n);   % un segundo vector que pertenezca al plano
v= v/norm(v);    % unitario

matriz_paso= [u; v; n];





