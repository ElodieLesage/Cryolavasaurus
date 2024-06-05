%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot
plotComp;

% % Make movie if appropriate
% if IN.movOn
%     noFrame = zeros(IN.outInd,1);
%     for i=1:IN.outInd
%         if isempty(MISC.F1(i).cdata)
%             noFrame(i) = 1;
%         end
%     end
%     MISC.F1(logical(noFrame)) = [];
%     outputName = ['H0' num2str(IN.H0/1e3,'%0.1f') '_rRes' num2str(IN.rRes/1e3,'%0.1f') '_zRes' num2str(IN.zResTop/1e3,'%0.1f')];
%     v = VideoWriter(['Output\Movies\' outputName '.mp4'],'MPEG-4');
%     if IN.outInd >= 300
%         v.FrameRate = 60;
%     elseif IN.outInd >= 150
%         v.FrameRate = 30;
%     else
%         v.FrameRate = 12;
%     end
%     v.Quality   = 100;
%     open(v); writeVideo(v,MISC.F1); close(v)
%     clear MISC;
%     MISC = [];
% end % End movie save

% Exit
error(OUT.errStr);
