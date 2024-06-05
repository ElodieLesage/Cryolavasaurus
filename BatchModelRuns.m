% Batch Model Runs
clc;  % Clear the command window
clear;  % Clear all variables

% Directory where scripts are stored
mainDir = 'Input/';

% Get a list of all subdirectories in the main directory
subDirs = dir(mainDir);
subDirs = subDirs([subDirs.isdir]);  % Filter only directories
subDirs = subDirs(~ismember({subDirs.name}, {'.', '..'}));  % Remove . and ..

% Initialize script path list
scriptPaths = {};

% Populate the list with full paths of the scripts in each subdirectory
for dirIndex = 1:length(subDirs)
    subDirName = subDirs(dirIndex).name;
    scriptsInSubDir = dir(fullfile(mainDir, subDirName, '*.m'));  % Only .m files
    for scriptIndex = 1:length(scriptsInSubDir)
        scriptName = scriptsInSubDir(scriptIndex).name;
        scriptPaths{end+1} = fullfile(mainDir, subDirName, scriptName);
    end
end

% Run each script in the list
for scriptRunIndex = 1:length(scriptPaths)
    % Clear variables except for 'scriptPaths', 'dirIndex', 'scriptRunIndex'
    clearvars -except scriptPaths dirIndex scriptRunIndex

    % Display which script is currently running (optional)
    fprintf('Running %s\n', scriptPaths{scriptRunIndex});

    % Run the script
    run(scriptPaths{scriptRunIndex});
end
