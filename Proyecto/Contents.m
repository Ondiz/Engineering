% PLANO CRÍTICO
%
% El archivo principal es Multiaxial.m. Aquí se importa el archivo excel
% con los datos del tensor de tensiones y otro con los datos del material.
% Se elige entre:
%
% - calcular con VonMises (se llama a VonMises.m)
% - calcular con un método de enfoque global: Sines o Crossland (se llama a 
%   EnfoqueGlobal.m)
% - calcular el plano crítico entre varios dados (se llama a Calculo.m)
% - visualizar las componentes de la tensión en un plano y los criterios
%   del círculo y la elipse (se llama a Planograf.m)
%
% Nota: el archivo excel que contiene los datos de tensión debe tener el 
% siguiente formato:
%     tiempo  sigma_xx     sigma_yy     sigma_zz    tau_xy    tau_xz  tau_yz
%      dato    dato          dato         dato       dato      dato    dato
%       .       .              .            .          .         .       .
%       .       .              .            .          .         .       .
%       .       .              .            .          .         .       .
% La columna tiempo no se utiliza para los cálculos pero es útil para 
% representación gráfica
%
% Nota2: los datos del material requeridos son: 
% lim_probeta_rot  lim_tau_probeta_rot   sigma_ut  lim_emsayo_axial  tau_ensayo_axial
%       dato              dato             dato         dato             dato   
%
% Descripción de funciones:
%
% VonMises.m
%
% VonMises(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz,
% MUESTRAS, CTES)
% Calcula la tension equivalente de VonMises-Goodman y Goodman-VonMises
% Entrada: datos del tensor de tensiones para los instantes de
%          tiempo, número de muestras y datos del material
% Salida: tensiones equivalentes de MG y GM, en pantalla
% Llamada por: Multiaxial.m
%
% EnfoqueGlobal.m
%
% EnfoqueGlobal(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz,
% MUESTRAS, CTES)
% Calcula las tensiones equivalentes de Sines y Crossland
% Entrada: datos del tensor de tensiones para los instantes de
%          tiempo, número de muestras y datos del material
% Salida: tensiones equivalentes de Sines y Crossland, en pantalla
% Llamada por: Multiaxial.m
%
% Calculo.m 
%
% Calculo(sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS,
% CTES)
% Entrada: datos del tensor de tensiones para los instantes de
%          tiempo, número de muestras y datos del material
% Salida  : (en pantalla) cálculo del plano crítico según los criterios
% Datos adicionales : pide una matriz que contenga los vectores normales de
% los planos a analizar (existe la opción de planos por defecto)
% Llamada por : Multiaxial.m
% Llama a : MaximoSegmento.m, MinimoCirculo.m, CambioCoord.m, Giro.m,
%           Elipse.m, Criterios.m
%
% Planograf.m
%
% Planograf (sigma_xx, sigma_yy, sigma_zz, tau_xy, tau_xz, tau_yz, MUESTRAS,
% CTES)
% Se representa gráficamente la evolución de los componentes de tensión en
% el tiempo. Se aplican y dibujan el criterio del círculo y de la elipse
% Entrada: datos del tensor de tensiones para los instantes de
%          tiempo, número de muestras y datos del material
% Salida  : (en pantalla) cálculo de las tensiones en el plano dado; 2
%           figuras: animación del movimiento de las tensiones; criterios 
%           del círculo y elipse  
% Datos adicionales : vector normal del plano (columna)
% Llamada por : Multiaxial.m
% Llama a : MaximoSegmento.m, MinimoCirculo.m, CambioCoord.m, Giro.m,
%           Elipse.m, DibujaPlano.m, DibujaElipseParam.m, Criterios.m
%
% MinimoCirculo. m
% 
% Calcula el mínimo círculo que engloba a todos los puntos dados
% Entrada : coordenadas(coordenadas de un conjunto de puntos, cada 
%           coordenada es una fila), normal (vector normal del plano, fila), 
%           pos1, pos2 (las posiciones en la matriz coordenadas de los dos 
%           puntos más alejados, se obtienen con MaximoSegmento.m);
% Salida  : xcentro ycentro zcentro (coordenadas del centro de la
%           circunferencia), radio, dos (será true si la circunferencia 
%           calculada sólo pasa por dos de los puntos)
% Llamada por : planograf.m, calculo.m
% Llama a : RadioSegmento.m, TresPuntos.m
%
% MaximoSegmento.m
%
% Calcula los puntos que forman el máximo segmento entre los puntos dados
% Entrada : coordenadas (coordenadas de un conjunto de puntos, 
%           cada coordenada es una fila)
% Salida  : pos1, pos2 (posición en la matriz coordenadas de los 2 puntos 
%           más alejados)
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
% Nota: la función CambioPlanoPerpendicular.m realiza la misma función pero
% dibujando los planos 
%
% Giro.m
%
% Se giran los ejes x e y un ángulo en sentido contrario de las agujas
% del reloj
% Entrada : grados que se gira
% Salida  : matriz de paso
% Llamada por : Planograf.m, Calculo.m
%
% Elipse.m 
%
% Calcula el eje pequeño de una matriz que contiene todos los puntos dados
% Entrada : coordenadas, centrox, centroy, radio (datos de la circunferencia)
% Salida  : eje pequeño de la elipse
% Llamada por : Planograf.m, Calculo.m
%
% DibujaPlano.m 
%
% Dibuja un plano conociendo su normal
% Entrada : normal del plano, número de figura
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
% Nota2: a pesar de que en el archivo Proyecto haya una función
% DibujaElipse.m no se utiliza
%
% Criterios(Sigma_nm, Sigma_nr, Tau_r, Planos, CTES)
% Se calculan las tensiones equivalentes y se dice si se produce o no fallo
% según Findley, Matake, McDiarmid y Dang Van
% Entrada: Sigma_nm (tensión normal media en cada instante), Sigma_nr (normal 
%          variable), Tau_r (cortante variable), Planos(planos a analizar),
%          CTES (datos del material)
% Salida: tensiones equivalentes en pantalla
% Llamada por : Planograf.m

% Pasar a html






