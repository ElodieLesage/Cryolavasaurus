%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [MISC] = polarPlot(IN,M,OUT,MISC,COMP)

%%%%%%%%%%%%%%%%%%%%%%%
% Generate plot if engaged
%%%%%%%%%%%%%%%%%%%%%%%
if IN.pltOn || IN.movOn
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % Initialize plot, axes, movie frames
    %%%%%%%%%%%%%%%%%%%%%%%
    if MISC.newPlot
        figNum = 10;

        % Set up for movie if checked
        if IN.movOn
            
            % Plotting needs to be on
            IN.pltOn = 1;
            
            % Set up counters and arrays
            MISC.F1  = struct('cdata', cell(1,IN.NOut2), 'colormap', cell(1,IN.NOut2));
            MISC.fg  = figure(figNum);
            set(figure(figNum),'Units','pixels','Position',[0 0 1920 1080])
            set(figure(figNum),'doublebuffer','off','Visible','Off');
        else
            MISC.fg = figure(figNum);
            set(figure(figNum),'Units','pixels','Position',[0 0 1920 1080])
        end
        MISC.newPlot = 0;
    end
    
    % Select current figure without stealing focus
    set(0,'CurrentFigure',MISC.fg); clf; whitebg('k'); set(gcf,'color','k');
    fontSize = 24;
    
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % Polar plot
    %%%%%%%%%%%%%%%%%%%%%%%
    % Get farfield geometry
    if ~M.resEmp
        M.rOcnFar = M.rOcnTop;
        M.TstructFar = M.T;
    end
    
    yRef  = M.r(end-1);                    % Surface reference depth to Y-scale plot

    rPol  = [M.rOcnFar, M.r((M.r>M.rOcnFar) & (M.r<=M.r(end-1)))]/1e3; % Polar plot radii
    Tpol  = interp1(M.r/1e3,M.TstructFar,rPol,'pchip');     % Radial Temperatue 

    rResCenter_0 = (IN.zResTop+IN.rRes)/1e3; % initial center of reservoir
    rRes_0 = IN.rRes/1e3;             % initial radius of reservoir
    
    rResCenter = mean(yRef-[M.rResTop,M.rResBot])/1e3;
    rRes       = M.rRes/1e3;
    
    %%%%%%%%%%%%%
    % Cut out reservoir from temperature structure for plotting away from
    % reservoir
    % Polar arrays
    sp2 = subplot(132);
    resTheta = rRes_0*1e3/(M.r(end-1)-rResCenter_0*1e3); % Angle subtended by reservoir
    theta_res   = linspace(pi/2-resTheta,pi/2+resTheta,length(rPol)); % Res polar angle
    theta_left  = linspace(pi/2-0.05,pi/2-resTheta,length(rPol)); % Far left Polar angle
    theta_right = linspace(pi/2+resTheta,pi/2+0.05,length(rPol)); % Far right Polar angle

    % Create plottable grids from 1D arrays
    [~,R2] = meshgrid(theta_left,rPol);      % Radius
    T2     = interp1(rPol,Tpol,R2,'pchip');     % Temperature
    Xpol   = rPol'*cos(theta_left);          % X-coord on plot
    Ypol   = yRef/1e3-rPol'*sin(theta_left); % Y-coord on plot
    
    % Main plot (no reservoir thermal effects
    h = pcolor(Xpol,Ypol,T2); set(h,'linestyle','none'); hold on;
    
    % Create plottable grids from 1D arrays
    [~,R2] = meshgrid(theta_right,rPol);      % Radius
    T2     = interp1(rPol,Tpol,R2,'pchip');     % Temperature
    Xpol   = rPol'*cos(theta_right);          % X-coord on plot
    Ypol   = yRef/1e3-rPol'*sin(theta_right); % Y-coord on plot
    
    % Main plot (no reservoir thermal effects
    h = pcolor(Xpol,Ypol,T2); set(h,'linestyle','none'); hold on;

    %%%%%%%%%%%%%
    % Plot local reservoir effects
    % Polar arrays
    rPol  = [M.rOcnTop, M.r((M.r>M.rOcnTop) & (M.r<=M.r(end-1)))]/1e3; % Polar plot radii
    Tpol  = interp1(M.r/1e3,M.T,rPol,'pchip');     % Radial Temperatue 

    % Create plottable grids from 1D arrays
    [~,R2] = meshgrid(theta_res,rPol);  % Radius
    T2     = interp1(rPol,Tpol,R2,'pchip');     % Temperature
    Xpol   = rPol'*cos(theta_res);          % X-coord on plot
    Ypol   = yRef/1e3-rPol'*sin(theta_res); % Y-coord on plot
    
    h = pcolor(Xpol,Ypol,T2);

    xlabel('Distance, km','Interpreter','latex');
    ylabel('Depth, km','Interpreter','latex');
    set(h,'linestyle','none'); axis equal tight; shading interp;
    set(gca,'ydir','reverse','fontsize',fontSize)
    colormap(parula(256));
    
    Dice0 = IN.H0; % Ice thickness;
    xmin = -Dice0/1e3/2;
    xmax = Dice0/1e3/2;
    ymin = -5;
    ymax = max(1.25*Dice0/1e3,45);
    axis([xmin, xmax, ymin, ymax]);

    cb = colorbar;
    ylabel(cb,'Temperature, K','fontsize',fontSize,'Interpreter','latex')
    clim([100 273]);

    title([num2str(MISC.outTime ,'%05.1f') ' '  MISC.unit],'fontname','Monowidth');
    
    %%%%%%%%%%%%%
    % Plot the reservoir
    % Plot outline of original reservoir and outline of current config
    p = nsidedpoly(100, 'Center', [0 rResCenter_0], 'Radius', rRes_0);
    plot(p, 'FaceColor', 'c','edgecolor','c')
    
    if M.rRes>0 
        p = nsidedpoly(100, 'Center', [0 rResCenter], 'Radius', rRes);
        plot(p, 'FaceColor', 'c','edgecolor','k')
        set(gca,'layer','top');
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % Temperature and Frozen Fraction
    %%%%%%%%%%%%%%%%%%%%%%%
    
    % Temperature
    sp1 = subplot(131);
    plot(M.T(M.r>M.rOcnTop),M.z(M.r>M.rOcnTop)/1e3);
    set(gca,'ydir','reverse');
    xlabel('Temperature, K','Interpreter','latex');
    ylabel('Depth, km','Interpreter','latex');
    axis([95, 300,ymin,ymax]);
    set(gca,'fontsize',fontSize); grid on;box on;
    
    % Frozen Fraction
    sp3 = subplot(133);
    % f_max = COMP.vif1{IN.simu}(end)/COMP.vif0{IN.simu}(end);
    xPlot = [0, (OUT.t(OUT.fV>0)-IN.tRes)/IN.kyr2s];
    yPlot = [0, OUT.fV(OUT.fV>0)];
    lastInd = find(yPlot<1,1,'last');
    plot(xPlot(1:lastInd),yPlot(1:lastInd));
    xlabel('Time, kyr','Interpreter','latex');
    ylabel('Frozen Volume Fraction','Interpreter','latex');
    ylim([0,1]);
    set(gca,'fontsize',fontSize); grid on; box on;
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % Better Align
    %%%%%%%%%%%%%%%%%%%%%%%
    
    set(sp1,'position',[0.08,0.10+(0.8-0.55)/2,0.233,0.55]);
    set(sp2,'position',[0.38,0.10+(0.8-0.55)/2,0.233,0.55]);
    set(sp3,'position',[0.73,0.10+(0.8-0.55)/2,0.233,0.55]);
    
    %%%%%%%%%%%%%%%%%%%%%%%
    % Movie Frames
    %%%%%%%%%%%%%%%%%%%%%%%
    
    if IN.movOn && (M.t > IN.tRes)
        MISC.F1(IN.outInd2) = getframe(gcf);
    end
    drawnow
    
    % Save movie to file
    if (M.t >= IN.tMax) && IN.movOn 
        noFrame = zeros(numel(MISC.F1),1);
        for i=1:numel(MISC.F1)
            if isempty(MISC.F1(i).cdata)
                noFrame(i) = 1;
            end
        end
        MISC.F1(noFrame==1) = [];
        numFrames = numel(MISC.F1);
        v = VideoWriter([OUT.path 'video.mp4'],'MPEG-4');
        if numFrames >= 300
            v.FrameRate = 60;
        elseif numFrames >= 150
            v.FrameRate = 30;
        else
            v.FrameRate = 12;
        end
        v.Quality   = 100;
        open(v); writeVideo(v,MISC.F1); close(v)
        MISC.F1 = [];
    end % End movie save
end % end plot
end % End function








