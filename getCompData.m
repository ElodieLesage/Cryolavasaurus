%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function COMP = getCompData(IN)

% reads the name of sheets in composition data file
COMP.sheets = sheetnames('CompData.xlsx');

i = IN.simu;

% possible to make iterative to use all compositions:
% for i = 1:length(COMP.sheets)

    % reads composition data sheets
    COMP.Table{i}   = readtable('CompData.xlsx','sheet', COMP.sheets{i}, 'PreserveVariableNames',true);

    % starts at liquidus:
    start = 1;
    
    % temperature cell array
    COMP.temps{i}   = table2array(COMP.Table{i}(start:end,1)).';
    
    % liquid volume cell array
    COMP.V_l{i}     = table2array(COMP.Table{i}(start:end,2)).'/1e6;
    
    % liquid density
    COMP.rho_l{i}   = table2array(COMP.Table{i}(start:end,3)).'*1000;
    
    % ice volume
    COMP.V_ice{i}   = table2array(COMP.Table{i}(start:end,4)).'/1e6;
    
    % making volumes cumulative for the Fractional Freezing cases
    if contains(COMP.sheets{i}, 'Frac') == 1
        COMP.V_ice{i} = cumsum(COMP.V_ice{i});
    end
    
    % volumic liquid fraction (before compression)
    % COMP.V_init{i}  = table2array(COMP.Table{i}(1,2)) / 1e6;
    COMP.V_init{i}   = COMP.V_l{i}(1);
    COMP.vlf0{i}     = COMP.V_l{i} ./ COMP.V_init{i}; % /!\ vlf0 = liquid volume is conserve (= no eruption)

    if isempty(COMP.vlf0{i}(COMP.vlf0{i}>1)) == false
        COMP.vlf0{i}(COMP.vlf0{i}>1) = 1; % "noise" in comp. data
    end
    
    % volumic ice fraction before expansion
    COMP.vif0{i}     = 1 - COMP.vlf0{i}; 

    % volumic ice fraction after expansion
    COMP.vif1{i}     = COMP.V_ice{i} ./ COMP.V_init{i}; % issue with datasets where V_i is well bellow 1e-3!!!

    % volumic liquid fraction after compression
    COMP.vlf1{i}     = 1 - COMP.vif1{i};
    
    % number of rows
    nrows            = length(COMP.temps{i});
    
    % reads salt concentrations
    COMP             = getSalts(COMP, i, nrows);
    
    % reads hydrate solution volumes
    COMP             = getHydrates(COMP, i, nrows);

% end

disp('Composition data imported')

end
