function [Krod,Kbeam] = KrodKbeam(E,A,I,L,k1,k2)
%% Stiffness matrix for rod and beam element
Krod = (E*A/L)*(1i*k1*L/(1-exp(-1i*2*k1*L)))*[1+exp(-1i*2*k1*L)     -2*exp(-1*k1*L);...
                                              -2*exp(-1*k1*L)    1+exp(-1i*2*k1*L)];

% T1 = [      1                    1                1                          1;...
%          -1i*k2                 -k2             1i*k2                       k2;...
%        exp(-1i*k2*L)         exp(-k2*L)       exp(1i*k2*L)            exp(k2*L);...
%    -1i*k2*exp(-1i*k2*L)    -k2*exp(-k2*L)   1i*k2*exp(1i*k2*L)     k2*exp(k2*L)];
% 
% T2 = E*I*[       -1i*k2^3              k2^3               1i*k2^3                   -k2^3;...
%                   -k2^2                k2^2                -k2^2                     k2^2;...
%            -1i*k2^3*exp(-1i*k2*L)  k2^3*exp(-k2*L)   1i*k2^3*exp(1i*k2*L)  -k2^3*exp(k2*L);...
%            -k2^2*exp(-1i*k2*L)     k2^2*exp(-k2*L)    -k2^2*exp(1i*k2*L)    k2^2*exp(k2*L)];
%        
% Kbeam = inv(T1)*T2;

alp =  ((cos(k2*L)*tanh(k2*L) + sin(k2*L))*(k2*L)^3)/(sech(k2*L) - cos(k2*L));
beta = ((sin(k2*L)*tanh(k2*L))*(k2*L)^2)/(sech(k2*L) - cos(k2*L));
gam = ((sin(k2*L)*sech(k2*L)+tanh(k2*L))*(k2*L)^3)/(sech(k2*L) - cos(k2*L));
sdel = ((-cos(k2*L)*sech(k2*L)+1)*(k2*L)^2)/(sech(k2*L) - cos(k2*L));
zeta = ((-cos(k2*L)*tanh(k2*L) + sin(k2*L))*(k2*L))/(sech(k2*L) - cos(k2*L)); 
eta = ((-sin(k2*L)*sech(k2*L)+tanh(k2*L))*(k2*L))/(sech(k2*L) - cos(k2*L));
       
Kbeam = E*I*[ alp       beta*L      gam       sdel*L;
             beta*L    zeta*L^2  -sdel*L     eta*L^2;
              gam      -sdel*L      alp      -beta*L;
             sdel*L    eta*L^2   -beta*L    zeta*L^2];
end