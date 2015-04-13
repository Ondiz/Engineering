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

close all

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

for t = 0:1/100:1 % un periodo porque w=2*pi
    
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

    P = P + abs(Pt.^2); % ESTO ES MÓDULO???
    Pcomp = Pcomp + abs(PtComp.^2);
        

end

vMedia = vMedia/length(t);
vMediaComp = vMediaComp/length(t);

vMedia = sum(sum(vMedia))/(filas*columnas); % velocidad media modo normal
vMediaComp = sum(sum(vMediaComp))/(filas*columnas); % velocidad media modo complejo

fprintf('V_media modo normal = %f\n', vMedia)
fprintf('V_media modo complejo = %f\n', vMediaComp)

% rms de la presión

P = sqrt(P/length(t));
Pcomp = sqrt(Pcomp/length(t));

PMedia = sum(sum(P))/(fil*col);
PMediaComp = sum(sum(Pcomp))/(fil*col);

fprintf('P_rms_media modo normal = %f\n', PMedia)
fprintf('P_rms_media modo complejo = %f\n', PMediaComp)

% pintar las presiones

sphere3d(P,0,2*pi,-pi/2,pi/2,r,0.4,'surf','spline'); title('Distribución de presiones para modos normales')

figure
sphere3d(Pcomp,0,2*pi,-pi/2,pi/2,r,0.4,'surf','spline'); title('Distribución de presiones para modos complejos')

% Cálculo de potencia

W = sum(sum(P.^2/(2*rho*c)))*fil*col; % número de puntos donde se mide presión
WComp = sum(sum(Pcomp.^2/(2*rho*c)))*fil*col;

% Relación entre radiación sonora de modo complejo y real

sigma = W/(rho*c*a*b*vMedia); % eficiencia de la radiación por rho_0*S*c, que es igual para ambos casos
sigmaComp = WComp/(rho*c*a*b*vMediaComp);

fprintf('sigma modo normal = %f\n', sigma)
fprintf('sigma modo complejo = %f\n', sigmaComp)

relacion = sigma/sigmaComp;

fprintf('sigma/sigmaComp = %f\n', relacion)




