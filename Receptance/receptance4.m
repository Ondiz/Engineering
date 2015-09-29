% Creating system receptance from component receptances

% 4 DOF system: 
%
%
%  |        ----          ----         |
%  |--k1-- | m1 | --kc-- | m2 |  --k2--|
%  |        ----          ----         |
%             |            |          
%            kx           kx 
%             |            |
%           -----        -----

clear
clc

fprintf('PREDICTION OF KC USING RECEPTANCE\n')

% Mass and stiffness matrices

m1 = 1;
m2 = 1;

M = [m1 0 0 0; 0 0 m1 0; 0 0 m2 0; 0 0 0 m2]; 

k1 = 2;
k2 = 1;
kx = 1;

kc = 3;

K = [kx 0 0 0; 0 k1+kc 0 -kc; 0 0 kx 0; 0 -kc 0 k2+kc]; 

% Receptance

syms s

H = inv(M*s^2 + K);

h_coupled = H(2,2);

% Predict kc from ha and hb

% Subsystem 1:

% 
% syms kc
% 
% kc = solve('ha*(hb*kc+1)/(1+kc*(hb+ha))-h_coupled',kc); 
% 
% kc = simplify(eval(kc));
% 
% fprintf('\nkc = %.2f\n', eval(kc))
