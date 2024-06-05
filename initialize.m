%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read Composition Data
COMP = getCompData(IN);

% Initialize Body
BOD = getBodyParameters(IN);

% Initialize Material Properties
MAT = initializeMaterials(BOD);

% Initialize Grid
[M, IN] = initializeGrid(IN,BOD);

% Initialize porosity
M.phi = zeros(size(M.r));

% Initialize Thermal Structure
M = initializeThermal(IN,BOD,COMP,M,MAT);

% Initialize Time
[IN, M] = initializeTime(IN,M);

% Initialize Outputs
[M,OUT,MISC] = initializeOutputs(IN,M,COMP);

% Reservoir properties
[COMP, M] = initializeEnergy(IN,COMP,M,MAT);