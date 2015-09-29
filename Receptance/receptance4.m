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

M = [m1 0 0 0; 0 m1 0 0; 0 0 m2 0; 0 0 0 m2]; 

k1 = 2;
k2 = 1;
kx = 1;

kc = 5;

K = [kx 0 0 0; 0 k1+kc 0 -kc; 0 0 kx 0; 0 -kc 0 k2+kc]; 

% Receptance

syms s

H = inv(M*s^2 + K);

h_coupled = H(2,2);

% Predict kc from ha and hb

% Subsystem 1:

Msubs1 = [m1 0; 0 m1];
Ksubs1 = [kx 0; 0 k1];

Hsubs1 = inv(s^2*Msubs1 + Ksubs1);

ha = Hsubs1(2,2);

% Subsystem 2:

Msubs2 = [m2 0; 0 m2];
Ksubs2 = [kx 0; 0 k2];

Hsubs2 = inv(s^2*Msubs2 + Ksubs2);

hb = Hsubs2(2,2);

syms kc

kc = solve('ha*(hb*kc+1)/(kc*(ha+hb)+1)-h_coupled',kc); % Esta fórmula es universal

kc = simplify(eval(kc));
fprintf('\nkc = %.2f\n', eval(kc))

