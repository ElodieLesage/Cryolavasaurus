%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [IN, OUT, MISC] = outputManager(M,IN,BOD,COMP,OUT,MISC,MAT)

% If reservoir drained into the ocean:
if M.drained == 1
    OUT.tDrain = M.t;
end

%%%%%%%%%%%%%%%%%%
% Save Output
%%%%%%%%%%%%%%%%%%
if (IN.outInd * IN.tOut < M.t) || (IN.outInd == IN.NOut) || (M.t >= IN.tMax) 
    indInc = 1;
    if (M.t<IN.tRes-IN.tMult*IN.tOut) || (M.t>IN.tRes+IN.tMult*IN.tOut && M.vRes==0) ...
            && mod(round(M.t/IN.kyr2s),round(IN.tOut*IN.tMult/IN.kyr2s))==0
        indInc = IN.tMult;
    end
        
    IN.outInd = IN.outInd + indInc;
   
    % Note that outputs are initialized in initializeOutputs.m
    OUT.t(IN.outInd)     = M.t;
    OUT.dm_dt(IN.outInd) = M.dm_dt ;
    OUT.Tsurf(IN.outInd) = M.Tsurf;  % Surface Temperature
    OUT.Dice(IN.outInd)  = BOD.R-M.rOcnTop; % Ice thickness
    OUT.Dconv(IN.outInd) = M.rConvTop - M.rOcnTop; % Convective thickness
    OUT.Nu(IN.outInd)    = max(M.Nu); % Nusselt number

    try
        OUT.vRes(IN.outInd)  = M.vRes;   % Reservoir volume
        OUT.rRes(IN.outInd)  = M.rRes;   % Reservoir radius
        OUT.zRes(IN.outInd)  = BOD.R-M.rResTop; % Reservoir Depth
        % Freezing rate (calculated in MeltingFreezing):
        OUT.freezeRate(IN.outInd)    = M.freezeRate;
        OUT.freezeRateTop(IN.outInd) = M.freezeRateTop;
        OUT.freezeRateBot(IN.outInd) = M.freezeRateBot;
        OUT.fV(IN.outInd)    = M.vif1;     % Reservoir frozen fraction
    catch
        % Reservoir not yet on.
    end

    OUT.tMax(IN.outInd) = M.tMaxwell;
    OUT.Tmelt(IN.outInd)  = M.Tm_res; % Reservoir melting temperature

    % Store composition data
    OUT.comp(1,IN.outInd)  =  M.compCa;
    OUT.comp(2,IN.outInd)  =  M.compMg;
    OUT.comp(3,IN.outInd)  =  M.compNa;
    OUT.comp(4,IN.outInd)  =  M.compK;
    OUT.comp(5,IN.outInd)  =  M.compCl;
    OUT.comp(6,IN.outInd)  =  M.compS;
    OUT.comp(7,IN.outInd)  =  M.compC;
    OUT.comp(8,IN.outInd)  =  M.compSi;
    
    %%%%%%%%%%%%%%%%%%
    % Display Time
    %%%%%%%%%%%%%%%%%%
    tTemp = M.t-IN.tRes;
    if abs(tTemp)<IN.Myr2s
        outTime = tTemp/IN.kyr2s;
        unit    = 'kyr';
    elseif abs(tTemp)<IN.Gyr2s
        outTime = tTemp/IN.Myr2s;
        unit    = 'Myr';
    else
        outTime = tTemp/IN.Gyr2s;
        unit    = 'Gyr';
    end

    %%%%%%%%%%%%%%%%%%
    % Build Output Message
    %%%%%%%%%%%%%%%%%%
    str{1} = [num2str(outTime,'%05.1f') ' ' unit ' Elapsed.'];
    % str{end+1} = [' D_conv = ' num2str(OUT.Dconv(IN.outInd)/1e3,'%0.3f') ' km.'];
    str{end+1} = [' D_ice = ' num2str((BOD.R-M.rOcnTop)/1e3,'%0.3f') ' km.'];
    str{end+1} = [' T_surf = ' num2str(M.Tsurf,'%05.1f.')];
    str{end+1} = [' r_res = ' num2str(M.rRes/1e3,'%04.1f km.')];
    str{end+1} = [' V_res/V_init = ' num2str(M.vRes/max((4/3)*pi*IN.rRes^3),'%02.2f.')];
    str{end+1} = [' Nu = ' num2str(OUT.Nu(IN.outInd),'%0.3f')];
    str{end+1} = [' q_out = ' num2str(sum(M.H*mean(M.dr))*1e3,'%03.0f') ' mW/m^2.'];
    str{end+1} = [' DeltaP = ' num2str(M.deltaP/1e6,'%3.1f MPa')];
    str{end+1} = [' Resid P / P_crit = ' num2str(M.deltaP_residual/M.DeltaPc,'%02.2f. ')];
    str{end+1} = [' ' num2str(100*IN.outInd/IN.NOut,'%04.1f') '% Complete.'];
    disp([str{:}]);
         
    if (M.t >= IN.tMax) 
        % Remove zero fields from OUT
        fields = fieldnames(OUT);
        NOut1 = length(OUT.t);
        NOut2 = length(OUT.t2);
        indKeep1 = find(OUT.t~=0);
        indKeep2 = find(OUT.t2~=0);
        for i = 1:numel(fields)
            temp = OUT.(fields{i});
            if numel(temp)==NOut1
                OUT.(fields{i}) = temp(indKeep1);
            elseif numel(temp)==NOut2
                OUT.(fields{i}) = temp(indKeep2);
            end
        end

        % Remove zero from COMP
        OUT.comp = OUT.comp(:,indKeep1);

        save([OUT.path 'output.mat'],'OUT','IN','BOD','COMP','M','MAT');
        plotComp;
    end
    
end



%%%%%%%%%%%%%%%%%%
% Polar Plot
%%%%%%%%%%%%%%%%%%

if IN.outInd2 * IN.tOut2 < M.t || (M.t >= IN.tMax) 
    indInc = 1;
    if (M.t<IN.tRes-IN.tMult2*IN.tOut2) || (M.t>IN.tRes+IN.tMult2*IN.tOut2 && M.vRes==0) ...
            && mod(round(M.t/IN.kyr2s),round(IN.tOut2*IN.tMult2/IN.kyr2s))==0
        indInc = IN.tMult2;
    end

    IN.outInd2 = IN.outInd2 + indInc;
        
    OUT.t2(IN.outInd2) = M.t; 

    %%%%%%%%%%%%%%%%%%
    % Display Time
    %%%%%%%%%%%%%%%%%%
    tTemp = M.t-IN.tRes;
    if abs(tTemp)<IN.Myr2s
        outTime = tTemp/IN.kyr2s;
        unit    = 'kyr';
    elseif abs(tTemp)<IN.Gyr2s
        outTime = tTemp/IN.Myr2s;
        unit    = 'Myr';
    else
        outTime = tTemp/IN.Gyr2s;
        unit    = 'Gyr';
    end

    MISC.outTime = outTime;
    MISC.unit = unit;
    [MISC] = polarPlot(IN,M,OUT,MISC,COMP);

end


