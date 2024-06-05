%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M = thermalSolver(M,IN,BOD,MAT)

% Get tidal heating
M = tidalHeating(M,IN,BOD,MAT);

% Get surface heat flux
M = getSurfaceHeatFlux(M,IN,BOD);

% Initialize temperature change array
M.dT = zeros(1,IN.Nz); % Primary nodes

% Main thermal diffusion solve
refIndT = 2:IN.Nz -1; % indices of solution

% Precomputed values based on refIndT indices
r_refIndT = M.r(refIndT);
dr_refIndT = M.dr(refIndT);
rho_refIndT = M.rho(refIndT);
Cp_refIndT = M.Cp(refIndT);
k_refIndT = M.k(refIndT);
T_refIndT = M.T(refIndT);

% Prefactor
A = - 2 * M.dt ./ (rho_refIndT.*Cp_refIndT.*r_refIndT.^2.*(M.dr(refIndT-1)+dr_refIndT));

% Staggered node location
r_A = sqrt(r_refIndT.*M.r(refIndT-1));
r_B = sqrt(M.r(refIndT+1).*r_refIndT);

% Heat flux equality
k_A = (k_refIndT.*M.k(refIndT-1).*(r_refIndT-M.r(refIndT-1)))./(k_refIndT.*(r_A-M.r(refIndT-1))+M.k(refIndT-1).*(r_refIndT-r_A));
k_B = (M.k(refIndT+1).*k_refIndT.*(M.r(refIndT+1)-r_refIndT))./(M.k(refIndT+1).*(r_B-r_refIndT)+k_refIndT.*(M.r(refIndT+1)-r_B));

% Apply nusselt number where convection occurs
if IN.convection
    M = convection(M,BOD,MAT);
end
k_A = M.Nu(refIndT) .* k_A;
k_B = M.Nu(refIndT) .* k_B;

% Staggered node heat fluxes
q_A = - k_A .* (T_refIndT-M.T(refIndT-1)) ./ (M.dr(refIndT-1));
q_B = - k_B .* (M.T(refIndT+1)-T_refIndT) ./ (dr_refIndT);

% Staggered node heat flows
Q_A = r_A.^2 .* q_A;
Q_B = r_B.^2 .* q_B;

% Apply heat flow boundary condition
Q_B(end) = M.qLoss * BOD.R^2;

% Temperature change
M.dT(refIndT) = A .* (Q_B - Q_A) + (M.dt./(rho_refIndT .* Cp_refIndT)) .* M.H(refIndT);

if ~isreal(M.dT)
    stopdoingthings
end

% Update temperatures
M.T = M.T + M.dT;

% Apply boundary conditions to ghost nodes
M.Tsurf  = M.T(end-1);
M.T(end) = M.Tsurf; % Zero out dT in space
M.T(1)   = M.Tm_ocn;

% Track energy in to ocean (negative outward)
dE_melt = 0; % Excess thermal energy in ice
if max(M.T(M.z>IN.zResTop+2*IN.rRes))>M.Tm_ocn
    % Get indices of ice that needs to melt
    meltInd = find(M.T>M.Tm_ocn);
    meltInd(M.r(meltInd)>M.rResBot) = [];

    % Get excess temperature fraction
    T_excess = M.T(meltInd)-M.Tm_ocn;
    f_excess = T_excess./M.dT(meltInd);
    
    % Calcualte excess energy to give back to ocean
    dE_melt = sum(f_excess.*(4*pi*M.dt*(Q_B(meltInd-1) - Q_A(meltInd-1))));

    % Restore temperature now that excess energy is removed
    M.T(meltInd) = M.Tm_ocn;
end

M.dE_ocn = -4*pi*M.dt*(interp1(M.r_s(refIndT),Q_B,M.rOcnTop,'pchip')); % Energy in from top
M.dE_ocn = M.dE_ocn + M.dt*M.QIce_0; % Use radiogenic input to prevent ocean freezing
M.dE_ocn = M.dE_ocn + dE_melt; % Add back energy from excess temperature in ice

% Track Energy in to reservoir
if M.vRes>0 
    dEtop            = -4*pi*M.dt*(interp1(M.r_s(refIndT),Q_B,M.rResTop,'pchip')); % Energy in from top
    dEbot            =  4*pi*M.dt*(interp1(M.r_s(refIndT),Q_A,M.rResBot,'pchip')); % Energy in from bottom

    M.DeltaEtop      = M.DeltaEtop + dEtop; % cumulative energy variation
    M.DeltaEbot      = M.DeltaEbot + dEbot;
    M.DeltaE         = M.DeltaEtop + M.DeltaEbot;
    M.ratioEtop      = dEtop / (dEtop + dEbot); % ratio of energy leaving from top
    M.ratioEbot      = dEbot / (dEtop + dEbot); % ratio of energy leaving from bottom
    M.fE_rmn         = (M.E_init + M.DeltaE) / M.E_init;
end


























