% Placa rectangular (simply supported)

clear
close all
clc

% a = 10;
% b = 20;

% a = 10;
% b = 30;

a = 10;
b = 10;

x = linspace(0,a,30);
y = linspace(0,b,30);

[X, Y] = meshgrid(x,y);
[filas, columnas] = size(X);

n = 1; % el desfase está aquí
m = 1;

%Z = sin(pi*m*X/a).*sin(pi*n*Y/b);

figure

w = 2*pi;
c = 344;
rho = 1.3;
k = w/c;

for t = 0:1/100:1
    
    %surf(X,Y,sin(pi*m*X/a).*sin(pi*n*Y/b)*real(exp(i*phi)));
    
    Z = sin(pi*m*X/a).*sin(pi*n*Y/b)*cos(w*t); % distribución en el espacio para modo normal
    
    surf(X,Y,Z);
    axis([0 a 0 b -1 1])
    drawnow
    
    
end

figure

for t = 0:1/100:1
    
    Z = sin(pi*m*X/a).*sin(pi*n*Y/b-w*t); % distribución en el espacio para modo complejo
    
    surf(X,Y,Z);
    drawnow

end