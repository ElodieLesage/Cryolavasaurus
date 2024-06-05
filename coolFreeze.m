%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [T, rho, vlf0, vlf1, vif0, vif1] = coolFreeze(M, COMP, IN)

% if we froze further than the PHREEQC model:
if M.fE_rmn < COMP.fE_rmn{IN.simu}(end-1)
    % time = M.t - IN.tRes;
    % 
    % if time<IN.kyr2s
    %     outTime = time/IN.yr2s;
    %     unit    = ' yr';
    % elseif time<IN.Myr2s
    %     outTime = time/IN.kyr2s;
    %     unit    = 'kyr';
    % elseif time<IN.Gyr2s
    %     outTime = time/IN.Myr2s;
    %     unit    = 'Myr';
    % else
    %     outTime = time/IN.Gyr2s;
    %     unit    = 'Gyr';
    % end
    % 
    % % Build Output Message
    % str{1} = ['No more PHREEQC data. '];
    % str{end+1} = [num2str(outTime,'%05.1f') ' ' unit ' Elapsed. '];
    % str{end+1} = ['Number of eruptions: ' num2str(M.eruption,'%.0f .')];
    % disp([str{:}]);
    % error(); 

    % SET FINAL values of: 
    %  - temperature
    T            = COMP.temps{IN.simu}(end);
    %  - density 
    rho          = COMP.rho_l{IN.simu}(end);
    %  - volumic liquid fraction before compression /!\ true only if liquid mass is conserved (no eruption)
    vlf0         = 0;
    %  - volumic liquid fraction after compression
    vlf1         = 0;
    %  - volumic frozen fraction before expansion 
    vif0         = 1;
    %  - volumic frozen fraction after expansion
    % We assume that the volume expansion ratio that was accumulated by the
    % last PHREEQC datapoint holds true until freezing is complete. That
    % is, Vif1(t-1)/Vif0(t-1) = Vif1(t)/Vif0(t). Because Vif0(t) = 1 for
    % full freezing, Vif1(t) = Vif1(t-1)/Vif0(t-1)
    vif1         = vif0*COMP.vif1{IN.simu}(end)/COMP.vif0{IN.simu}(end);

else
    % interpolate values of: 
    %  - temperature
    T            = interp1(COMP.fE_rmn{IN.simu},COMP.temps{IN.simu},M.fE_rmn,'pchip');
    %  - density 
    rho          = interp1(COMP.fE_rmn{IN.simu},COMP.rho_l{IN.simu},M.fE_rmn,'pchip');
    %  - volumic liquid fraction before compression /!\ true only if liquid mass is conserved (no eruption)
    vlf0         = interp1(COMP.fE_rmn{IN.simu},COMP.vlf0{IN.simu},M.fE_rmn,'pchip');
    %  - volumic liquid fraction after compression
    vlf1         = interp1(COMP.fE_rmn{IN.simu},COMP.vlf1{IN.simu},M.fE_rmn,'pchip');
    %  - volumic frozen fraction before expansion 
    vif0         = interp1(COMP.fE_rmn{IN.simu},COMP.vif0{IN.simu},M.fE_rmn,'pchip');
    %  - volumic frozen fraction after expansion
    vif1         = interp1(COMP.fE_rmn{IN.simu},COMP.vif1{IN.simu},M.fE_rmn,'pchip');
end

end