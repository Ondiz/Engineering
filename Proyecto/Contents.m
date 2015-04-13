% PLANO CR�TICO
%
% El archivo principal es Multiaxial.m. Aqu� se importa el archivo excel
% con los datos del tensor de tensiones y otro con los datos del material.
% Se elige entre:
%
% - calcular con VonMises (se llama a VonMises.m)
% - calcular con un m�todo de enfoque global: Sines o Crossland (se llama a 
%   EnfoqueGlobal.m)
% - calcular el plano cr�tico entre varios dados (se llama a Calculo.m)
% - visualizar las componentes de la tensi�n en un plano y los criterios
%   del c�rculo y la elipse (se llama a Planograf.m)
%
% Nota: el archivo excel que contiene los datos de tensi�n debe tener el 
% siguiente formato:
%     tiempo  sigma_xx     sigma_yy     sigma_zz    tau_xy    tau_xz  tau_yz
%      dato    dato          dato         dato       dato      dato    dato
%       .       .              .            .          .         .       .
%       .       .              .            .          .         .       .
%       .       .              .            .          .         .       .
% La columna tiempo no se utiliza para los c�lculos pero es �til para 
% representaci�n gr�fica
%
% Nota2: los datos del material requeridos son: 
% lim_probeta_rot  lim_tau_probeta_rot   sigma_ut  lim_emsayo_axial  tau_ensayo_axial
%       dato              dato             dato         dato             dato   
%
% Descripci�n de funciones:
%
% VonMises.m
%
% VonMises(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz,
% MUESTRAS, CTES)
% Calcula la tension equivalente de VonMises-Goodman y Goodman-VonMises
% Entrada: datos del tensor de tensiones para los instantes de
%          tiempo, n�mero de muestras y datos del material
% Salida: tensiones equivalentes de MG y GM, en pantalla
% Llamada por: Multiaxial.m
%
% EnfoqueGlobal.m
%
% EnfoqueGlobal(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz,
% MUESTRAS, CTES)
% Calcula las tensiones equivalentes de Sines y Crossland
% Entrada: datos del tensor de tensiones para los instantes de
%          tiempo, n�mero de muestras y datos del material
% Salida: tensiones equivalentes de Sines y Crossland, en pantalla
% Llamada por: Multiaxial.m
%
% Calculo.m 
%
% Calculo(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS,
% CTES)
% Entrada: datos del tensor de tensiones para los instantes de
%          tiempo, n�mero de muestras y datos del material
% Salida  : (en pantalla) c�lculo del plano cr�tico seg�n los criterios
% Datos adicionales : pide una matriz que contenga los vectores normales de
% los planos a analizar (existe la opci�n de planos por defecto)
% Llamada por : Multiaxial.m
% Llama a : MaximoSegmento.m, MinimoCirculo.m, CambioCoord.m, Giro.m,
%           Elipse.m, Criterios.m
%
% Planograf.m
%
% Planograf (sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS,
% CTES)
% Se representa gr�ficamente la evoluci�n de los componentes de tensi�n en
% el tiempo. Se aplican y dibujan el criterio del c�rculo y de la elipse
% Entrada: datos del tensor de tensiones para los instantes de
%          tiempo, n�mero de muestras y datos del material
% Salida  : (en pantalla) c�lculo de las tensiones en el plano dado; 2
%           figuras: animaci�n del movimiento de las tensiones; criterios 
%           del c�rculo y elipse  
% Datos adicionales : vector normal del plano (columna)
% Llamada por : Multiaxial.m
% Llama a : MaximoSegmento.m, MinimoCirculo.m, CambioCoord.m, Giro.m,
%           Elipse.m, DibujaPlano.m, DibujaElipseParam.m, Criterios.m
%
% MinimoCirculo. m
% 
% Calcula el m�nimo c�rculo que engloba a todos los puntos dados
% Entrada : coordenadas(coordenadas de un conjunto de puntos, cada 
%           coordenada es una fila), normal (vector normal del plano, fila), 
%           pos1, pos2 (las posiciones en la matriz coordenadas de los dos 
%           puntos m�s alejados, se obtienen con MaximoSegmento.m);
% Salida  : xcentro ycentro zcentro (coordenadas del centro de la
%           circunferencia), radio, dos (ser� true si la circunferencia 
%           calculada s�lo pasa por dos de los puntos)
% Llamada por : planograf.m, calculo.m
% Llama a : RadioSegmento.m, TresPuntos.m
%
% MaximoSegmento.m
%
% Calcula los puntos que forman el m�ximo segmento entre los puntos dados
% Entrada : coordenadas (coordenadas de un conjunto de puntos, 
%           cada coordenada es una fila)
% Salida  : pos1, pos2 (posici�n en la matriz coordenadas de los 2 puntos 
%           m�s alejados)
% Llamada por : Planograf.m, Calculo.m
%
% TresPuntos.m
%
% Calcula la circunferencia (centro y radio) que pasa por tres puntos.
% Entrada : a,b,c (coordenadas de los puntos), normal del plano
% Salida  : xcentro, ycentro, zcentro y radio
% Llamada por : MinimoCirculo.m
%
% RadioSegmento.m
%
% Calcula el radio y el centro de una circunferencia que pasa por dos puntos
% Entrada : a,b (coordenadas de los puntos)
% Salida  : xcentro, ycentro, zcentro y radio
% Llamada por : MinimoCirculo.m
%
% CambioCoord.m
%
% Se pasa a un sistema de coordenadas donde z'=normal, x' e y' pertenecen
% al plano
% Entrada : normal del plano
% Salida  : matriz de paso
% Llamada por : planograf.m, calculo.m
% Nota: la funci�n CambioPlanoPerpendicular.m realiza la misma funci�n pero
% dibujando los planos 
%
% Giro.m
%
% Se giran los ejes x e y un �ngulo en sentido contrario de las agujas
% del reloj
% Entrada : grados que se gira
% Salida  : matriz de paso
% Llamada por : Planograf.m, Calculo.m
%
% Elipse.m 
%
% Calcula el eje peque�o de una matriz que contiene todos los puntos dados
% Entrada : coordenadas, centrox, centroy, radio (datos de la circunferencia)
% Salida  : eje peque�o de la elipse
% Llamada por : Planograf.m, Calculo.m
%
% DibujaPlano.m 
%
% Dibuja un plano conociendo su normal
% Entrada : normal del plano, n�mero de figura
% Salida  : figura
% Llamada por : planograf.m
%
% DibujaElipseParam.m
%
% Dibuja una elipse 
% Entrada : centrox, centroy, angulo (de los ejes de la elipse respecto a 
% los ejes coordenados), a, b (semiejes de la elipse)
% Salida  : elipse en la figura actual
% Llamada por : planograf.m
% Nota1: si a=b dibuja circunferencias
% Nota2: a pesar de que en el archivo Proyecto haya una funci�n
% DibujaElipse.m no se utiliza
%
% Criterios(Sigma_nm, Sigma_nr, Tau_r, Planos, CTES)
% Se calculan las tensiones equivalentes y se dice si se produce o no fallo
% seg�n Findley, Matake, McDiarmid y Dang Van
% Entrada: Sigma_nm (tensi�n normal media en cada instante), Sigma_nr (normal 
%          variable), Tau_r (cortante variable), Planos(planos a analizar),
%          CTES (datos del material)
% Salida: tensiones equivalentes en pantalla
% Llamada por : Planograf.m

% Pasar a html






