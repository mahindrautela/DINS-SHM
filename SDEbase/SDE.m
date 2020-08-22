function Ksde = SDE(Kelem1,Kelem2,Kelem3,Kelem4,S1,S2) % SDE = Spectral Damage Element
nullvect = zeros(3,3);
%% Elements matrix
Kelem1_11 = Kelem1(1:3,1:3); Kelem1_12 = Kelem1(1:3,4:6); Kelem1_21 = Kelem1(4:6,1:3); Kelem1_22 = Kelem1(4:6,4:6);
Kelem2_11 = Kelem2(1:3,1:3); Kelem2_12 = Kelem2(1:3,4:6); Kelem2_21 = Kelem2(4:6,1:3); Kelem2_22 = Kelem2(4:6,4:6);
Kelem3_11 = Kelem3(1:3,1:3); Kelem3_12 = Kelem3(1:3,4:6); Kelem3_21 = Kelem3(4:6,1:3); Kelem3_22 = Kelem3(4:6,4:6);
Kelem4_11 = Kelem4(1:3,1:3); Kelem4_12 = Kelem4(1:3,4:6); Kelem4_21 = Kelem4(4:6,1:3); Kelem4_22 = Kelem4(4:6,4:6);
%% Assembled matrix
K = [Kelem1_11                      Kelem1_12                                          nullvect                               nullvect;...
     Kelem1_21    Kelem1_22+(S1'*Kelem4_11*S1)+(S2'*Kelem3_11*S2)        (S1'*Kelem4_12*S1)+(S2'*Kelem3_12*S2)                nullvect;...
     nullvect           (S1'*Kelem4_21*S1)+(S2'*Kelem3_21*S2)         Kelem2_11+(S1'*Kelem4_22*S1)+(S2'*Kelem3_22*S2)        Kelem2_12;...
     nullvect                      nullvect                                          Kelem2_21                               Kelem2_22];
Ksde=K;
 %% Node condensation
% Kaa = K(7:12,7:12);
% Kac = K(7:12,1:6);
% Kca = K(1:6,7:12);
% Kcc = K(1:6,1:6);
% Ksde = Kaa - Kac*inv(Kcc)*Kca;
end