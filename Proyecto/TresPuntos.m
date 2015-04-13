function [xcentro ycentro zcentro radio] = TresPuntos(a,b,c,normal)

    % Calcula el centro y el radio de una circunferencia que pase por tres
    % puntos
    % a, b, c y normal son vectores fila 

    vec1= b - a;
    mitad1=vec1/2 + a;
    D=-(vec1(1)*mitad1(1)+vec1(2)*mitad1(2)+vec1(3)*mitad1(3));

    vec2= c - a;
    mitad2=vec2/2 + a;    
    H=-(vec2(1)*mitad2(1)+vec2(2)*mitad2(2)+vec2(3)*mitad2(3));

    A=[vec1; vec2;normal];
    
    if rcond(A)> eps*50   
        B=[-D;-H;0];

        centro=A\B;

        xcentro=centro(1);
        ycentro=centro(2);
        zcentro=centro(3);

        radio= a - centro';
        radio= norm(radio);
    else
        xcentro=0;
        ycentro=0;
        zcentro=0;
        radio =0;
    end

end