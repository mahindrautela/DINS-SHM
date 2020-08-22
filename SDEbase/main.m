clc
clear
%% Elements
n = 4; % number of elements in sde
m = 2; % number of other throwoff elements
l = 0; % number of other other elements
nfft = 4096*2;
T = 0.5e-6*nfft;
deltaT = T/nfft;
t = [0:nfft-1]/nfft;
time = t*T;
%% Input forcing function (run 'Phsforce.m')
disp('Loading Forcing function...')
Load = load('f120');
freq = [1e-3;Load(2:end,1)];
omega = 2*3.142*freq;
appliedforce = Load(:,2) + 1i*Load(:,3);
f1_1 = appliedforce';           % represent axial load at node-1
f1_2 = zeros(1,length(omega)); % represent transverse load at node-1
f1_3 = zeros(1,length(omega)); % represent moment at node-1
f1 = [f1_1;f1_2;f1_3];
f2 = zeros(3,length(omega));
f7 = zeros(3,length(omega));
f4 = zeros(3,length(omega));
% F = [f1;f2];
F = [f1;f4;f7;f2];
%% Input Geometric and material properties (run 'elemprop.m')
disp('Loading Material properties...')
prop = table2array(readtable('properties.txt'));
E = prop(1,:); % elements young modulus
G = prop(2,:); % elements shear modulus
rho = prop(3,:); % elements density
L = prop(4,:); % elements length
B = prop(5,:); % elements width
H = prop(6,:); % elements thickness
A = prop(7,:); % elements area
I = prop(8,:); % elements I-zz
%% Wavenumbers (uses ElemWaveno.f)
disp('Computing wavenumbers...')
k1 = zeros(length(omega),n+m);
k2 = zeros(length(omega),n+m);
for i = 1:length(omega)
    for j=1:n+m+l
        [krod,kbeam]=ElemWaveno(E(j),A(j),rho(j),I(j),omega(i));
        k1(i,j) = krod; % each row for different element
        k2(i,j) = kbeam; 
    end
end
%% Transformation matrices
disp('Tranformation matrices...')
h1 = H(4)/2;
h2 = H(3)/2;
S1 = [1 0 h2;...
      0 1  0;...
      0 0  1];
S2 = [1 0 -h1;...
      0 1  0;...
      0 0  1];
%% Assembly and displacement calculations
% Kelem1 = Elemental stiffness matrix for SDE with 1 = first element, 2 = 2nd element etc.
% Kthrowoff5 = Elemental stiffness matrix for throwoff Element with 5 = 5th element and 6 = 6th element
disp('Matrix assembly and displacement computing..')
Kelem1 = zeros(6,6); Kelem2 = zeros(6,6); Kelem3 = zeros(6,6); Kelem4 = zeros(6,6); 
Kthrowoff5= zeros(3,3); Kthrowoff6= zeros(3,3);
for i=1:length(omega)
    for j=1:n+m+l
        [Krod,Kbeam] = KrodKbeam(E(j),A(j),I(j),L(j),k1(i,j),k2(i,j));
        %% Spectral Damage element (SDE) calculations
        if (1<=j)&&(j<=4)
            eval(['Kelem' num2str(j) ' = ElemStiff(Krod,Kbeam);']); %% This function calculates element matrix for SDE
            Ksde = SDE(Kelem1,Kelem2,Kelem3,Kelem4,S1,S2); % This function do assembly for SDE
        %% Throw off element calculations
        elseif (5<=j)&&(j<=n+m)
            eval(['Kthrowoff' num2str(j) '= ThrowoffStiff(Krod,Kbeam);']);
        end
          Kassem11 = Ksde(1:3,1:3)+ Kthrowoff5;
          Kassem22 = Ksde(10:12,10:12)+ Kthrowoff6;
        %% Assembled matrix
        K = [ Kassem11        Ksde(1:3,4:12);...
              Ksde(4:9,1:12);...
              Ksde(10:12,1:9)     Kassem22];
    end
    %% Boundary condition --> u9 and u10 are fixed
    % K = Kassem(4:9,4:9);
    %% Displacement calculations
    U(:,i) = K\F(:,i);
end
%% Plot the frequency domain response
disp('Plotting Freq domain response..')
figure(1)
plot(freq(1:nfft/2),abs(U(1,1:nfft/2)),'-o'); % axial response
title('Axial frequency domain response')
figure(2)
plot(freq(1:nfft/2),abs(U(2,nfft/2))); % Flexural response
title('Flexural frequency domain response')
figure(3)
plot(freq(1:nfft/2),abs(U(3,1:nfft/2))); % shear response
title('Shear frequency domain response')
%% inverse fft
disp('Inverse fft..')
for i=1:12
    Utime(i,:) = ifft(U(i,:),'symmetric');
end
%% Plots for time domain response
disp('Plotting Time domain response..')
figure(4)
plot(time,Utime(1,:)); % axial response
title('time domain axial response')