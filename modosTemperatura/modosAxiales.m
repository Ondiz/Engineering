% Resolver ecuación diferencial de modo de viga     

function mainNormal

 global L rho E n

 L =1;
 rho = 7900;
 E = 210E9;
 c = sqrt(E/rho);
 
omega = (2*n+1)*pi*c/(2*L);
x = linspace(0,L,30);       
solinit = bvpinit(x,@inicial, omega); % bvinit(x,yinit, parametros); en este caso y = 1 y y'=0
sol = bvp4c(@fun,@contorno,solinit); % bvp4c(función, condicionesContorno, valor inicial)

x = linspace(0,L,100); 
u = deval(sol,x);
figure(3)
plot(x,u(1,:),'Linewidth',2); title('Modo axial')

function dudx = fun(x,u, omega)
    
 global L rho E
 
 c = sqrt(E/rho);
 
 % Ecuación: U" +(omega/c)^2*U
    
 dudx = [ u(2) 
           -(omega/c)^2*u(1)];

function res = contorno(ua,ub, omega)
  res = [ ua(1)
          ua(2)-1
          ub(2)]; % empotrada en a, libre en b + condición de normalización (ua(2)-1)
      
 function valorInicial = inicial(x)
     
     global L rho E n
     
     c = sqrt(E/rho);

     omega = (2*n+1)*pi*c/(2*L); % omega de prueba -> omega caso empotrado
   
     valorInicial = [sin(omega/c*x); omega/c*cos(omega/c*x)];
    
    
    