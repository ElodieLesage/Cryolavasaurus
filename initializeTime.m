%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [IN,M] = initializeTime(IN,M)

% Book keeping on inputs
IN = parseTime(IN);

% Initialize time array and timestep
M.t       = 0; % Time [s]
M.step    = 0; % Timestep
IN.outInd = 0; % Index for output to console
IN.outInd2 = 0; % Index for composition output to console

end
























