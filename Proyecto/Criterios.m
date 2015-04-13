function Criterios(Sigma_nm, Sigma_nr, Tau_r, Planos, CTES)

% Criterios(Sigma_nm, Sigma_nr, Tau_r, Planos, CTES)
% Se calculan las tensiones equivalentes y se dice si se produce o no fallo
% seg�n Findley, Matake, McDiarmid y Dang Van.
%
% Datos: Sigma_nm (tensi�n normal media en cada instante), Sigma_nr (normal 
% variable), Tau_r (cortante variable), Planos(planos a analizar), CTES 
% (datos del material)

    lim_traccion_alterna = CTES(4);
    lim_tau_torsion = CTES(2);
    sigma_ut = CTES(3);

    if (lim_tau_torsion/lim_traccion_alterna > 0.5)
        
        % Findley: tau_nr + alfa*(sigma_nm + sigma_nr)
        % Plano cr�tico el que maximice la funci�n anterior
        
        alfa = 2*(lim_tau_torsion/lim_traccion_alterna) - 1;
        beta = lim_tau_torsion;
    
        fprintf('\n Criterio de Findley: \n')
        
        Findley = Tau_r + alfa*(Sigma_nm + Sigma_nr);
        [max_tension max_plano]= max(Findley);
        
        fprintf('Plano de m�xima tensi�n: \n')
        n = Planos(:,max_plano);
        n=n/norm(n);
        disp(n)
        fprintf('Con una tensi�n de %f \n', max_tension)
        
        if max_tension > beta
            
            disp('Se producir� el fallo por fatiga seg�n Findley')
            
        else
            disp('No se producir� el fallo por fatiga seg�n Findley')
        end
   
        
        
        % Matake: tau_r + alfa*(sigma_m + sigma_r)< beta  (mismos alfa y
        % beta)  
        % Plano cr�tico: el de tensi�n de cortadura m�xima
        
        fprintf('\n Criterio de Matake: \n')
        [max_tension max_plano]= max(Tau_r);
        fprintf('Plano de m�xima tensi�n: \n')
        n = Planos(:,max_plano); 
        n=n/norm(n);
        disp(n)

        Matake = Tau_r(max_plano)+ alfa*(Sigma_nm(max_plano)+ Sigma_nr(max_plano));

        fprintf('Con una tensi�n de %f \n', Matake)

        if Matake > beta

           disp('Se producir� el fallo por fatiga seg�n Matake')

        else
           disp('No se producir� el fallo por fatiga seg�n Matake')
        
        end
        
        % McDiarmid -> dos criterios
        % Plano cr�tico (en ambos casos): el de tensi�n de cortadura m�xima
        
        fprintf('\n Primer criterio de McDiarmid: \n')
        
        % Ctes

        A = lim_tau_torsion;
        B = (lim_tau_torsion + 0.5*lim_traccion_alterna)/(0.5*lim_traccion_alterna)^1.5;
        
        McDiarmid = (max_tension + B*(Sigma_nr).^1.5)./A;
        
        fprintf('Plano de m�xima tensi�n: \n')
        n = Planos(:,max_plano); 
        n=n/norm(n);
        disp(n)
        fprintf('Con una tensi�n de %f \n', max_tension)
        
        if all(McDiarmid >1)
            
            disp('Se producir� el fallo por fatiga seg�n el primer criterio de McDiarmid')
            
        else
            disp('No se producir� el fallo por fatiga seg�n el primer criterio de McDiarmid')
        end
       
        
        if all(Sigma_nm < (0.5*sigma_ut))
           
            McDiarmid2 = ((1 - 2*Sigma_nm./sigma_ut).^(-0.5) .* max_tension + B*Sigma_nr.^1.5)./A;
            fprintf('\n Segundo criterio de McDiarmid: \n')
           
            fprintf('Plano de m�xima tensi�n: \n')
            n = Planos(:,max_plano); 
            n=n/norm(n);
            disp(n)
            fprintf('Con una tensi�n de %f \n', max_tension)
            
            
            if all(McDiarmid2 > 1)
            
                disp('Se producir� el fallo por fatiga seg�n el segundo criterio de McDiarmid')
            
            else
                disp('No se producir� el fallo por fatiga seg�n el segundo criterio de McDiarmid')
            end
            
        end
        
        % Dang Van (macroscopico)
        
        fprintf('\n Criterio de Dang Van: \n')
        
        alfa = 3*(lim_tau_torsion/lim_traccion_alterna - 0.5);
        beta = lim_tau_torsion;
        
        DangVan = (Tau_r + alfa*(Sigma_nm + Sigma_nr))./beta;
        [max_tension max_plano]= max(DangVan);
        
        fprintf('Plano de m�xima tensi�n: \n')
        n = Planos(:,max_plano);
        n=n/norm(n);
        disp(n)
        fprintf('Con una tensi�n de %f \n', max_tension*lim_tau_torsion)
        
        if max_tension > 1
            
            disp('Se producir� el fallo por fatiga seg�n Dang Van')
            
        else
            disp('No se producir� el fallo por fatiga seg�n Dang Van')
        end
        
    else
        
        fprintf('El criterio de Findley, el de Matake, el de McDiarmid y el de Dang Van no son v�lidos: tau_n / sigma_n < 0.5')
        
    end       


end
   