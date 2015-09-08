
% Playing with receptances and system modifications

% 2 DOF system: 
%
%
%  |        ----          ----
%  |--k1-- | m1 | --k2-- | m2 |
%  |        ----          ----

clear
clc


% Mass and stiffness matrices

M = eye(2); % mass matrix = I 

k1 = 2;
k2 = 1;

K = [k1+k2 -k2; -k2 k2]; 

% Receptance

omega = 0:.01:3;
s = j*omega;

muestras = length(omega);

H = zeros(2,2,muestras);

for k = 1:muestras
    
    H(:,:,k) = inv(M*s(k)^2 + K);
    
end

% Symbolic receptance

% Receptance

clear s
syms s

symH = inv(M*s^2 + K);

s = j*omega;

h11Sym = subs(symH(1,1));

% Modification -> add mass
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pos = 1;

deltaM = zeros(2,2);

m = 0.1; 
deltaM(pos,pos)= m;


% New receptance can also be computed from former receptance matrix

newH = zeros(size(H));

for k = 1:muestras

    newH(:,:,k) =(eye(2)+s(k)^2*H(:,:,k)*deltaM)\H(:,:,k);

end


clear s 
syms s
% newHUpdated = inv(eye(2)+s^2*symH*deltaM)*symH;
newHUpdated = (eye(2)+s^2*symH*deltaM)\symH;
s = j*omega;

hold on
newh11Sym = subs(newHUpdated(1,1));

%%%%%%%%%%%%%

h11 = squeeze(H(1,1,:));
newH11 = squeeze(newH(1,1,:));

subplot(211), semilogy(omega, abs(h11),omega, abs(newH11),'g')
subplot(212), plot(omega, angle(h11),omega, angle(newH11),'g')


figure

subplot(211), semilogy(omega, abs(h11Sym),omega, abs(h11),'g')
subplot(212), plot(omega, angle(h11Sym),omega, angle(h11),'g')

figure

subplot(211), semilogy(omega, abs(newh11Sym),omega, abs(newH11),'g')
subplot(212), plot(omega, angle(newh11Sym),omega, angle(newH11),'g')



