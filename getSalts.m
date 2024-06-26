%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function COMP = getSalts(COMP, i, nrows)


try
    COMP.Ca{i}     = table2array(COMP.Table{i}(:,["Ca (mol/(kg water))"])).';
catch
    COMP.Ca{i}     = zeros(nrows,1);
end
% COMP.Ca{i}         = COMP.Ca{i}(~isnan(COMP.Ca{i}));

try
    COMP.Mg{i}     = table2array(COMP.Table{i}(:,["Mg (mol/(kg water))"])).';
catch
    COMP.Mg{i}     = zeros(nrows,1);
end
% COMP.Mg{i}         = COMP.Mg{i}(~isnan(COMP.Mg{i}));

try
    COMP.Na{i}     = table2array(COMP.Table{i}(:,["Na (mol/(kg water))"])).';
catch
    COMP.Na{i}     = zeros(nrows,1);
end    
% COMP.Na{i}         = COMP.Na{i}(~isnan(COMP.Na{i}));

try    
    COMP.K{i}      = table2array(COMP.Table{i}(:,["K (mol/(kg water))"])).';
catch
    COMP.K{i}      = zeros(nrows,1);
end   
% COMP.K{i}          = COMP.K{i}(~isnan(COMP.K{i}));
    
try    
    COMP.Cl{i}     = table2array(COMP.Table{i}(:,["Cl (mol/(kg water))"])).';
catch
    COMP.Cl{i}     = zeros(nrows,1);
end
% COMP.Cl{i}         = COMP.Cl{i}(~isnan(COMP.Mg{i}));
    
try    
    COMP.S{i}      = table2array(COMP.Table{i}(:,["S (mol/(kg water))"])).';
catch
    COMP.S{i}      = zeros(nrows,1);
end
% COMP.S{i}          = COMP.S{i}(~isnan(COMP.S{i}));

try
    COMP.C{i}      = table2array(COMP.Table{i}(:,["C (CO2+carbonate) (mol/(kg water))"])).';
catch
    COMP.C{i}      = zeros(nrows,1);
end
% COMP.C{i}          = COMP.C{i}(~isnan(COMP.C{i}));

try
    COMP.Si{i}     = table2array(COMP.Table{i}(:,["Si (mol/(kg water))"])).';
catch
    COMP.Si{i}     = zeros(nrows,1);
end
% COMP.Si{i}         = COMP.Si{i}(~isnan(COMP.Si{i}));

try
    COMP.Mtg{i}    = table2array(COMP.Table{i}(:,["Mtg (mol/(kg water))"])).';
catch
    COMP.Mtg{i}    = zeros(nrows,1);
end
% COMP.Mtg{i}        = COMP.Mtg{i}(~isnan(COMP.Mtg{i}));


end