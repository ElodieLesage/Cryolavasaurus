%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [COMP, M] = initializeEnergy(IN,COMP,M,MAT)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the energy loss from liquid at 
% each temperature step and how it's spent
% from composition data file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

i = IN.simu;
nrows = length(COMP.temps{i});

% total energy in reservoir at liquidus
E_init              = COMP.rho_l{i}(1)*COMP.V_init{i}(1) * (COMP.temps{i}(1)*M.CpRes + MAT.L);

prevT(1)            = 0;                            % temperature at previous temp. step
prevT(2:nrows)      = COMP.temps{i}(1:nrows-1);          
prevV_l(1)          = 0;                            % liquid volume at previous temp. step
prevV_l(2:nrows)    = COMP.V_l{i}(1:nrows-1);
prevrho_l(1)        = 0;                            % liquid density at previous temp. step
prevrho_l(2:nrows)  = COMP.rho_l{i}(1:nrows-1);

dT(1)               = 0;                            % change in temperature
dT(2:nrows)         = COMP.temps{i}(2:nrows) - prevT(2:nrows);   
dV_l(1)             = 0;                            % change in liquid volume
dV_l(2:nrows)       = COMP.V_l{i}(2:nrows) - prevV_l(2:nrows);
drho_l(1)           = 0;                            % change in liquid density
drho_l(2:nrows)     = COMP.rho_l{i}(2:nrows) - prevrho_l(2:nrows);

% energy variation in liquid:
dE_cool(1)          = 0;                           % energy spent in cooling    
dE_cool(2:nrows)    = dT(2:nrows).*prevrho_l(2:nrows)*M.CpRes.*prevV_l(2:nrows);
dE_freez(1)         = 0;                           % energy spent in freezing    
dE_freez(2:nrows)   = dV_l(2:nrows).*prevrho_l(2:nrows)*MAT.L;                     
dE                  = dE_cool + dE_freez;          % total d energy

% cumulative d energies
DeltaE              = cumsum(dE);
COMP.DeltaE{i}      = DeltaE;
COMP.fE_rmn{i}      = (E_init+DeltaE)/E_init;       % fraction of energy remaining

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now initialize energy we'll calculate 
% using thermal solver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

M.DeltaEtop = 0;
M.DeltaEbot = 0;
M.DeltaE    = 0;
M.vShell    = 4/3*pi*((M.r(end-1)-IN.zResTop)^3 - (M.r(end-1)-IN.zResTop-2*IN.rRes)^3); % volume of the liquid shell
M.E_init    = M.rhoRes*M.vShell*(M.CpRes*M.Tm_res+MAT.L); % /!\ energy in the liquid shell, not the spherical res






end










