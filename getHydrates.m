%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Composition of the remaining fluid in term of aqueous solutions
% and salt assemblages.
% All these are expressed as a fraction of the initial volume.


function COMP = getHydrates(COMP, i, nrows)

% Gypsum: CaSO4+2H2O
try
    COMP.Gypsum{i}          = table2array(COMP.Table{i}(:,["Gypsum (cm3)"])).';
    COMP.Gypsum{i}          = COMP.Gypsum{i} ./ COMP.V_l{i}(1);
catch
    COMP.Gypsum{i}          = zeros(nrows,1);
end

% Calcite: CaCO3
try
    COMP.Calcite{i}         = table2array(COMP.Table{i}(:,["Calcite (cm3)"])).';
    COMP.Calcite{i}         = COMP.Calcite{i} ./ COMP.V_l{i}(1);
catch
    COMP.Calcite{i}         = zeros(nrows,1);
end

% Meriadiniite: MgSO4+11H2O
try
    COMP.Meridianiite{i}    = table2array(COMP.Table{i}(:,["Meridianiite (cm3)"])).';
    COMP.Meridianiite{i}    = COMP.Meridianiite{i} ./ COMP.V_l{i}(1);
catch
    COMP.Meridianiite{i}    = zeros(nrows,1);
end

% Mirabilite: Na2SO4+10H2O
try
    COMP.Mirabilite{i}      = table2array(COMP.Table{i}(:,["Mirabilite (cm3)"])).';
    COMP.Mirabilite{i}      = COMP.Mirabilite{i} ./ COMP.V_l{i}(1);
catch
    COMP.Mirabilite{i}      = zeros(nrows,1);
end

% Hydrohalite: NaCl+2H2O
try
    COMP.Hydrohalite{i}     = table2array(COMP.Table{i}(:,["Hydrohalite (cm3)"])).';
    COMP.Hydrohalite{i}     = COMP.Hydrohalite{i} ./ COMP.V_l{i}(1);
catch
    COMP.Hydrohalite{i}     = zeros(nrows,1);
end

% Sylvite: KCl
try
    COMP.Sylvite{i}         = table2array(COMP.Table{i}(:,["Sylvite (cm3)"])).';
    COMP.Sylvite{i}         = COMP.Sylvite{i} ./ COMP.V_l{i}(1);
catch
    COMP.Sylvite{i}         = zeros(nrows,1);
end

% Ikaite: CaCO3+6H2O
try
    COMP.Ikaite{i}          = table2array(COMP.Table{i}(:,["Ikaite (cm3)"])).';
    COMP.Ikaite{i}          = COMP.Ikaite{i} ./ COMP.V_l{i}(1);
catch
    COMP.Ikaite{i}          = zeros(nrows,1);
end

% Nahcolite: NaHCO3 (or Na2CO3+H2O or Na2CO3+7H2O ??? Ask Marc and Mariam)
try
    COMP.Nahcolite{i}       = table2array(COMP.Table{i}(:,["Nahcolite (cm3)"])).';
    COMP.Nahcolite{i}       = COMP.Nahcolite{i} ./ COMP.V_l{i}(1);
catch
    COMP.Nahcolite{i}       = zeros(nrows,1);
end

% Dolomite: CaMg(CO3)2
try
    COMP.Dolomite{i}        = table2array(COMP.Table{i}(:,["Dolomite (cm3)"])).';
    COMP.Dolomite{i}        = COMP.Dolomite{i} ./ COMP.V_l{i}(1);
catch
    COMP.Dolomite{i}        = zeros(nrows,1);
end

% Picromerite: MgSO4+K2SO4+6H2O
try
    COMP.Picromerite{i}     = table2array(COMP.Table{i}(:,["Picromerite (cm3)"])).';
    COMP.Picromerite{i}     = COMP.Picromerite{i} ./ COMP.V_l{i}(1);
catch
    COMP.Picromerite{i}     = zeros(nrows,1);
end

% Magnesite: MgCO3
try
    COMP.Magnesite{i}       = table2array(COMP.Table{i}(:,["Magnesite (cm3)"])).';
    COMP.Magnesite{i}       = COMP.Magnesite{i} ./ COMP.V_l{i}(1);
catch
    COMP.Magnesite{i}       = zeros(nrows,1);
end



















