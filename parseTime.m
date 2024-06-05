%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function IN = parseTime(IN)

% seconds in time unit
IN.yr2s  = 365.25*24*3600;  % Handy dandy conversion
IN.kyr2s = 1e3 * IN.yr2s;   % Handy dandy conversion
IN.Myr2s = 1e6 * IN.yr2s;   % Handy dandy conversion
IN.Gyr2s = 1e9 * IN.yr2s;   % Handy dandy conversion

% Parse final time
timeStr = strsplit(IN.tMax);
val     = str2double(timeStr{1});
unit    = timeStr{2};

switch unit
    case 'yr'
        conversion = IN.yr2s;
    case 'kyr'
        conversion = IN.kyr2s;
    case 'Myr'
        conversion = IN.Myr2s;
    case 'Gyr'
        conversion = IN.Gyr2s;
    otherwise
        error('Incorrect timescale selected.');
end
IN.tMax = val*conversion;


% Parse output time
timeStr = strsplit(IN.tOut);
val     = str2double(timeStr{1});
unit    = timeStr{2};

switch unit
    case 'yr'
        conversion = IN.yr2s;
    case 'kyr'
        conversion = IN.kyr2s;
    case 'Myr'
        conversion = IN.Myr2s;
    case 'Gyr'
        conversion = IN.Gyr2s;
    otherwise
        error('Incorrect timescale selected.');
end
IN.tOut = val*conversion;


timeStr2 = strsplit(IN.tOut2);
val2     = str2double(timeStr2{1});
unit2    = timeStr2{2};

switch unit2
    case 'yr'
        conversion = IN.yr2s;
    case 'kyr'
        conversion = IN.kyr2s;
    case 'Myr'
        conversion = IN.Myr2s;
    case 'Gyr'
        conversion = IN.Gyr2s;
    otherwise
        error('Incorrect timescale selected.');
end
IN.tOut2 = val2*conversion;

% Parse emplacement delay
timeStr = strsplit(IN.tRes);
val     = str2double(timeStr{1});
unit    = timeStr{2};

switch unit
    case 'yr'
        conversion = IN.yr2s;
    case 'kyr'
        conversion = IN.kyr2s;
    case 'Myr'
        conversion = IN.Myr2s;
    case 'Gyr'
        conversion = IN.Gyr2s;
    otherwise
        error('Incorrect timescale selected.');
end
IN.tRes = val*conversion;

% Set time post-emplacement
IN.tMax = IN.tRes + IN.tMax;

% Get number of output timesteps
% Note that NOut and NOut2 are 10x longer when no reservoir
IN.NOut = ceil((IN.tMax+IN.tRes) / IN.tOut)+1; 
IN.NOut2 = ceil((IN.tMax+IN.tRes) / IN.tOut2)+1; 

end























