% Resolver ecuación diferencial de modo de viga de módulo de Young variable      

function main

 global L rho Ei n

 L =1;
 rho = 7900;
 Ei = 210E9;
 c = sqrt(Ei/rho);
 
omega = (2*n+1)*pi*c/(2*L);
x = linspace(0,L,30);       
solinit = bvpinit(x,@inicial, omega); % bvinit(x,yinit, parametros); en este caso y = 1 y y'=0
sol = bvp4c(@fun,@contorno,solinit); % bvp4c(función, condicionesContorno, valor inicial)

x = linspace(0,L,100); 
u = deval(sol,x);
figure(3)
hold on
plot(x,u(1,:),'r','Linewidth',2);
grid on
xlabel('x')
ylabel('u')

function dudx = fun(x,u, omega)
    
 global L rho Ei

 Ef = 0.7*Ei;
 
 % Variación lineal
 E = (Ef - Ei)/L*x + Ei;
 DE = (Ef - Ei)/L;
 
 % Variación exponencial
 
%  b = 1/L * log(Ef/Ei);
%  E = Ei*exp(b*x);
%  DE = b*Ei*exp(b*x);

% Peldaño

% trozo = 0.7; % porcentaje de viga con E inicial
% 
% E = Ei*(x<(trozo*L))+Ef*(x>=(trozo*L));
% DE = 0;
 
 c = sqrt(E/rho);
 
 % Ecuación:  U" + DE/E*U'+ (omega/c)^2*U
    
 dudx = [ u(2) 
           -DE/E*u(2)-(omega/c)^2*u(1)];

function res = contorno(ua,ub, omega)
  res = [ ua(1)
          ua(2)-1
          ub(2)]; % empotrada en a, libre en b + condición de normalización (ua(2)-1)
      
      
 function valorInicial = inicial(x)
     
     global L rho Ei n
     
     Ef = 0.7*Ei;
     c = sqrt(Ef/rho);

     omega = (2*n+1)*pi*c/(2*L); % omega de prueba -> omega caso empotrado
   
     valorInicial = [sin(omega/c*x); omega/c*cos(omega/c*x)];
      
      
      