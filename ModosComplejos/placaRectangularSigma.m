% Placa rectangular (simply supported). Complejos en n. 
% El modo los n y m-s de aquí representan n+1 y m+1, porque no se puede
% empezar en cero.

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

n_Max = 10;
m_Max = 1;

sigma = zeros(n_Max,m_Max);
sigmaComp = zeros(n_Max,m_Max);
relacion = zeros(n_Max,m_Max);

for n = 1:n_Max
    
    for m = 1:m_Max

        lambda = pi^2*(n^2+m^2*(a/b)^2);

        f = (lambda^2/(2*pi*a^2))*sqrt(E*h^2/(12*rhoPlaca*(1-nu^2))); 
        w = 2*pi*f;
        
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

        for t = 0:1/50:1 % cambiar a un periodo

            % Modo real

            v = 0.001*sin(pi*m*X/a).*sin(pi*n*Y/b)*cos(w*t); % distribución en el espacio para modo normal    
            vMedia = vMedia + v.^2;

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

                    Pt(kont1, kont2)= (-i*k*rho*exp(i*k*r)*sum(sum(v.*exp(i*(alfa*X/a+beta*Y/b))))/(filas*columnas))/(2*pi); 

                    % Cálculo de P modo complejo en un punto del campo lejano en el
                    % instante de tiempo t
                    PtComp(kont1, kont2)= (-i*k*rho*exp(i*k*r)*sum(sum(vcomp.*exp(i*(alfa*X/a+beta*Y/b))))/(filas*columnas))/(2*pi);


                end
            end

            % Cálculo de presión

            P = P + abs(Pt.^2); 
            Pcomp = Pcomp + abs(PtComp.^2);


        end

        vMedia = vMedia/length(t);
        vMediaComp = vMediaComp/length(t);

        vMedia = sum(sum(vMedia))/(filas*columnas); % velocidad media modo normal
        vMediaComp = sum(sum(vMediaComp))/(filas*columnas); % velocidad media modo complejo


        % rms de la presión

        P = sqrt(P/length(t));
        Pcomp = sqrt(Pcomp/length(t));

        PMedia = sum(sum(P))/(fil*col);
        PMediaComp = sum(sum(Pcomp))/(fil*col);


        % Cálculo de potencia

        W = sum(sum(P.^2/(2*rho*c)))*fil*col; % número de puntos donde se mide presión
        WComp = sum(sum(Pcomp.^2/(2*rho*c)))*fil*col;

        % Relación entre radiación sonora de modo complejo y real

        sigma(n,m) = W/(rho*c*a*b*vMedia); % eficiencia de la radiación por rho_0*S*c, que es igual para ambos casos
        sigmaComp(n,m) = WComp/(rho*c*a*b*vMediaComp);

        relacion(n,m) = sigma(n,m)/sigmaComp(n,m);

    end
end


bar(relacion)
xlim([0 n_Max])
hold on
plot([0,n_Max],[1,1],'r')
