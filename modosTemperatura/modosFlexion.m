% Resolver ecuación diferencial de modo de flexión de viga     

function FlexionECte

 clear
 clc

 global beta L rho A I E n


 L =1;
 rho = 7900;
 E = 210E9;
 
 %n = 4;
 
 beta = (2*(5:1:30)-1)*pi/2;
 
 beta = [1.875 4.694 7.854 10.9956 14.137 beta];
 
 beta = beta(n);
 b = 0.1;
 h = 0.2;
 I = 1/12*b*h^3;
 A = b*h;
 c = sqrt(E*I/(rho*A));
 
omega = beta^2*c;
x = linspace(0,L,30);       
solinit = bvpinit(x,@inicial, omega); % bvpinit(x,yinit, parametros)
sol = bvp4c(@fun,@contorno,solinit); % bvp4c(función, condicionesContorno, valor inicial)

x = linspace(0,L,300); 
u = deval(sol,x);
figure(1)
plot(x,u(1,:),'Linewidth',2); title('Modo de flexión')

function dudx = fun(x,u, omega)
    
 global rho A I E
    
 c = sqrt(E*I/(rho*A));
 
 % Ecuación: U"" -(omega/c)^2*U = 0
    
 dudx = [ u(2) 
          u(3)
          u(4)
          (omega/c)^2*u(1)];

function res = contorno(ua,ub, omega)
 
    res = [ ua(1)
          ua(2)
          ua(3)-1
          ub(3)
          ub(4)]; % empotrada en a, libre en b (momento flector(segunda derivada) y cortante (tercera derivada) = 0) + condición de normalización (ua(3)-1) momento en a = 1
      
            
 function valorInicial = inicial(x)
     
     global beta L rho A I E
     
     c = sqrt(E*I/(rho*A));

    omega = beta^2*c;
    valorInicial = [sin(omega/(c*L)*x); omega/(c*L)*cos(omega/(c*L)*x); (omega/(c*L))^2*cos(omega/(c*L)*x); (omega/(c*L))^3*cos(omega/(c*L)*x)];
     
    
    
    