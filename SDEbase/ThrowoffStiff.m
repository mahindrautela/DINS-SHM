function Kthrowoff = ThrowoffStiff(Krod,Kbeam)
K11rod = Krod(1,1);
% Beam stiffness matrix elements
K11beam = Kbeam(1,1); K12beam = Kbeam(1,2); 
K21beam = Kbeam(2,1); K22beam = Kbeam(2,2);
%% Stifness matrix for a laminate
Kthrowoff = [K11rod       0               0;...
               0       K11beam      K12beam;...
               0       K21beam      K22beam];
end