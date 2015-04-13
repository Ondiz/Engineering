function [xcentro ycentro zcentro radio] = TresPuntosDibujo(a,b,c,normal)

vec1= b - a
mitad1=vec1/2 + a
scatter3(mitad1(1),mitad1(2),mitad1(3))
hold on
D=-(vec1(1)*mitad1(1)+vec1(2)*mitad1(2)+vec1(3)*mitad1(3))

    scatter3(a(1),a(2),a(3),'Filled')
    quiver3(a(1),a(2),a(3),vec1(1),vec1(2),vec1(3))
    scatter3(b(1),b(2),b(3),'Filled')
    scatter3(c(1),c(2),c(3),'Filled')
    

vec2= c - a
mitad2=vec2/2 + a

    scatter3(mitad2(1),mitad2(2),mitad2(3))
    quiver3(a(1),a(2),a(3),vec2(1),vec2(2),vec2(3))
    
H=-(vec2(1)*mitad2(1)+vec2(2)*mitad2(2)+vec2(3)*mitad2(3));

     [x,z] = meshgrid(-3:1:10, -3:1:10);                        
      y=(-vec1(1)*x-vec1(3)*z-D)/vec1(2);                                      
      surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)
                                   
      y=(-vec2(1)*x-vec2(3)*z-H)/vec2(2);                                      
      surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)

       [x,y] = meshgrid(-3:1:10, -3:1:10);                           
        z=(-normal(1)*x-normal(2)*y)/normal(3);                                      
        surf(x,y,z,'FaceColor', 'none','FaceAlpha',0.5)
   
A=[vec1; vec2;normal];
B=[-D;-H;0];

centro=A\B;

xcentro=centro(1);
ycentro=centro(2);
zcentro=centro(3);

    scatter3(centro(1),centro(2),centro(3),'Filled','y')

radio= a - centro';
radio=norm(radio);

end