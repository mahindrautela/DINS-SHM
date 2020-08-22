clc
clear
%% Geometric and material properties of the elements
n = 4; % input the number of sde elements
m = 2; % number of element without sde
rho = ones(1,n+m)*2600; % density of elements
E = ones(1,n+m)*80e9; % input the young's modulus of the elements
mu = 0.33; % Poission's ratio
G = E/(2*(1+mu)); % shear modulus
L = [1.3 0.57 0.13 0.13 1000 1000]; % length of all elements
B = ones(1,n+m)*1e-3; % width of element
H = [1 1 0.5 0.5 1 1]*1e-3; % thickness of element
A = B.*H; % area
I = B.*(H.^3)/12; % moment of inertia about zz
%% define array of element properties
PropArr = [E;G;rho;L;B;H;A;I]; % each column represent one element
writematrix(PropArr,'properties.txt');