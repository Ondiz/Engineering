function VonMises(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS, CTES)

    % VonMises(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz,
    % MUESTRAS, CTES)
    % Calcula la tension equivalente de VonMises-Goodman y Goodman-VonMises
    % necesita los datos del tensor de tensiones para los instantes de
    % tiempo, el número de muestras y los datos del material

    % Tensión de rotura ingenieril

    sigma_ut = CTES(3);

    % Inicializar matrices:
    
    tension_princ = zeros(3, MUESTRAS); % matriz cuyas columnas son las tensiones principales en cada instante de tiempo
    
    % MATLAB ORDENA LAS TENSIONES DE MENOR A MAYOR, POR LO QUE EN UN CASO UNIAXIAL
    % UNA TENSIÓN EMPIEZA SIENDO SIGMA_3 Y PASA A SER SIGMA_1
    % Y CALCULA MAL LAS TENSIONES MEDIAS Y VARIABLES 
    
    % Para evitarlo:
    
    % Como las tensiones principales no pueden variar para que enfoque
    % global funcione, se calcula para el primer punto la tensiones
    % principales y las direcciones principales y con estos vectores
    % principales se calculan el resto de tensiones principales.
    
    sigma= [sigma_xx(2)  tau_xy(2)  tau_xz(2); tau_xy(2)  sigma_yy(2)  tau_yz(2); tau_xz(2)  tau_yz(2) sigma_zz(2)];
    
    [vectores_princ tens_princ]= eig(sigma);
    
    
    for j=1:MUESTRAS
        
       % calcular tensiones principales       
       
       sigma= [sigma_xx(j)  tau_xy(j)  tau_xz(j); tau_xy(j)  sigma_yy(j)  tau_yz(j); tau_xz(j)  tau_yz(j) sigma_zz(j)];
       
       tens_princ = vectores_princ' * sigma* vectores_princ;
       
       tens_princ = [tens_princ(1,1); tens_princ(2,2); tens_princ(3,3)];
       
       tension_princ(:,j)= tens_princ;
       
    end

    % Tensión principal 1:

    sigma_1_m = (max(tension_princ(1,:))+ min(tension_princ(1,:)))/2 ;
    sigma_1_r = (max(tension_princ(1,:))- min(tension_princ(1,:)))/2 ;

    % Tensión principal 2:

    sigma_2_m = (max(tension_princ(2,:))+ min(tension_princ(2,:)))/2 ;
    sigma_2_r = (max(tension_princ(2,:))- min(tension_princ(2,:)))/2 ;

    % Tensión principal 3:

    sigma_3_m = (max(tension_princ(3,:))+ min(tension_princ(3,:)))/2 ;
    sigma_3_r = (max(tension_princ(3,:))- min(tension_princ(3,:)))/2 ;

    % GOODMAN - VON MISES:

    % Goodman: sigma_eq = sigma_r /(1 - sigma_m / sigma_ut)

    sigma_1_eq = sigma_1_r /(1 - sigma_1_m / sigma_ut) ;
    sigma_2_eq = sigma_2_r /(1 - sigma_2_m / sigma_ut) ;
    sigma_3_eq = sigma_3_r /(1 - sigma_3_m / sigma_ut) ;


    % Tensión equivalente de Von Mises

    sigma_GM = sqrt(1/2*((sigma_1_eq - sigma_2_eq)^2 + (sigma_1_eq - sigma_3_eq)^2 +(sigma_2_eq -sigma_3_eq)^2));


    % Criterio de signos Von Mises: 
    % si sigma_1 + sigma_2 + sigma_3 < 0 -> sigma_eq = -sigma_eq 

    if (sigma_1_eq + sigma_2_eq + sigma_3_eq < 0)

        sigma_GM = - sigma_GM ; 

    end

    % VON MISES - GOODMAN:

    % Von Mises

    sigma_eq_m = sqrt(1/2*((sigma_1_m - sigma_2_m)^2 + (sigma_1_m - sigma_3_m)^2 +(sigma_2_m -sigma_3_m)^2));

    if (sigma_1_m + sigma_2_m + sigma_3_m < 0)

        sigma_eq_m = - sigma_eq_m ; 

    end

    sigma_eq_r = sqrt(1/2*((sigma_1_r - sigma_2_r)^2 + (sigma_1_r - sigma_3_r)^2 +(sigma_2_r -sigma_3_r)^2));

    if (sigma_1_r + sigma_2_r + sigma_3_r < 0)

        sigma_eq_r = - sigma_eq_r ; 

    end

    % Goodman

    sigma_MG = sigma_eq_r /(1 - sigma_eq_m / sigma_ut) ;

    fprintf('\n Tensión equivalente Von Mises - Goodman %f \n', sigma_MG)
    fprintf('Tensión equivalente Goodman - Von Mises %f \n', sigma_GM)


end