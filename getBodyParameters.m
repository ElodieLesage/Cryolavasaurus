%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [BOD] = getBodyParameters(IN)

% Add bodies as new cases below
switch IN.body
    case 'Europa'
        BOD.g       = 1.315;   % Gravity [m/s^2]
        BOD.R       = 1561e3;  % Body radius [m]
        BOD.m       = 4.80e22; % Body mass [kg]
        BOD.A       = 0.55;    % bolometric albedo
        BOD.eps     = 0.9;     % Emissivity
        BOD.ob      = 3;       % obliquity [deg]
        BOD.RParent = 7.78e11; % orbital radius of system from sun [m]
        BOD.tOrb    = 306800;  % orbital period
        BOD.omega   = (2*pi)/BOD.tOrb;  % Orbital forcing frequency [rad/s]
        BOD.e0      = 1.5e-5;  % Tidal strain amplitude (tidal buldge height / body radius)
        BOD.QRad    = 230e9;   % Global radiogenic heat flow [W]

    otherwise
        error('Error. %s is not definited in getBodyParameters.m.',IN.body)
        
end


end