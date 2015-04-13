function[xcentro ycentro zcentro radio] = RadioSegmento(a,b)

% Calcula el radio y el centro de una circunferencia que pasa por dos puntos
    
        xcentro=(b(1,1)-a(1,1))/2 + a(1,1);
        ycentro=(b(1,2)-a(1,2))/2 + a(1,2);
        zcentro=(b(1,3)-a(1,3))/2 + a(1,3);
        radio= sqrt((b(1,1)-xcentro)^2+(b(1,2)-ycentro)^2+(b(1,3)-zcentro)^2);
        
end
