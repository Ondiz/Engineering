L = 1;
E = 210E9;
rho = 7900;
n = 12;

Ef = 0.7*E;

c = sqrt(E/rho);
w = (2*n+1)*pi*c/(2*L);
k = w/c;

x = 0:.001:L;

% Variación lineal de E

Ex = (Ef - E)/L*x + E; 

cx = sqrt(Ex/rho);
wx = (2*n+1)*pi*cx(end)/(2*L);
kx = wx*cx.^-1;

plot(x, sin(k*x), x, sin(kx.*x),'r','LineWidth',2)
%plot( x, sin(kx.*x),'r','LineWidth',2)

legend('E cte', 'E lineal')
xlabel('x')
ylabel('u')
title('Modo axial')

% Variación exponencial de E
b = 1/L * log(Ef/E);
Ex = E*exp(b*x); 

cx = sqrt(Ex/rho);
wx = (2*n+1)*pi*cx(end)/(2*L); 
kx = wx./cx;

figure

plot(x, sin(k*x), x, sin(kx.*x),'r','LineWidth',2)

legend('E cte', 'E exponencial')
xlabel('x')
ylabel('u')
title('Modo axial')

