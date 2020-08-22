function Kelem = ElemStiff(Krod,Kbeam)
%% Elements of Stifness matrices using Rod and Beam matrices
% Rod stiffness matrix elements
K11rod = Krod(1,1); K12rod = Krod(1,2); K21rod = Krod(2,1); K22rod = Krod(2,2);
% Beam stiffness matrix elements
K11beam = Kbeam(1,1); K12beam = Kbeam(1,2); K13beam = Kbeam(1,3); K14beam = Kbeam(1,4);
K21beam = Kbeam(2,1); K22beam = Kbeam(2,2); K23beam = Kbeam(2,3); K24beam = Kbeam(2,4);
K31beam = Kbeam(3,1); K32beam = Kbeam(3,2); K33beam = Kbeam(3,3); K34beam = Kbeam(3,4);
K41beam = Kbeam(4,1); K42beam = Kbeam(4,2); K43beam = Kbeam(4,3); K44beam = Kbeam(4,4);
%% Stifness matrix for a laminate
Kelem = [  K11rod       0          0        K12rod      0             0;...
             0        K11beam    K12beam       0      K13beam    K14beam;...
             0        K21beam    K22beam       0      K23beam    K24beam;...
           K21rod        0          0       K22rod       0             0;...
             0        K31beam    K32beam       0      K33beam    K34beam;...
             0        K41beam    K42beam       0      K43beam    K44beam];
end