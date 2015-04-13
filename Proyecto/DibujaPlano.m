function DibujaPlano(n , fig , limite)  

% Dibuja un plano conociendo su normal

figure(fig)
hold on

paso = limite/ 30;

if n(3)~=0
        
        [x,y] = meshgrid(-limite:paso:limite, -limite:paso:limite);                            
        z=(-n(1)*x-n(2)*y)/n(3);                                      
        surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)

    else 
        if n(1)~=0
            
            [y,z] = meshgrid(-limite:paso:limite, -limite:paso:limite);                             
            x=(-n(2)*y-n(3)*z)/n(1);                                      
            surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)
            
        else
            
            [x,z] = meshgrid(-limite:paso:limite, -limite:paso:limite);                             
            y=(-n(1)*x-n(3)*z)/n(2);                                      
            surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)

        end
        
end

quiver3(0,0,0,n(1),n(2),n(3))
view(n)