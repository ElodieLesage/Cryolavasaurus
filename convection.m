%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M = convection(M,BOD,MAT)

% Find the depth that allows the timescale of heat advection to overcome
% the timescale of heat diffusion - Sam's notes for Convection, page titled
% "something"

% Only evaluate within the ice shell
indRange = find(M.r>M.rOcnTop); % Only nodes of solid ice are capable of convection

% Extract relevant viscosities
eta = M.eta(indRange);

% Temperature difference from ocean to layers of the ice shell
dT = M.Tm_ocn - M.T(indRange);

% Get ice shell radii
r_ice = M.r(indRange);

% Find effective solid ice volumes from ocean to node
V_eff = (4/3) * pi * (r_ice.^3 - M.rOcnTop^3);

% Get effective depth-dependent characteristic length scale
L_eff = V_eff./M.A(indRange);

% Calculate viscosity required as a function of depth to allow advection
% that overcomes diffusion, forced by buoyancy of materials from the
% ice-ocean interface
eta_crit = M.alpha(indRange) .* dT * MAT.rho0 * BOD.g .* L_eff.^3 ./ M.K(indRange);

% Find where eta_crit / eta >= 1 (where log10(eta_crit/eta) >= 0). Find the
% coldest node within the basal layer that satisfies this criteria.
% NOTE: Only look at the first crossing from log10(eta_crit/eta) >= 0 to
% log10(eta_crit/eta) < 0!!! Otherwise you'll capture effects from the
% reservoir artificially.

% Indices that meet convective criteria
convInd = find(log10(eta_crit./eta) >= 0);

% Radius of top of convection cell
rConvTop = [];

% Index of the top of the convection cell
nInd = numel(convInd);
if ~nInd
    % No convection
    rConvTop = M.rOcnTop;
elseif nInd == 1
    % only one possible place it could happen
    interpInd = [convInd, convInd+1];

    % Find radial location of convection cell top
    rConvTop  = interp1(eta_crit(interpInd)-eta(interpInd),r_ice(interpInd), 0,'pchip');
else
    % Make sure to get the correct zero crossing per the note above
    for i = 2:nInd
        if (isempty(rConvTop))
            % Found a second regime that we want to ignore
            if (convInd(i) - convInd(i-1) ~= 1)
                interpInd = [convInd(i-1), convInd(i-1)+1];

                % Find radial location of convection cell top
                rConvTop  = interp1(eta_crit(interpInd)-eta(interpInd),r_ice(interpInd), 0,'pchip');
            elseif (i == numel(convInd)) 
                interpInd = [convInd(i), convInd(i)+1];

                % Find radial location of convection cell top
                rConvTop  = interp1(eta_crit(interpInd)-eta(interpInd),r_ice(interpInd), 0,'pchip');
            end
        end
    end
end

%%%%%
% Implement convection
%%%%%

% Find convective solid ice volume
V_conv = (4/3) * pi * (rConvTop^3 - M.rOcnTop^3);

% Get convective characteristic length scale
L_conv = V_conv./(4*pi*rConvTop^2);

% Note, it is possible that the convective temperature is higher than the
% ocean temperature after a reservoir has frozen in place completely. Here,
% we capture this dynamically by looking at the mean of the highest and
% lowest temperatures, as the specific temperatures of the interior will
% evolve dynamically in this situation. 

% Get convective temperature
T_conv = (M.Tm_ocn + interp1(M.r,M.T,rConvTop))/2;

% Get convective temperature diff. 
dt_conv = M.Tm_ocn - T_conv;

% Ref specific heat cap. at melting temp
Cp0  =  7.0796 * M.Tm_ocn + 164.5780; 

% Get basal-heated Rayleigh number
Ra_b = M.alpha(1) * dt_conv * MAT.rho0 * BOD.g .* L_conv.^3 ./ (MAT.eta0 * M.k(1) / (MAT.rho0 * Cp0));

% Get Nusselt number within convection cell
Theta = max((MAT.Ea/MAT.R)*(M.Tm_ocn - T_conv)/(M.Tm_ocn^2));  % Number of viscosity e-foldings from dT
Theta(Theta<1) = 1;
Nu    = 1.89 * Theta^(-1.02) * Ra_b^(1/5); % Nusselt number
Nu(Nu<1) = 1;

% Store
M.rConvTop = rConvTop;
M.Ra = Ra_b;

M.Nu      = ones(1,numel(M.r)); 
M.Nu(M.r>M.rOcnTop & M.r<M.rConvTop) = Nu;

end















