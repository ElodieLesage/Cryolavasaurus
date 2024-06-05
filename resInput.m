%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc;

%%%%% TBD:
% Porosity
%%%%%

IN.namePrefix = 'PROD';

%%%%%%%%%%%%%%%%%%
% Model Timing
%%%%%%%%%%%%%%%%%%

IN.tRes  = '10 Myr'; % Time after which to start emplacement
IN.tMax  = '10 Myr'; % Model run time after emplacement, use 'yr' 'kyr' 'Myr' or 'Gyr'

% Output Frequency 
IN.tOut  = '1 kyr'; % Results (IN.tMult times slower w/ no res)
IN.tMult = 10; 

IN.tOut2 = '1 kyr'; % Movie (IN.tMult2 times slower w/ no res)
IN.tMult2 = 10;

IN.pltOn = 1;        % Plot output in real time
IN.movOn = 1;        % Save plot movie
IN.convection = 1;   % Turn convection on or off

%%%%%%%%%%%%%%%%%%
% Body Settings
%%%%%%%%%%%%%%%%%%
IN.body = 'Europa';   % Target of interest
IN.lat  = 0;          % Latitude of simulation (deg)
IN.tides = 1;         % Tidal heating (0 = off, 1 = on)

%%%%%%%%%%%%%%%%%%
% Geometry
%%%%%%%%%%%%%%%%%%
IN.H0  = 23.8e3;   % Initial ice shell thickness [m]
IN.setTargetThickness = 0;   % 0 - specify radiogenic only (BOD.Qrad), 1 - Specifiy desired thickness IN.H0
IN.Nz  = 250;      % Number of nodes in vertical  direction
IN.Nres = 10;      % Minimum number of resevoir nodes

% Geometry
IN.rRes    = 1e3;     % Initial reservoir radius [m]
IN.zResTop = 5e3;    % Initial reservoir top depth [m]

%%%%%%%%%%%%%%%%%%
% Thermal Properties
%%%%%%%%%%%%%%%%%%
% IN.Tm_ocn = 273;    % Melting temp of ocean [K] - NOTE: This should set 
% equal to the initial reservoir melting temperature 
IN.CpOcn  = 4184;     % Specific heat capacity [J/kg K]
MAT.L     = 330e3;    % Latent heat of fusion [kJ/kg]
IN.X      = 5e-10;    % Liquid water compressibility [Pa^-1]

%%%%%%%%%%%%%%%%%%
% Composition
%%%%%%%%%%%%%%%%%%
% 1  = Eq EM-CM carb
% 3  = Eq EM-CI carb
% 8  = Eq MC-Scale carb + comets
% 17 = Pure Water
IN.simu   = 1;       % Simulation number (see above)
IN.Ncomp  = 8;       % Number of species tracked

% Max number of eruptions
IN.nErupt = 1e4;

%%%%%%%%%%%%%%%%%%
% Run Model
%%%%%%%%%%%%%%%%%%
main;










































