%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; clc;

% Base input file to pattern off of
baseFile = 'resInput_CM.m';

% Output set
inputSet = 'PROD_CM'; % Input folder name and output prefix

% Reservoir thickness range to loop over [km]
thickness = [0.200	0.500	1.000	2.500	5.000];

% Reservoir depth range to loop over [km]
depth = [1.000 2.500 5.000 10.000 15.000];

% Make 2D arrays
[T, D] = meshgrid(thickness,depth);

%%%%%%%%%%%%%%%%%%
% Prep folders 
%%%%%%%%%%%%%%%%%%
if exist(['Input/' inputSet],'dir')
    delete(['Input/' inputSet '/*']);
    rmdir(['Input/' inputSet]);
end
mkdir(['Input/' inputSet]);

%%%%%%%%%%%%%%%%%%
% Loop
%%%%%%%%%%%%%%%%%%
numInputs = numel(T);

for i=1:numInputs
    filename = ['Input/' inputSet '/' inputSet '_' num2str(i,'%02.0f') '.m'];
    copyfile(baseFile,filename);
    fid = fopen(filename,'r');

    % Store lines
    lines = {};
    j = 0;
    while ~feof(fid)
        j = j + 1;
        lines{j} = fgetl(fid); % Append each line to the cell array   

        if i<=5
            % Write Temporal res 
            if contains(lines{end}, 'IN.tOut ')
                lines{j} =  "IN.tOut = '0.1 kyr'; % Results (IN.tMult times slower w/ no res)";
            end

            if contains(lines{end}, 'IN.tOut2 ')
                lines{j} =  "IN.tOut2 = '0.1 kyr'; % Results (IN.tMult times slower w/ no res)";
            end

            if contains(lines{end}, 'IN.tMult = ')
                lines{j} =  "IN.tMult = 100;";
            end

            if contains(lines{end}, 'IN.tMult2 = ')
                lines{j} =  "IN.tMult2 = 100;";
            end
        else
            % Write Temporal res 
            if contains(lines{end}, 'IN.tOut ')
                lines{j} =  "IN.tOut = '0.5 kyr'; % Results (IN.tMult times slower w/ no res)";
            end

            if contains(lines{end}, 'IN.tOut2 ')
                lines{j} =  "IN.tOut2 = '0.5 kyr'; % Results (IN.tMult times slower w/ no res)";
            end

            if contains(lines{end}, 'IN.tMult = ')
                lines{j} =  "IN.tMult = 20;";
            end

            if contains(lines{end}, 'IN.tMult2 = ')
                lines{j} =  "IN.tMult2 = 20;";
            end
        end

        % Write Radius 
        if contains(lines{end}, 'IN.rRes')
            lines{j} =  ['IN.rRes = ' num2str(T(i)*1e3/2) ';'];
        end

        % Write Depth 
        if contains(lines{end}, 'IN.zResTop')
            lines{j} =  ['IN.zResTop = ' num2str(D(i)*1e3) ';'];
        end

        % Write Name Prefix 
        if contains(lines{end}, 'IN.namePrefix')
            lines{j} =  ['IN.namePrefix = '''  inputSet '_' num2str(i,'%02.0f') ''';'];
        end

        % Write Main directory
        if contains(lines{end}, 'main;')
            lines{j} =  ['run(''../../main.m'');'];
        end
        
    end
    fclose(fid);

    % Write the modified content back to the file
    fid = fopen(filename, 'w');
    for j = 1:length(lines)
        fprintf(fid, '%s\n', lines{j});
    end
    fclose(fid);

end

















