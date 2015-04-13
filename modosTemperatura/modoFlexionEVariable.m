% Resolver ecuación diferencial de modo de flexión de viga con E variable

function FlexionEVariable

 clear
 clc
 
 global beta L rho A I E n


 L =1;
 rho = 7900;
 E = 210E9;
 
 %n = 20;
 
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
 hold on
 figure(1)
 plot(x,u(1,:),'r','Linewidth',2);
 grid on
 xlabel('x'),ylabel('y'),title(['Modo de flexión ' num2str(n)])

function dudx = fun(x,u, omega)
    
 global rho A I E L
 
 Ef = 0.5*E;
% Ef = 0.1*E;

% Ef = 2*E;
 
% Variación lineal
%  Ex = (Ef - E)/L*x + E;
%  DE = (Ef - E)/L;
%  DE2 = 0;
 
% Variación exponencial
 
%  b = 1/L * log(Ef/E);
%  Ex = E*exp(b*x);
%  DE = b*E*exp(b*x);
%  DE2 = b^2*E*exp(b*x);

% Peldaño

trozo = 0.7; % porcentaje de viga con E inicial

Ex = E*(x<(trozo*L))+Ef*(x>=(trozo*L));
DE = 0*(x<((trozo-0.02)*L))+ (Ef-E)*30*((x<((trozo+0.02)*L))&&(x>((trozo-0.02)*L))) +0*(x>((trozo+0.02)*L));
DE2 = 0*(x<((trozo-0.02)*L))-(Ef-E)*30*30*((x<((trozo-0.01)*L))&&(x>((trozo-0.02)*L))) + (Ef-E)*30*30*((x<((trozo+0.02)*L))&&(x>((trozo-0.01)*L))) +0*(x>((trozo+0.02)*L));
    
c = sqrt(Ex*I/(rho*A));
    
dudx = [ u(2) 
         u(3)
         u(4)
         (omega/c)^2*u(1)-2/Ex*DE*u(4)-1/Ex*DE2*u(3)];

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
     