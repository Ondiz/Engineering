function Calculo(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS, CTES)

tic

% TENSOR DE TENSIONES

%sigma= [sigma_x  tau_xy  tau_xz; tau_xy  sigma_y  tau_yz; tau_xz  tau_yz
%sigma_z];

% N: matriz cuyas columnas son los diferentes vectores n

% TIENE PROBLEMAS NUMÉRICOS EN LOS CASOS PARTICULARES

fprintf('CÁLCULO DEL PLANO CRÍTICO \n ') % poner planos por defecto

            
angulos= [90 180 90 ; 90 135 45; 45 135 90; -45 -135 45]; % Cada fila representa los angulos que forma la normal del plano con los ejes x,y,z


% los cuatro planos de referencia

angulos= angulos';  % Para que los vectores normales sean columnas

N = cosd(angulos);
            
% Número de vectores normales

NUMVEC = 4;
DELTA = 30; % delta_theta: paso entre dos posiciones -> CON MENOS DE 30º OUT OF MEMORY

posiciones = 180/DELTA * 3;


% Giro alrededor de z:

matriz_giro = Giro(deg2rad(DELTA),'z'); % matriz que gira DELTA grados alrededor de z

for i = 1: 180/DELTA 

    M = matriz_giro*N;
    N = [N M];

end

% Giro alrededor de x:

matriz_giro = Giro(deg2rad(DELTA),'x'); % matriz que gira DELTA grados alrededor de z

for i = 1: 180/DELTA 

    M = matriz_giro*N;
    N = [N M];

end


% Giro alrededor de y:

matriz_giro = Giro(deg2rad(DELTA),'y'); % matriz que gira DELTA grados alrededor de z

for i = 1: 180/DELTA 

    M = matriz_giro*N;
    N = [N M];

end


%****************Inicializar matrices ******************

circulos= zeros(NUMVEC * posiciones, 4);
tau_media= zeros(NUMVEC * posiciones ,1);

TAU= zeros(MUESTRAS,3);
SIGMAN= zeros(MUESTRAS,1);

SIGMAN_M = zeros(NUMVEC * posiciones, 1);
SIGMAN_R = zeros(NUMVEC * posiciones, 1);
EjesPeq =  zeros(NUMVEC * posiciones, 1);


%********************************************************


for i= 1 : NUMVEC*posiciones  % número de columnas de N 

 n = N(:,i);
 n = n/norm(N(:,i));   
    
    
    for j=1:MUESTRAS

        
        %Matriz de tensiones importada
        
         sigma= [sigma_xx(j)  tau_xy(j)  tau_xz(j); tau_xy(j)  sigma_yy(j)  tau_yz(j); tau_xz(j)  tau_yz(j) sigma_zz(j)];
        

        % tension normal

        sigma_n = sigma * n;  % vector columna


        % componente perpendicular al plano

        sigma_nn = sigma_n' * n;
        vecsigma_nn=sigma_nn*n;

        %Guardar valor tensión normal (vector cuyos elementos son sigma_normal)

        SIGMAN(j)= sigma_nn;


        % Componente tangencial:

        tau_nt = sigma_n - vecsigma_nn;

        % Guardar valor de tau (matriz, cada fila es un tau):

        TAU (j,:) = tau_nt;

    end

    
    % TENSION NORMAL  (para criterios)   
    
    % CON TENSIONES TIPO SINUSOIDAL, NO RANDOM !!!

    sigma_max = max(SIGMAN);
    sigma_min = min(SIGMAN);

    SIGMAN_M(i) = (sigma_max(1) + sigma_min(1))/2;  % tensión normal media

    SIGMAN_R(i) = (sigma_max(1) - sigma_min(1))/2; % tensión normal variable
    
    

    % CALCULAR TODOS LOS CÍRCULOS
    
    % CÍRCULO

        [pos1 pos2] = MaximoSegmento(TAU); % los dos puntos que definen el eje grande de la elipse
    
        [xcentro ycentro zcentro radio dos] = MinimoCirculo(TAU, n', pos1, pos2);
         
        circulos(i,:)= [xcentro, ycentro, zcentro, radio];

    %TAU MEDIA = DISTANCIA CENTRO DEL CÍRCULO/ELIPSE A CERO

        tau_media(i,:)= norm([xcentro,ycentro,zcentro]);  
        
        
    % CALCULO DE LAS ELIPSES
    
    if dos
        
        paso= cambioCoord(n');
        TAU_nuevo= paso * TAU'; %pasa los puntos al nuevo sistema de coordenadas (deberían tener todos z=0)
        TAU_nuevo=TAU_nuevo';
        centro_nuevo= paso* [xcentro; ycentro; zcentro];
    
        
        punto1 = TAU_nuevo(pos1,:);
        punto2 = TAU_nuevo(pos2,:);
    
        grados= atan((punto2(2)- punto1(2))/(punto2(1)- punto1(1)));  % radianes
        paso= Giro(grados,'z');
        
        TAU_nuevo = paso* TAU_nuevo';
        TAU_nuevo = TAU_nuevo'; % para que las coordenadas sean filas
        centro_elipse= paso* centro_nuevo; 
        
        %Calcular eje pequeño de la elipse 

        b = Elipse(TAU_nuevo, centro_elipse(1), centro_elipse(2), radio); 
        
        EjesPeq(i)= b ; 
        
    end
    
    
end


fprintf('\n Tensión cortante variable máxima en los planos (círculo) \n')

    radios=circulos(:,4);
    disp(num2str(radios))

fprintf('\n Tensión cortante variable máxima en los planos (elipse) \n')  
   
    EjesPeq(EjesPeq==0)= radios(EjesPeq==0); % si b=0 (el circulo pasa por tres puntos), sustituir ese valor por el radio
    tau_r_elipse=(EjesPeq.^2 + radios.^2).^0.5;
    
    disp(tau_r_elipse)


fprintf('\n Tensión cortante media en los planos \n')

    disp(num2str(tau_media))


% TENSION NORMAL  

fprintf('\n Tensión normal media en los planos \n')

    disp(num2str(SIGMAN_M))

fprintf('\n Tensión normal variable en los planos \n')

    disp(num2str(SIGMAN_R))
    
    

% CRITERIOS

    fprintf('\n  CRITERIOS \n')

% Plano de mayor tensión cortante variable (mayor radio del círculo)

    [tau_crit pos] = max(radios);

    fprintf('\n CÍRCULO \n El plano de mayor tensión cortante variable es el de normal:\n')

    n = N(:,pos);
    n = n/norm(n);

    disp(num2str(n));

    disp(['con una tensión cortante variable de ',num2str(tau_crit)])
    
    
% Elipse
% si elipse = circulo, valor de elipse = circulo * sqrt(2)

    [tau_crit pos] = max(tau_r_elipse);

    fprintf('\n ELIPSE \n El plano de mayor tensión cortante variable es el de normal:\n')

    n = N(:,pos);
    n = n/norm(n);

    disp(num2str(n));

    disp(['con una tensión cortante variable de ',num2str(tau_crit)])

% Criterios

    Criterios(SIGMAN_M, SIGMAN_R, radios , N, CTES)
    
    toc


end











