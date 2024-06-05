%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [M,OUT] = meltingFreezing(BOD,M,IN,COMP,OUT,MAT)


%%%%%%%%%%%%%%%%%%
% Ocean Melting/Freezing
%%%%%%%%%%%%%%%%%%
% NOTE: Ice melting is handled at the bottom of thermal solver. 

% Calculate change in melt
dE = M.dE_ocn;
dm = dE/MAT.L;    % Total change in melt mass
dv = dm/M.rhoOcn; % Total change in melt volume

M.dm_dt = dm/M.dt;

% New interface location
M.rOcnTop = ((3/(4*pi))*dv+M.rOcnTop^3)^(1/3);

% Fix temperatures
M.T(M.r<M.rOcnTop) = M.Tm_ocn;

% Set melt fractions
M.vfm(M.r_s<M.rOcnTop) = 1;
M.vfm(M.r_s>M.rOcnTop) = 0;
M.iOcnTop = find(M.r-M.rOcnTop<0,1,'last');
M.vfm(M.iOcnTop)       = (4/3)*pi*(M.rOcnTop^3 - M.r(M.iOcnTop)^3)/M.V_s(M.iOcnTop);

M.drained = 0; % flag for when reservoir drains to the ocean

%%%%%%%%%%%%%%%%%%
% Reservoir Melting/Freezing
%%%%%%%%%%%%%%%%%%
% NOTE: This works by getting the energy extracted from an annulus of water
% spanning the globe. We only use this energy value to calculate change in
% reservoir interface position. By calculating change in reservoir radius
% at the top and bottom, we can estimate overall change in reservoir volume
% effectively.

if M.vRes>0  

    % Fetch reservoir properties from composition data
    [T, rho, M.vlf0, M.vlf1, M.vif0, M.vif1] = coolFreeze(M, COMP, IN);
    
    % Update parameters
    M.rhoRes    = rho;
    M.Tm_res    = T;
    
    % Change in reservoir size
    vResOld     = M.vRes;
    M.vRes      = (4/3)*pi*IN.rRes^3 * M.vlf1; % New reservoir volume

    M.vRes(M.vRes<0) = 0; % Possible to have very tiny numerical error to produce negative values (order of 1e-9 m^3)
    rResDiff    = (3/(4*pi)*vResOld)^(1/3) - (3/(4*pi)*M.vRes)^(1/3); % Radius change

    % New interface location
    rResTopOld  = M.rResTop;
    rResBotOld  = M.rResBot;
    
    % Area correction to energy fraction because heat flux (and therefore
    % freezing rate) goes with 1/A
    fA_top = (M.ratioEtop / rResTopOld^2);
    fA_bot = M.ratioEbot / rResBotOld^2;
    fA_tot = fA_top + fA_bot;
    
    fA_top = fA_top/fA_tot;
    fA_bot = fA_bot/fA_tot;
    
    % Distribute a total of 2 dr over top and bottom
    M.rResTop   = rResTopOld - fA_top*2*rResDiff;
    M.rResBot   = rResBotOld + fA_bot*2*rResDiff;

    % Freezing front velocity
    M.freezeRateTop = 10*abs(rResTopOld-M.rResTop) / (M.dt/IN.yr2s) ; % in cm/yr %   - top:
    M.freezeRateBot = 10*abs(rResBotOld-M.rResBot) / (M.dt/IN.yr2s); % in cm/yr %   - bottom:
    M.freezeRate    = (M.freezeRateTop + M.freezeRateBot)/2; % in cm/yr %   - average top and bottom:
     
    % Advection due to settling
    % M.rResTop = M.rResTop;
    % M.rResBot = M.rResBot;

    % Check if drainage occurs
    if M.rResBot <= M.rOcnTop || M.rResBot <= (BOD.R-IN.H0) % Res descended to ocean
        M.rOcnTop = M.rResTop;
        M.T(M.r <= M.rResTop) = M.Tm_ocn;

        M.rRes = 0;
        M.rResBot = M.rOcnTop;

        M.iResTop = find(M.r-M.rResTop<0,1,'last');
        M.iResBot = find(M.r-M.rResBot>0,1,'first');

        M.vfm(M.r > M.rOcnTop) = 0;

        M.vfm(M.iResTop)       = (4/3)*pi*(M.rResTop^3 - M.r(M.iResTop)^3)/M.V_s(M.iResTop);
        M.vfm(M.iResBot)       = (4/3)*pi*(M.r(M.iResBot)^3-M.rResBot^3)/M.V_s(M.iResBot);

        M.drained   = 1;
        % M.tDrain    = M.t;

        M.vRes      = 0;

    else
        % Change in reservoir size and frozen fraction
        M.rRes  = (M.rResTop-M.rResBot)/2; % Reservoir radius
        M.rRes(M.rRes<0) = 0; % Possible to have very tiny numerical error to produce negative values (order of 1e-9 m)

        % Set Temp
        M.T(M.r > M.rResBot & M.r < M.rResTop) = M.Tm_res;
    
        % Set melt fractions
        M.vfm(M.r_s>M.rResBot & M.r_s<M.rResTop) = 1;
        M.iResTop = find(M.r-M.rResTop<0,1,'last');
        M.iResBot = find(M.r-M.rResBot>0,1,'first');
        M.vfm(M.iResTop)       = (4/3)*pi*(M.rResTop^3 - M.r(M.iResTop)^3)/M.V_s(M.iResTop);
        M.vfm(M.iResBot)       = (4/3)*pi*(M.r(M.iResBot)^3-M.rResBot^3)/M.V_s(M.iResBot);
    end
end



























