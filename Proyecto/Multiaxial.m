% MULTIAXIAL

% Se importan los datos de un archivo excel con formato 'nombre.xls'
% En este archivo las componentes de la tensi�n son columnas, empezando por
% la segunda columna, y en el orden sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz
%
% Calcula la tensi�n equivalente de VonMises, de Sines o de Crossland,
% el plano critico entre varios planos dados (llama a 'calculo') o representa
% gr�ficamente las tensiones en un plano en el tiempo y calcula el m�nimo
% c�rculo y la m�nima elipse que circunscriben la trayectoria de la tensi�n
% cortante (llama a 'planograf')


clear
clc
close('all')

disp('MULTIAXIAL')

% ******* Importar datos**********

excel = input('Nombre del archivo excel donde se encuentran los datos: \n');
importfile(excel)


tiempo   = data(:,1); % No se utiliza para los c�lculos pero es �til para representaci�n gr�fica
sigma_xx = data(:,2);
sigma_yy = data(:,3);
sigma_zz = data(:,4);
tau_xy   = data(:,5);
tau_xz   = data(:,6);
tau_yz   = data(:,7);

clear('data')
clear('textdata')
clear('colheaders')

% N�mero de muestras

a = size(sigma_xx);

MUESTRAS = a(1); 

%*****************************

% IMPORTAR DATOS DEL MATERIAL

% Se importan de un excel el l�mite de fatiga en el ensayo de probeta 
% rotatoria, el tau limite de probeta rotatoria, la tensi�n de rotura 
% ingenieril y l�mite de fatiga en el ensayo de tracci�n alterna

importfile('ctes.xls')

CTES = data;
clear('data')
clear('textdata')
clear('colheaders')


novalido = true; 

while novalido                    
    
    opcion = input('\n M�todo cl�sico: 1 \n M�todo enfoque global: 2 \n Calcular el plano critico entre unos planos dados: 3 \n Gr�fico de las tensiones en un plano dado, calculo del c�rculo y elipse: 4 \n');

    switch opcion

        case 1
         
            % Von Mises
            VonMises(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS,CTES)
            novalido = ~novalido;
                
        case 2
            
            % Sines - Crossland
            EnfoqueGlobal(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS, CTES)
            novalido= ~novalido;
            
        case 3

            %Plano cr�tico
            Calculo(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS, CTES)
            novalido= ~novalido;

        case 4

            %Representaci�n gr�fica
            Planograf(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS, CTES)
            novalido= ~novalido;

        otherwise

            fprintf('\n Opci�n no v�lida')
            
    end
    
end