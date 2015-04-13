% Modos de placa circular (sin diámetros nodales)

clear
clc
close all


% Modo

R = 1;

trozos = 50;

%lambda = [0 0 5.253 12.23; 9.084 20.52 35.25 52.91; 38.55 59.86 83.9 111.3; 87.8 119 154 192.1];

n = 5;
m = 0; % esto ahora mismo no afecta en nada

%omega = lambda(n,m)^2*sqrt(E/(12*rho*h^3*(1-nu^2)))/R^2;
omega = 0.03;

C1 = 1;
C2 = 1;

[r,phi] = meshgrid(linspace(0,R,trozos),linspace(0,2*pi,trozos));

%xi = lambda(m+1,n+1)*r;

xi = r;

for t=1:100

    W = (C1*besselj(n,xi)+C2*besseli(n,xi));
    
    W = W/norm(W).*sin(n*phi)*sin(2*pi*omega*t);

    surf(r.*cos(phi),r.*sin(phi),W)
    axis([-R R -R R -0.1 0.1])
    drawnow 

end

close

figure


for t=1:300

    W = (C1*besselj(n,xi)+C2*besseli(n,xi));
    
    W = W/norm(W).*sin(n*phi-omega*t);

    surf(r.*cos(phi),r.*sin(phi),W)
    axis([-R R -R R -0.1 0.1])
    drawnow 

end

close

%{

w = 2*pi;
c = 344;
rho = 1.3;
k = w/c;

vMedia = 0;
vMediaComp = 0;


P = 0;
Pcomp = 0;

fil = 30;
col = 30;

theta = linspace(0,pi,fil);
phi = linspace(-pi,pi,col);

Pt = zeros(fil, col);
PtComp = zeros(fil,col);

radio = 40;


for t = 0:1/100:1 % un periodo porque w=2*pi
    
    % Modo real
    
    v = (C1*besselj(n,xi)+C2*besseli(n,xi)).*sin(n*phi)*sin(w*t); % distribución en el espacio para modo normal    
    vMedia = vMedia + v.^2;
    
    % Modo complejo
    
    vcomp = (C1*besselj(n,xi)+C2*besseli(n,xi)).*sin(n*phi-w*t); % distribución en el espacio para modo complejo
    vMediaComp = vMediaComp + vcomp.^2;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Cálculo de presión
    
    % calcular presión en esfera a R a partir de valores de velocidad en
    % superficie
    
    for kont1 = 1:length(theta)
        
        for kont2 = 1:length(phi)
           
            
            % Cálculo de P modo real en un punto del campo lejano en el
            % instante de tiempo t
            
            Pt(kont1, kont2)= (-i*k*rho*exp(i*k*radio)*sum(sum(v.*exp(i*(alfa*X/a+beta*Y/b))))/(filas*columnas))/(2*pi); 
            
            % Cálculo de P modo complejo en un punto del campo lejano en el
            % instante de tiempo t
            PtComp(kont1, kont2)= (-i*k*rho*exp(i*k*radio)*sum(sum(vcomp.*exp(i*(alfa*X/a+beta*Y/b))))/(filas*columnas))/(2*pi);
                      
            
        end
    end
    
    % Cálculo de presión

    P = P + abs(Pt.^2);
    Pcomp = Pcomp + abs(PtComp.^2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
end

[filas, columnas] = size(r);

vMedia = vMedia/length(t);
vMediaComp = vMediaComp/length(t);

vMedia = sum(sum(vMedia))/(filas*columnas); % velocidad media modo normal
vMediaComp = sum(sum(vMediaComp))/(filas*columnas); % velocidad media modo complejo

fprintf('V_media modo normal = %e\n', vMedia)
fprintf('V_media modo complejo = %e\n', vMediaComp)
fprintf('Relación = %f\n', vMediaComp/vMedia)


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
%}












