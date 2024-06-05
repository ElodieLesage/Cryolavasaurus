%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CRYOLAVASAURUS
%
% Multiphase 1-dimensional Icy Body Thermal Solver
% Spherically symmetric solver for the heat diffusion equation, explicit
% finite difference in time. Tailored for applications to cryovolcanically
% active icy shells with considerations for phase change, reservoir freezing, and 
% eruption.
%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%******** RUN FROM resInput.m **********

%%%%%%%%%%%%%%%%%%
% Initialize Model
%%%%%%%%%%%%%%%%%%
initialize;

%%%%%%%%%%%%%%%%%%
% Main Time Loop
%%%%%%%%%%%%%%%%%%
while M.t < IN.tMax
    
    % Get timestep
    M = getTimestep(M,IN,MAT);
    
    % Determine whether to emplace reservoir
    [COMP, M] = reservoirEmplacement(BOD,IN,M,COMP,MAT);

    % Temperature diffusion solve
    M = thermalSolver(M,IN,BOD,MAT);
        
    % Move interfaces
    M = meltingFreezing(BOD,M,IN,COMP,OUT,MAT);
    
    % Eruption and relaxation
    [M, OUT] = Eruption(IN,COMP,M,OUT);
    
    % Update time 
    M.t    = M.t + M.dt;
    M.step = M.step + 1;

    % Update thermal properties
    M = getThermalProperties(M,MAT);

    % Generate Output
    [IN, OUT, MISC] = outputManager(M,IN,BOD,COMP,OUT,MISC,MAT);

end
