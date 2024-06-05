%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [M, IN] = initializeGrid(IN,BOD)

% Define useful values
rBot     = BOD.R - 1.2*IN.H0; % Radius at the base of the model [m]
rIce     = BOD.R - IN.H0;   % Radius at the base of the ice shell [m]
M.rOcnTop = rIce;           % Depth to ocean surface

% Made radial grid extending to ghost node in space
dr0  = (IN.H0/(IN.Nz)); % Approximate dr
M.r  = [linspace(rBot,BOD.R,IN.Nz-1), BOD.R+dr0]; % Radius from center of body [m]

% Calculate number of reservoir nodes, and force input if needed
numRes = sum((M.r>BOD.R-IN.zResTop-2*IN.rRes-dr0 & M.r < BOD.R-IN.zResTop+dr0));
if numRes < IN.Nres
    M.r(M.r>BOD.R-IN.zResTop-2*IN.rRes-dr0 & M.r < BOD.R-IN.zResTop+dr0) = [];
    
    % Make sure that resevoir has a minimum of 10 element resolution by adding
    % IN.Nres elements to resevoir
    r_res = linspace(BOD.R-IN.zResTop-2*IN.rRes-dr0,BOD.R-IN.zResTop+dr0,IN.Nres);
    M.r = unique(sort([M.r,r_res],'ascend'));
    IN.Nz = numel(M.r);
end

% Create geometric arrays
M.refInd = 1:IN.Nz-1;       % A useful index for referencing values 

M.dr = diff(M.r); % Element size [m]
M.z  = BOD.R - M.r; % Depth [z]
M.A  = 4 * pi * M.r.^2;

% Define the location of elements in thermal calculations. Note that M.r_s
% converges to the midpoint between nodes when ice thickness << body radius
% M.r_s = sqrt(M.r(M.refInd) .* M.r(M.refInd+1)); 
M.r_s = (M.r(2:end)+M.r(1:end-1))/2;
M.z_s = BOD.R - M.r_s; % Depth [z]

% Define element (staggered node) centered volumes and length scales
M.V_s = (4/3) * pi * (M.r(M.refInd+1).^3-M.r(M.refInd).^3);
M.L = M.V_s./M.A(M.refInd+1); % characteristic length scale on staggered nodes

% Define volumetric weights for interpolations used in n2sVolumetric
M.Vf1 = (M.r_s(M.refInd).^3 - M.r(M.refInd).^3)./  (M.r(M.refInd+1).^3 - M.r(M.refInd).^3); % Weighting for element i
M.Vf2 = (M.r(M.refInd+1).^3 - M.r_s(M.refInd).^3)./(M.r(M.refInd+1).^3 - M.r(M.refInd).^3); % Weighting for element i+1

end