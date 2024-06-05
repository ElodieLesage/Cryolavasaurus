%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function MAT = initializeMaterials(BOD)

%%%%%%%%%%%%%%%%%%%%%%%
% General Properties
%%%%%%%%%%%%%%%%%%%%%%%
% Thermal
MAT.R = 8.314;   % Ideal gas constant [J mol-1 K-1]
MAT.L = 334e3;   % Latent heat of fusion [kJ/kg]
MAT.rho0 = 917; % Ref density of ice @ T0 [kg/m^3]

% Mechanical
MAT.nu    = 0.33;   % Poisson's ratio
MAT.Emod  = 9e9;    % Young's modulus [Pa]
MAT.Gmod  = MAT.Emod/(2*(1+MAT.nu));   % Elastic shear modulus [Pa]
MAT.Kmod  = MAT.Emod/(3*(1-2*MAT.nu)); % Bulk modulus [Pa]
MAT.Ea    = 59.4e3; % Activation Energy [J mol-1]
MAT.eta0  = MAT.Gmod/BOD.omega; % Reference viscosity that maximizes dissipation [Pa s]


end