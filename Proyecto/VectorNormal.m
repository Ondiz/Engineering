function [n] = VectorNormal  % En el programa real [n]= VectorNormal(alpha, beta, gamma) y hacer input fuera ??

no = true; 

    while no
        
        [angulos]= input('Ángulos que forma el plano con los ejes coordenados, en grados (vector 1x3): \n');
    
        if size(angulos) == [1 3]
            
            no = ~no; 
            fprintf('Formato incorrecto \n')
            
        end
        
        
    end

n = cosd(angulos)';

end