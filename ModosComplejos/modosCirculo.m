clear
clc
close all


% Modo

R = 1;

trozos = 50;

lambda = [0 0 5.253 12.23; 9.084 20.52 35.25 52.91; 38.55 59.86 83.9 111.3; 87.8 119 154 192.1];

n = 2;
m = 1;

%omega = lambda(n,m)^2*sqrt(E/(12*rho*h^3*(1-nu^2)))/R^2;
omega = 0.03;


[r,phi] = meshgrid(linspace(0,R,trozos),linspace(0,2*pi,trozos));

xi = lambda(m+1,n+1)*r;

%xi = r;

for t=1:100

    W = besselj(n,xi)+besselj(n,lambda(m+1,n+1)*R)/besseli(n,lambda(m+1,n+1)*R)*besseli(n,xi);
    
    W = W.*sin(n*phi)*sin(2*pi*omega*t);

    surf(r.*cos(phi),r.*sin(phi),W)
    axis([-R R -R R -1 1])
    drawnow 

end

% close
% 
% figure
% 
% 
% for t=1:300
% 
%     W = (C1*besselj(n,xi)+C2*besseli(n,xi));
%     
%     W = W/norm(W).*sin(n*phi-omega*t);
% 
%     surf(r.*cos(phi),r.*sin(phi),W)
%     axis([-R R -R R -0.1 0.1])
%     drawnow 
% 
% end
% 
% close