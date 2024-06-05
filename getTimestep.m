%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [M] = getTimestep(M,IN,MAT)
% Courant-Friedreichs-Lewy condition
CFL = 1/3;

% Thermal diffusion timestep
dt_th = 4*min(M.L.^2 ./ ((M.K(M.refInd)+(M.K(M.refInd+1))) .*(M.Nu(M.refInd)+(M.Nu(M.refInd+1)))));

% Radiative emission timestep (approx)
dt_emis = (M.rho(end-1) * M.Cp(end-1) * M.Tsurf * M.L(end-1))/M.qSol;

% Relaxation time
Tmax        = min(M.T(M.z>IN.zResTop+IN.rRes)); % Basal temp assumed to be coldest beneath res
M.eta_max   = MAT.eta0*exp(25.2*(273/Tmax-1)); % Relaxation viscosity 
M.tMaxwell  = M.eta_max / MAT.Emod; % Maxwell time

% Update Timestep
M.dt = CFL * min([dt_th,dt_emis]); 

end