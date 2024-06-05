%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [COMP, M] = reservoirEmplacement(BOD,IN,M,COMP,MAT)

% Check if its time for reservoir emplacement
if (M.t>IN.tRes) && (M.resEmp == 0)

    % Set flag
    M.resEmp = 1;

    % Save temperature field
    Tinit = M.T;
    M.TstructFar= M.T; % Far field temp structure
    M.rOcnFar   = M.rOcnTop;    % Far field ice-ocean interface

    % Set temperature and melt fraction
    M.T(  (M.z  <=IN.zResTop+2*IN.rRes) & (M.z  >=IN.zResTop)) = M.Tm_res;
    M.vfm((M.z_s<=IN.zResTop+2*IN.rRes) & (M.z_s>=IN.zResTop)) = 1;
    
    % Find interfaces
    M.rResTop = M.r(end-1)-IN.zResTop;                % Reservoir top interface radius
    M.iResTop = find((M.rResTop - M.r>0)>0,1,'last'); % Reservoir top interface element index

    M.rResBot = M.r(end-1)-IN.zResTop-2*IN.rRes;      % Reservoir bottom interface radius
    M.iResBot = find((M.rResBot - M.r>0)>0,1,'last'); % Reservoir bottom interface element index
   
    % Set properties
    M.vlf0       = 1; % volumic liquid fraction before compression
    M.vlf1       = 1; % volumic liquid fraction after compression
    M.vif0       = 0; % volumic ice fraction before expansion
    M.vif1       = 0; % volumic ice fraction after expansion
    M.vShell    = 4/3*pi*M.rResTop^3 - 4/3*pi*M.rResBot^3; % volume of the liquid shell
    M.rRes      = (M.rResTop-M.rResBot)/2; % Reservoir radius
    M.vRes      = (4/3)*pi*M.rRes^3; % Reservoir volume
    M.vRes_old  = M.vRes;
    M.Vice0_old = 0;
    M.Vice1_old = 0;
    M.vRes_init = M.vRes;         % Initial reservoir volume 
    M.rhoRes    = M.rhoOcn;          % Reservoir density
    M.CpRes     = M.CpOcn;           % Reservoir specific heat capacity
    M.mRes      = M.vRes*M.rhoRes;   % Reservoir mass

    % Initialize energy
    [COMP, M]   = initializeEnergy(IN,COMP,M,MAT);

    % Threshold overpressure before eruption
    Ttop      = interp1(M.r,Tinit,M.rResTop,'pchip'); % far field temperature
    sigmaSurf = 1.7e6;    % Ice tensile strength at 100K [Pa]
    sigmaConv = 1e6;      % Ice tensile strength at 250K [Pa]
    sigmaFar  = sigmaSurf+(((sigmaConv-sigmaSurf)/150)*Ttop); % far field ice tensile strength
    P0        = IN.zResTop * BOD.g * MAT.rho0;
    M.DeltaPc = 2*(sigmaFar + P0);

    M.eruption = 1;
    M.canErupt = 1;

end

end
























