% Placa rectangular (simply supported)    

clear
close all
clc

a = 1;
b = 1;

r = 4;

x = linspace(0,a,30);
y = linspace(0,b,30);

[X, Y] = meshgrid(x,y);
[filas, columnas] = size(X);


E = 210*10^9;
h = 0.01;
rhoPlaca = 7900;
nu = 0.3;

c = 344;
rho = 1.3;

n_Max = 2;
m_Max = 2;

sigma1 = zeros(n_Max,m_Max);
sigma2 = zeros(n_Max,m_Max);

sigmaComp = zeros(n_Max,m_Max);
relacion = zeros(n_Max,m_Max);

for n = 1:n_Max
    
    for m = 1:m_Max

        lambda = pi^2*(n^2+m^2*(a/b)^2);

        f = (lambda^2/(2*pi*a^2))*sqrt(E*h^2/(12*rhoPlaca*(1-nu^2))); % frecuencia del modo complejo
        
        f1 = f*1.01; % frecuencia del modo doble de menor f
        f2 = f*0.99; % frecuencia del modo doble de mayor f
        
        w = 2*pi*f;
        
        w1 = 2*pi*f1;
        w2 = 2*pi*f2;
        
        k = w/c;
        
        k1 = w1/c;
        k2 = w2/c;

        vMedia1 = 0;      
        vMedia2 = 0;
        
        vMediaComp = 0;

        P1 = 0;
        P2 = 0;
        
        Pcomp = 0;

        fil = 30;
        col = 30;

        theta = linspace(0,pi,fil);
        phi = linspace(-pi,pi,col);

        Pt1 = zeros(fil, col);
        Pt2 = zeros(fil, col);
        
        PtComp = zeros(fil,col);

        for t = 0:1/(50*f):(1/f) % un periodo

            % Modo real superior

            v1 = 0.001*sin(pi*m*X/a).*sin(pi*n*Y/b)*cos(w1*t); % distribución en el espacio para modo normal    
            vMedia1 = vMedia1 + v1.^2;
            
            % Modo real inferior
            
            v2 = 0.001*sin(pi*m*X/a).*sin(pi*n*Y/b)*cos(w2*t); % distribución en el espacio para modo normal    
            vMedia2 = vMedia2 + v2.^2;

            % Modo complejo

            vcomp = 0.001*sin(pi*m*X/a).*sin(pi*n*Y/b-w*t); % distribución en el espacio para modo complejo
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

                    Pt1(kont1, kont2)= (-i*k1*rho*exp(i*k1*r)*sum(sum(v1.*exp(i*(alfa*X/a+beta*Y/b))))/(filas*columnas))/(2*pi); 
                    Pt2(kont1, kont2)= (-i*k2*rho*exp(i*k2*r)*sum(sum(v2.*exp(i*(alfa*X/a+beta*Y/b))))/(filas*columnas))/(2*pi); 

                    % Cálculo de P modo complejo en un punto del campo lejano en el
                    % instante de tiempo t
                    PtComp(kont1, kont2)= (-i*k*rho*exp(i*k*r)*sum(sum(vcomp.*exp(i*(alfa*X/a+beta*Y/b))))/(filas*columnas))/(2*pi);


                end
            end

            % Cálculo de presión

            P1 = P1 + abs(Pt1.^2); 
            P2 = P2 + abs(Pt2.^2); 
            
            Pcomp = Pcomp + abs(PtComp.^2);


        end

        vMedia1 = vMedia1/length(t);
        vMedia2 = vMedia2/length(t);
        
        vMediaComp = vMediaComp/length(t);

        vMedia1 = sum(sum(vMedia1))/(filas*columnas); % velocidad media modo normal
        vMedia2 = sum(sum(vMedia2))/(filas*columnas); % velocidad media modo normal
        
        vMediaComp = sum(sum(vMediaComp))/(filas*columnas); % velocidad media modo complejo


        % rms de la presión

        P1 = sqrt(P1/length(t));
        P2 = sqrt(P2/length(t));
        
        Pcomp = sqrt(Pcomp/length(t));

        PMedia1 = sum(sum(P1))/(fil*col);
        PMedia2 = sum(sum(P2))/(fil*col);
        
        PMediaComp = sum(sum(Pcomp))/(fil*col);


        % Cálculo de potencia

        W1 = sum(sum(P1.^2/(2*rho*c)))*fil*col; % número de puntos donde se mide presión
        W2 = sum(sum(P2.^2/(2*rho*c)))*fil*col; % número de puntos donde se mide presión
        
        WComp = sum(sum(Pcomp.^2/(2*rho*c)))*fil*col;

        % Relación entre radiación sonora de modo complejo y real

        sigma1(n,m) = W1/(rho*c*a*b*vMedia1); % eficiencia de la radiación 
        sigma2(n,m) = W2/(rho*c*a*b*vMedia2); % eficiencia de la radiación 
        
        sigmaComp(n,m) = WComp/(rho*c*a*b*vMediaComp);

    end
end
