% Creating system receptance from component receptances

% 2 DOF system: 
%
%
%  |        ----          ----         |
%  |--k1-- | m1 | --kc-- | m2 |  --k2--|
%  |        ----          ----         |

clear
clc

fprintf('PREDICTION OF KC USING RECEPTANCE')

% Mass and stiffness matrices

m1 = 1;
m2 = 1;

M = [m1 0; 0 m2]; 

k1 = 2;
k2 = 1;

kc = 3;

K = [k1+kc -kc; -kc k2+kc]; 

% Receptance

syms s

H = inv(M*s^2 + K);

h_coupled = H(1,1);

% Predict kc from ha and hb

ha = 1/(k1+s^2*m1); 
hb = 1/(k2+s^2*m2); 

syms kc

kc = solve('ha*(hb*kc+1)/(1+kc*(hb+ha))-h_coupled',kc); 

kc = simplify(eval(kc));

fprintf('\nkc = %.2f\n', eval(kc))







