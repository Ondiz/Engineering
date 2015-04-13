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

n = 2; % el desfase está aquí
m = 4;

w = 2*pi;
c = 344;
rho = 1.3;
k = w/c;

vMedia = 0;
vMediaComp = 0;

P = 0;
Pcomp = 0;

R = 40;

fil = 30;
col = 30;

theta = linspace(0,pi,fil);
phi = linspace(-pi,pi,col);

Pt = zeros(fil, col);
PtComp = zeros(fil,col);

r = 40;

for t = 0:1/50:1 % un periodo porque w=2*pi
    
    % Modo real
    
    v = sin(pi*m*X/a).*sin(pi*n*Y/b)*cos(w*t); % distribución en el espacio para modo normal    
    vMedia = vMedia + v.^2;
    
    % Modo complejo
    
    vcomp = sin(pi*m*X/a).*sin(pi*n*Y/b-w*t); % distribución en el espacio para modo complejo
    vMediaComp = vMediaComp + vcomp.^2;
    
    % Cálculo de presión
    
    % calcular presión en esfera a R a partir de valores de velocidad en
    % superficie
    
    for kont1 = 1:length(theta)
        
        for kont2 = 1:length(phi)
            
            alfa = k*a*sin(theta(kont1))*cos(phi(kont2));
            beta = k*b*sin(theta(kont1))*sin(phi(kont2));
            
            % Cálculo de P modo real en un punto del campo lejano en el
            % instante de tiempo t
            
            Pt(kont1, kont2)= (-i*k*rho*exp(i*k*r)*sum(sum(v.*exp(i*(alfa*X/a+beta*Y/b))))/(filas*columnas))/(2*pi); 
            
            % Cálculo de P modo complejo en un punto del campo lejano en el
            % instante de tiempo t
            PtComp(kont1, kont2)= (-i*k*rho*exp(i*k*r)*sum(sum(vcomp.*exp(i*(alfa*X/a+beta*Y/b))))/(filas*columnas))/(2*pi);
                      
            
        end
    end
    
    % Cálculo de presión

    % P = P + abs(Pt.^2); 
    % Pcomp = Pcomp + abs(PtComp.^2);
    
    % pintar las presiones

    h1 = subplot(1,2,1); sphere3d(abs(Pt),0,2*pi,-pi/2,pi/2,r,0.4,'surf','spline'); title('Distribución de presiones para modos normales')
    h2 = subplot(1,2,2); sphere3d(abs(PtComp),0,2*pi,-pi/2,pi/2,r,0.4,'surf','spline'); title('Distribución de presiones para modos complejos')
    
    drawnow
    
        

end

