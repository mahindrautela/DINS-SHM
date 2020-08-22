function [krod,kbeam,Cgrod,Cgbeam] = ElemWaveno(E,A,rho,I,omega)
%% Calculate the wavenumber for rod and beam elements
krod = omega*(rho*A/(E*A))^0.5; % wavenumber for a rod
Cgrod = ((E*A)/(rho*A))^0.5;    
kbeam = omega^0.5*(rho*A/(E*I))^0.25;  % wavenumber for a beam
Cgbeam = 2*omega^0.5*((E*I)/(rho*A))^0.25;
end