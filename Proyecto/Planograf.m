function Planograf (sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS, CTES)

% Planograf (sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS, CTES) 
% Se representa gr�ficamente la evoluci�n de los componentes de tensi�n en
% el tiempo. Se aplican y dibujan el criterio del c�rculo y de la elipse

% TENSOR DE TENSIONES, importar

%sigma= [sigma_xx  tau_xy  tau_xz; tau_xy sigma_yy tau_yz; tau_xz tau_yz sigma_zz];

% Limite de los planos

tension = [sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz ];
LIM= max(max(tension)) ; % ajustar

clear tension
clear a 

% Paso

paso= LIM / 20;

%Inicializar matrices:

SIGMAN=zeros(MUESTRAS,1);
TAU= zeros(MUESTRAS,3);


% DEFINIR UNA DIRECCI�N (vector columna)

% meter la opci�n de los �ngulos con un case y VectorNormal (poner vector con los �ngulos y vector normal con el mismo tama�o 3x1 o 1x3 
% para poder poner ambos dentro del mismo while-if)

novector = true;

while novector     % ~ estructura do while

    n=input('Introduzca el vector normal del plano a analizar (vector columna): \n');

    if size(n)== [3 1]
   
        novector= ~novector;
        
    else
        
        fprintf('No es v�lido \n')
        
    end
   

end

n=n/norm(n);   

figure(1)

axis tight
axis equal
    
for j=1:MUESTRAS   % Meter todo esto en una funci�n [movie, TAU]= function(n, sigma)
    
   
    % Plano definido por la normal Ax+By+Cz+D=0 para que pase por el punto
    % (0,0,0) D=0

    axis tight
    
    if n(3)~=0
        
        [x,y] = meshgrid(-LIM:paso:LIM, -LIM:paso:LIM);  %cambiar estos l�mites seg�n valor de sigma                              
        z=(-n(1)*x-n(2)*y)/n(3);                                      
        surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)

    else 
        if n(1)~=0
            
            [y,z] = meshgrid(-LIM:paso:LIM, -LIM:paso:LIM);  %cambiar estos l�mites seg�n valor se sigma                              
            x=(-n(2)*y-n(3)*z)/n(1);                                      
            surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)
            
        else
            
            [x,z] = meshgrid(-LIM:paso:LIM, -LIM:paso:LIM);  %cambiar estos l�mites seg�n valor se sigma                              
            y=(-n(1)*x-n(3)*z)/n(2);                                      
            surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)

        end
    
    end 
    
    hold on

    % Dibujar el vector normal

    quiver3(0,0,0,n(1),n(2),n(3),2,'LineWidth',1)

    
    % IMPORTADA DE EXCEL
    
    sigma= [sigma_xx(j)  tau_xy(j)  tau_xz(j); tau_xy(j)  sigma_yy(j)  tau_yz(j); tau_xz(j)  tau_yz(j) sigma_zz(j)];
    
    
    % Tensi�n normal

    sigma_n = sigma * n;  % vector columna

    % Dibujar tensi�n normal sigma_n

    quiver3(0,0,0,sigma_n(1),sigma_n(2),sigma_n(3),'LineWidth',2,'Color','r')


    % Componente perpendicular al plano 

    sigma_nn = sigma_n' * n;
    vecsigma_nn=sigma_nn*n;
    
    % Guardar valor tensi�n normal (vector, cada componente es un sigma)
    
    SIGMAN(j)= sigma_nn;

    % Dibujar sigma_nn

    quiver3(0,0,0,vecsigma_nn(1),vecsigma_nn(2),vecsigma_nn(3),'LineWidth',2,'Color','g')


    % Componente tangencial:

    tau_nt = sigma_n - vecsigma_nn;
    
    % Guardar valor de tau (matriz, cada fila es un tau):
    
    TAU (j,:) = tau_nt;

    %Dibujar componente tangencial tau_nt

    quiver3(0,0,0,tau_nt(1),tau_nt(2),tau_nt(3),'LineWidth',2,'Color','magenta')
    
    F(j)=getframe;
    pause(0.1)  % pause(periodo/n�mero de muestras  ~ tiempo real)
    
    % hacer que se elimine lo que est�
    hold off
    
end

movie(F,1);   

% Convertir en .avi 

% movie2avi(F,'plano_critico')


% Leyenda

    h = legend('Plano','n','\sigma_n','\sigma_{nn}','\tau_{nt}',2);
    set(h,'Interpreter','tex')  % Para que detecte caracteres TEX


%Dibujar trayectoria de tau:

    hold on

    scatter3(TAU(:,1),TAU(:,2),TAU(:,3), 'filled') % puntos por los que pasa

    plot3(TAU(:,1),TAU(:,2),TAU(:,3)) %trayectoria, cuando sea c�clica no se mezclar�


% -------------------------------------------------------------------------


% C�RCULO

    %Criterio:
    %la m�nima circunferencia circunscrita a un pol�gono plano es, o bien uno de 
    %los c�rculos dibujados con un di�metro igual al segmento de l�nea que une dos 
    %v�rtices cualesquiera, o una de las circunferencias de entre todas las que se 
    %pueden construir mediante tres v�rtices cualesquiera del pol�gono

    [pos1 pos2]=MaximoSegmento(TAU); % los dos puntos que definen el eje grande de la elipse
    
    [xcentro ycentro zcentro radio dos] = MinimoCirculo(TAU,n', pos1, pos2);
    

%ELIPSE 

    % calcular b teniendo en cuenta que
    % ((x-xcentro)/a)^2+((y-ycentro)/b)^2=1
    % para todos los puntos. Quedarse con el b minimo con el que todos los puntos est�n dentro

    
    %CAMBIO DE COORDENADAS 

    paso = cambioCoord(n');
    TAU_nuevo= paso * TAU'; %pasa los puntos al nuevo sistema de coordenadas (deber�an tener todos z=0)
    
    TAU_nuevo=TAU_nuevo';
    
    centro_nuevo= paso* [xcentro; ycentro; zcentro];
    
     
    % dibujar plano
    
    amax = max(abs(TAU_nuevo));
    
    LIM = amax(1)* 2;
    
    DibujaPlano([0 0 1],2, LIM)
    
    scatter3(TAU_nuevo(:,1),TAU_nuevo(:,2),TAU_nuevo(:,3), 'filled') % puntos por los que pasa

    plot3(TAU_nuevo(:,1),TAU_nuevo(:,2),TAU_nuevo(:,3)) %trayectoria
    
    scatter3(centro_nuevo(1), centro_nuevo(2), centro_nuevo(3), 'y','Filled')
    
    
    
    if dos   % si el circulo pasa por solo por dos puntos  -> ERROR
    
        punto1 = TAU_nuevo(pos1,:);
        punto2 = TAU_nuevo(pos2,:);
    
        grados= atan((punto2(2)- punto1(2))/(punto2(1)- punto1(1)));  % radianes
        
        % Calcula el angulo entre la horizontal y la recta que forman los puntos m�s alejados. 
        % Negativo significa que hay que girar en sentido contrario a las agujas del reloj 
    
        %Cambio de coordenadas a los ejes de la elipse
        
        paso= Giro(grados,'z');
        
        TAU_nuevo = paso* TAU_nuevo';
        TAU_nuevo = TAU_nuevo'; % para que las coordenadas sean filas
        centro_elipse= paso* centro_nuevo; % dato para calcular b, pero no para dibujar
        
        %Calcular eje peque�o de la elipse 

        b = Elipse(TAU_nuevo, centro_elipse(1), centro_elipse(2), radio); % funciona con ejes de la elipse paralelos a ejes coordenados 

    end

            
            
    % REPRESENTACION GRAFICA
  
        
    % representar el CIRCULO en el plano perpendicular
    
    DibujaElipseParam(centro_nuevo(1), centro_nuevo(2), 0, radio, radio)
    
    hold on
    
    % Dibujar ELIPSE  -> ERROR

    if dos
        
       DibujaElipseParam(centro_nuevo(1), centro_nuevo(2), grados, radio, b)
    
    else
        
        disp('El c�rculo y la elipse coinciden') % si el circulo pasa por tres puntos, c�rculo y elipse coinciden
        b = radio;
        
    end

     

%TAU MEDIA = DISTANCIA CENTRO DEL C�RCULO/ELIPSE A CERO

tau_media = norm([xcentro,ycentro,zcentro]);
disp(['Tension cortante media: ', num2str(tau_media)])

disp(['Tensi�n cortante variable (seg�n criterio del c�rculo): ',num2str(radio)]) 

% Tensi�n variable en el criterio de la elipse

tau_r_elipse = sqrt(b^2 + radio^2);
disp(['Tensi�n cortante variable (seg�n criterio de la elipse): ',num2str(tau_r_elipse)])


% TENSION NORMAL

sigma_m = (max(SIGMAN) + min(SIGMAN))/2;
sigma_r = (max(SIGMAN) - min(SIGMAN))/2;

% Criterios

Criterios(sigma_m, sigma_r, radio, n , CTES)

end






 


