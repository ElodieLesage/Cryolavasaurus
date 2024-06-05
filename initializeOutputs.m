%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [M,OUT,MISC] = initializeOutputs(IN,M,COMP)

% Make output directory
OUT.path = ['./Output/' IN.namePrefix ' H0-' num2str(IN.H0/1e3,'%0.1f') ' rRes-' num2str(IN.rRes/1e3,'%0.1f') ' zRes-' num2str(IN.zResTop/1e3,'%0.1f') ' ' COMP.sheets{IN.simu} '/'];
if ~exist(OUT.path,'dir')
    mkdir(OUT.path)
end

% Initialize and add the arrays to track here
OUT.t     = zeros(1,IN.NOut); % Time of output
OUT.dm_dt = zeros(1,IN.NOut); % Freezing rate [kg/s]
OUT.Tsurf = zeros(1,IN.NOut); % Surface Temperature
OUT.Dice  = zeros(1,IN.NOut); % Ice thickness

OUT.vRes  = zeros(1,IN.NOut); % Reservoir volume
OUT.rRes  = zeros(1,IN.NOut); % Reservoir radius
OUT.zRes  = zeros(1,IN.NOut); % Reservoir depth
OUT.fV    = zeros(1,IN.NOut); % Reservoir frozen fraction
OUT.Tmelt = zeros(1,IN.NOut); % Reservoir melting temperature
OUT.freezeRate    = zeros(1,IN.NOut); % Freezing front velocity – average
OUT.freezeRateTop = zeros(1,IN.NOut); % Freezing front velocity – top
OUT.freezeRateBot = zeros(1,IN.NOut); % Freezing front velocity – bottom
OUT.tMax = zeros(1,IN.NOut); % Maxwell timescale

% reservoir drainage to the ocean
OUT.tDrain = 0;

OUT.comp        = zeros(IN.Ncomp,IN.NOut); % composition
OUT.eruptTimes  = zeros(IN.nErupt,1);       % time of eruptions
OUT.eruptV      = zeros(IN.nErupt,1);       % volume of eruptions

OUT.Dconv = zeros(1,IN.NOut); % Convective thickness [m]
OUT.Nu    = zeros(1,IN.NOut); % Convective Nusselt Number 

OUT.t2    = zeros(1,IN.NOut2);% Time for composition outputs

% Plot items
MISC      = []; % Miscellaneous array collector
MISC.newPlot = 1; % Create plot for the first time when called

end