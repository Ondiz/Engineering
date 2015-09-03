% Playing with receptances and system modifications

% 2 DOF system: 
%
%
%  |        ----          ----
%  |--k1-- | m1 | --k2-- | m2 |
%  |        ----          ----

clear
clc

fprintf('RECEPTANCE AND SYSTEM MODIFICATIONS')

% Mass and stiffness matrices

M = eye(2); % mass matrix = I 

k1 = 2;
k2 = 1;

K = [k1+k2 -k2; -k2 k2]; 

% Receptance

syms s

H = inv(M*s^2 + K);

[~, lambda]=eig(K,M);
lambda = lambda.^0.5;

omega = 0:.01:3;
s = j*omega;

h11 = subs(H(1,1));
plot(omega, abs(h11))

% Modification -> add mass
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\nAdd mass\n')

pos = 1;

deltaM = zeros(2,2);

m = 0.1; 
deltaM(pos,pos)= m;

[~,newLambda] = eig(K,M+deltaM);
newLambda = newLambda.^0.5;

fprintf('Natural frequencies from eigenvalues: \n')

X = sprintf('%0.3f\n',newLambda(newLambda>0));
disp(X)

clear s
syms s
newH = inv((M+deltaM)*s^2 + K);
s = j*omega;

hold on
h11 = subs(newH(1,1));
plot(omega, abs(h11),'r')

% New receptance can also be computed from former receptance matrix

clear s 
syms s
newHUpdated = inv(eye(2)+s^2*H*deltaM)*H;
s = j*omega;

hold on
h11 = subs(newHUpdated(1,1));
plot(omega, abs(h11),'g')

% Eigenvalues can be computed as the roots of the polynomial in the
% denominator in the receptance functions

h11 = char(newH(1,1));
h11 = strsplit(h11,'/');
h11 = h11{2}; % take the denominator

resp = eval(solve(h11, 's'));
resp = imag(resp(imag(resp)>0)); % imaginary part of roots with positive 
% imaginary part (as to not have repeated values) -> only natural frequency
% is needed

fprintf('\nNatural frequencies from receptance: \n')

X = sprintf('%0.3f\n',resp);
disp(X)


% Modification -> add stiffness
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\nAdd stiffness\n')

pos = 1; 
deltaK = zeros(2,2);

k = 0.1;
deltaK(1,1) = k;

% If stiffness is added to k2:
%
% pos = 2;
% deltaK(2,2) = k;
% deltaK(1,2) = -k;
% deltaK(2,1) = deltaK(1,2);

[~,newLambdaK] = eig(K+deltaK,M);
newLambdaK = newLambdaK.^0.5;

fprintf('Natural frequencies from eigenvalues: \n')

X = sprintf('%0.3f\n',newLambdaK(newLambdaK>0));

disp(X)

clear s
syms s
newHK = inv(M*s^2 + K+deltaK);
s = j*omega;

hold on
h11 = subs(newHK(1,1));
plot(omega, abs(h11),'b')

% Eigenvalues can be computed as the roots of the polynomial in the
% denominator in the receptance functions

h11 = char(newHK(1,1));
h11 = strsplit(h11,'/');
h11 = h11{2}; % take the denominator

resp = eval(solve(h11, 's'));
resp = imag(resp(imag(resp)>0));

fprintf('\nNatural frequencies from receptance: \n')

X = sprintf('%0.3f\n',resp);
disp(X)

% Conclusion: if H is measured and the modifications are known new
% eigenvalues can be computed from the characteristic polynomial


