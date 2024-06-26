%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [M] = initializeThermal(IN,BOD,COMP,M,MAT)

%%%%%%%%%%%%%%%%%%%%%%%
% Initialize melt 
%%%%%%%%%%%%%%%%%%%%%%%
rIce   = BOD.R - IN.H0;   % Radius at the base of the ice shell [m]

% *volume* fraction (on elements)
M.vfm = zeros(1,IN.Nz-1); 
M.vfm(M.r<rIce) = 1;
M.dm_dt = 0;  % Change in melt mass vs time

%%%%%%%%%%%%%%%%%%%%%%%
% Initialize reservoir/ocean parameters
%%%%%%%%%%%%%%%%%%%%%%%
% M.Tm_ocn = IN.Tm_ocn; % Melt temperature in ocean
M.Tm_ocn = COMP.temps{IN.simu}(1);
% M.rhoOcn = IN.rhoOcn; % Density in ocean
M.rhoOcn = COMP.rho_l{IN.simu}(1);
M.CpOcn  = IN.CpOcn;  % Specific heat capacity in ocean

% M.fV     = 0;       % Frozen volume fraction of reservoir 
M.resEmp = 0;         % Flag for empalcement of reservoir
M.Tm_res = M.Tm_ocn;  % Melt temperature in reservoir
M.rhoRes = M.rhoOcn;  % Density in reservoir
M.CpRes  = IN.CpOcn;  % Specific heat capacity in reservoir

% Track interface(s)
M.rOcnTop = rIce;                   % Ocean top interface radius

M.iResTop = []; % Reservoir top interface element index
M.rResTop = []; % Reservoir top interface radius

M.iResBot = []; % Reservoir bottom interface element index
M.rResBot = []; % Reservoir bottom interface radius

M.rRes = 0; % Reservoir radius
M.vRes = 0; % Reservoir volume
M.mRes = 0; % Reservoir mass

M.canErupt = 0; % Cant erupt until emplaced
M.convRes = 0; % convection has reached reservoir
M.deltaP_residual = 0; % No residual pressure before eruption
M.DeltaPc = 2*IN.zResTop * BOD.g * MAT.rho0; % 2*Overburden for initial critial pressure
M.deltaP = 0; % No initial pressure
M.fE_rmn = 1; % Starts w/ all res energy

M.drained = 0; % will turn to 1 if reservoir drains into the ocean

%%%%%%%%%%%%%%%%%%%%%%%
% Initialize surface parameters
%%%%%%%%%%%%%%%%%%%%%%%
% First, we must get the surface temperature that matches the steady state
% conductive thickness prescribed
sigma  = 5.67e-8;     % Stefan Boltzamnn constant [W m^-2 K^-4]
m      = 18.01528e-3; % Molar weight of H2O [kg mol^-1]
R      = 8.314;       % Ideal gas constant [J mol^-1 K^-1]
Es     = 3.8e26;      % Solar output [W]


% Search array
TsurfTemp = linspace(10,273,1000); % Surface temperature range to search [K]

%%%%%%%%%%%%%%%%%%%%%%%
% Radiogenic heat flux
%%%%%%%%%%%%%%%%%%%%%%%
qRad = BOD.m * 4.5e-12 / (4 * pi * BOD.R^2); % Radiogenic heat flux [W/m^2]

%%%%%%%%%%%%%%%%%%%%%%%
% Emissive heat flux
%%%%%%%%%%%%%%%%%%%%%%%
qEmis = BOD.eps * sigma * TsurfTemp.^4;

%%%%%%%%%%%%%%%%%%%%%%%
% Solar insolation heat flux
%%%%%%%%%%%%%%%%%%%%%%%
% Oj + Stev https://reader.elsevier.com/reader/sd/pii/0019103589900523
Fs0  = Es / (4 * pi * BOD.RParent^2);   % solar insolation at equatiorial high noon [W/m^2]
clat = 90 - IN.lat;                         % Co-latitude
Fs   = Fs0 * sqrt((BOD.ob*pi/180)^2 + (clat*pi/180)^2) / (pi * sqrt(2)); % Obliquity and colatitude correction
qSol = (1-BOD.A) * Fs; % Average annual solar insolation [W/m^2]

%%%%%%%%%%%%%%%%%%%%%%%
% Sublimation heat flux
%%%%%%%%%%%%%%%%%%%%%%%
% Calculate latent heat of sublimation
% Polynomial curve fits to Table 2.1. R. R. Rogers; M. K. Yau (1989).
% BOD.A Short Course in Cloud Physics (3rd ed.). Pergamon Press. p. 16.
% ISBN 0-7506-3215-1.
L = (2834.1 - 0.29*TsurfTemp - 0.004*TsurfTemp.^2)*1e3;

% Calculate the partial pressure of ice
% https://agupubs.onlinelibrary.wiley.com/doi/abs/10.1029/93GL00105
% NOTE log = log10 in this paper, not ln
pA = -2663.5; % empirical coefficient
pB = 12.537;  % empirical coefficient
P = 10.^(pA./TsurfTemp + pB); % partial pressure [Pa]

% heat flux
qSub = L .* P .* sqrt(m./(2 * pi * R * TsurfTemp));

%%%%%%%%%%%%%%%%%%%%%%%
% Required Geologic Heat Flux [W/m^2]
%%%%%%%%%%%%%%%%%%%%%%%
qIn   = qSol;          % Paid into heat budget
qOut  = qEmis + qSub;  % Withdrawn from heat budget
qAnom = qOut-qIn;      % Anomalous heat flux

%%%%%%%%%%%%%%%%%%%%%%%
% Find Nominal Surface Temp 
%%%%%%%%%%%%%%%%%%%%%%%
Tsurf_0_init  = interp1(qAnom,TsurfTemp,0,'pchip'); % First guess without geologic heatflow [K]
Tsurf_0       = Tsurf_0_init;               % Initial Surface temperature [K]
z             = linspace(0,IN.H0,1000);     % Depth profile [m]

dT_crit = 1e-5; % Convergence criterion for surface temperature [K]
T_old   = 0;    % Old surface temperature [K]
while abs(Tsurf_0-T_old) > dT_crit
    T_z   = Tsurf_0*(M.Tm_ocn/Tsurf_0).^(z/IN.H0);             % Temperature profile
    k     = mean(632 ./ T_z + 0.38 - 1.97e-3 .* T_z);          % Mean solid ice conductivity [W/m K]
    qIce  = (k * (M.Tm_ocn - Tsurf_0)) * (1/IN.H0 + 1/BOD.R);  % Heat flux through ice evaluated at the surface [W/m^2]
    T_old = Tsurf_0;                                           % Store previous result
    Tsurf_0  = interp1(qAnom-qIce,TsurfTemp,0,'pchip');                % New surface temperature guess
end

%%%%%%%%%%%%%%%%%%%%%%%
% Store Results
%%%%%%%%%%%%%%%%%%%%%%%
M.Tsurf_0 = Tsurf_0;            % Initial surface temperature [K]
M.Tsurf   = M.Tsurf_0;          % Surface temperature [K]

if IN.setTargetThickness
    M.QIce_0 = qIce*4*pi*BOD.R^2;  % Initial required heat flow to balance T (will be applied to base of shell) [W]
else
    M.QIce_0 = BOD.QRad; % Radiogenic power production at Europa [W]
end

M.qSol    = qSol;               % Solar insolation heat flux 
M.qRad    = qRad;               % Radiogenic heat flux 
M.qLoss   = qIce;               % Heat flux from interior through ice shell [W/m^2]

%%%%%%%%%%%%%%%%%%%%%%%
% Now, thermal structure can be created
%%%%%%%%%%%%%%%%%%%%%%%
% Steady state conductive structure 
z_eff     = (1./(BOD.R-M.r) + 1/(BOD.R)).^-1; % corrected effective depth
z_max_eff = (1/IN.H0 + 1/(BOD.R)).^-1;        % corrected effective thickness
M.T       = M.Tsurf_0*(M.Tm_ocn/M.Tsurf_0).^((BOD.R-M.r)/IN.H0);

% Enforce space BCs
M.T(end-1:end) = M.Tsurf_0;

% Enforce ocean
M.T(M.r<rIce) = M.Tm_ocn;

% Initialize Nusselt number on the staggered nodes (elements)
M.Nu = ones(1,IN.Nz); 

% No convection at onset
M.rConvTop = M.rOcnTop;

%%%%%%%%%%%%%%%%%%%%%%%
% Initialize thermal properties
%%%%%%%%%%%%%%%%%%%%%%%
[M] = getThermalProperties(M,MAT);

% Tidal heating rate
M.H = zeros(1,IN.Nz); 

end
























