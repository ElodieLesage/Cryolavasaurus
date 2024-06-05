%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M = tidalHeating(M,IN,BOD,MAT)

% Tidal heat generation rate - Mitri and Showman, 2005/ Showman and
% Han 2004 JGR Planets 
% q = (e0^2 + w^2 + eta) / [2 * (1 + w^2 * eta^2 / mu^2)

if IN.tides % Only set to non-zero values if asked
    M.H = (BOD.e0^2 * BOD.omega^2 * M.eta) ./ (1 + (BOD.omega^2 * M.eta.^2)/(MAT.Gmod^2)); % Volumetric dissipation [W/m^3]

    % Dont heat the ocean, or the reservoir
    if M.resEmp % check to see if reservoir is erupting
        M.H((((M.r < M.rResTop) & (M.r > M.rResBot )) | (M.r < M.rOcnTop))) = 0;
    else
        M.H(M.r < M.rOcnTop) = 0;
    end
end