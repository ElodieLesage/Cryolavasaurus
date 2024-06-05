%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [M, OUT] = Eruption(IN,COMP,M,OUT)

% Track Erupted composition:
M.compCa  = interp1(COMP.fE_rmn{IN.simu},COMP.Ca{IN.simu},M.fE_rmn,'pchip');
M.compMg  = interp1(COMP.fE_rmn{IN.simu},COMP.Mg{IN.simu},M.fE_rmn,'pchip');
M.compNa  = interp1(COMP.fE_rmn{IN.simu},COMP.Na{IN.simu},M.fE_rmn,'pchip');
M.compK   = interp1(COMP.fE_rmn{IN.simu},COMP.K{IN.simu},M.fE_rmn,'pchip');
M.compCl  = interp1(COMP.fE_rmn{IN.simu},COMP.Cl{IN.simu},M.fE_rmn,'pchip');
M.compS   = interp1(COMP.fE_rmn{IN.simu},COMP.S{IN.simu},M.fE_rmn,'pchip');
M.compC   = interp1(COMP.fE_rmn{IN.simu},COMP.C{IN.simu},M.fE_rmn,'pchip');
M.compSi  = interp1(COMP.fE_rmn{IN.simu},COMP.Si{IN.simu},M.fE_rmn,'pchip');

if M.vRes>0 

    % freezing-induced overpressure in the reservoir    
    M.Vice0           = (M.vRes_init * M.vif0) - M.Vice0_old;   % volume of ice since last eruption w/o expansion
    M.Vice1           = (M.vRes_init * M.vif1) - M.Vice1_old;   % volume of ice since last eruption w expansion
    M.Vl              = M.vRes_old - M.Vice0;                   % volume of remaining liquid if not compressed
    M.Vl_compressed   = M.vRes_old - M.Vice1;                   % volume of remaining liquid once compressed
    M.deltaP          = -1/IN.X * log(M.Vl_compressed/M.Vl);    % overpressure

    % Add unrelieved overpressure
    M.deltaP = M.deltaP + M.deltaP_residual; % 

    % Relax unrelieved overpressure
    M.deltaP = M.deltaP*exp(-M.dt/M.tMaxwell); % Relax, bro

    M.deltaP_residual = M.deltaP; % Store for next iteration. Set to 0 if eruption occurs below.

    % Eruption criterion: check if it overcomes threshold overpressure:
    if M.deltaP >= M.DeltaPc && M.canErupt
        % M.V_erupt   = M.Vl - M.Vl_compressed - M.Vdike; % we substract the dike volume to the erupted one
        M.V_erupt   = M.Vl - M.Vl_compressed;
        M.deltaP_residual = 0;

        if M.eruption > IN.nErupt

            % Display Time
            time = M.t - IN.tRes;
        
            if time<IN.kyr2s
                outTime = time/IN.yr2s;
                unit    = ' yr';
            elseif time<IN.Myr2s
                outTime = time/IN.kyr2s;
                unit    = 'kyr';
            elseif time<IN.Gyr2s
                outTime = time/IN.Myr2s;
                unit    = 'Myr';
            else
                outTime = time/IN.Gyr2s;
                unit    = 'Gyr';
            end
        
            % Build Output Message
            str{1} = ['Number of eruptions > max number entered. '];
            str{end+1} = [num2str(outTime,'%05.1f') ' ' unit ' Elapsed. '];
            str{end+1} = ['Number of eruptions: ' num2str(M.eruption,'%.0f .')];
            OUT.errStr = [str{:}];
            errorAndExit;
        end

        % update remaining liquid volume:
        M.Vice0_old = M.Vice0_old + M.Vice0;
        M.Vice1_old = M.Vice1_old + M.Vice1;
        M.vRes_old = M.Vl_compressed;

        % eruption time and volume (cumulative):
        OUT.eruptTimes(M.eruption) = M.t;
        OUT.eruptV(M.eruption)     = M.V_erupt;
        
        M.eruption  = M.eruption + 1;

    end
end

end