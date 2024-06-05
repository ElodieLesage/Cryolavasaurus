%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figPos = [1 1 7 7];
titleSize = 20;
labelSize = 20;
tickSize = 20;
whitebg('w');

lastEruptInd = find(OUT.eruptV>0,1,'last');
[~, startInd] = min(sqrt((OUT.t).^2-IN.tRes^2));
lastErupt = (OUT.eruptTimes(lastEruptInd)-IN.tRes)/IN.kyr2s;
lastTime  = (IN.tMax-IN.tRes)/IN.kyr2s;
firstTime = -IN.tRes/IN.kyr2s;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Concentrations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
M.compLabels = {'Ca','Mg','Na','K','Cl','S','C','Si'};

YMin_comp = 1e-7;
YMax_comp = 1e-1;

% YMin_T = min(OUT.Tmelt);
YMin_T = 258;
YMax_T = 273;

% Set up Figures
fh = figure(1); clf; set(gcf,'color','w'); hold on;

box on; grid on;

colors = get(gca,'colororder');
left_color = [0 0 0];
right_color = colors(2,:); 
set(fh,'defaultAxesColorOrder',[left_color; right_color]);

% Get last index populated
lastIndTime = find(OUT.t>0,1,'last');

% Colormap
cc = parula(9);

% Liquid temperature
yyaxis right

ylim([YMin_T, YMax_T])

xPlot = (OUT.t(OUT.Tmelt~=0)-IN.tRes)/IN.kyr2s;
yPlot = OUT.Tmelt(OUT.Tmelt~=0);

plot(xPlot(2:end),yPlot(2:end), 'LineWidth', 2, 'color', right_color)
ylabel('Liquid temperature, K','FontSize',labelSize,'Interpreter','latex')


% Concentrations
% Convert to molar abundance in ppt. M.comp is in mol solute / kh H2O
M_H2O = 18.01528e-3; % Molar mass of water [kg/mol]
molarComp = OUT.comp * M_H2O;

yyaxis left
set(gca,'YScale','log');

ylim([YMin_comp, YMax_comp])

xLoc = zeros(1,IN.Ncomp);
xlim([0, lastErupt])
yLoc = zeros(1,IN.Ncomp);

xPlot = cell(1,IN.Ncomp);
yPlot = cell(1,IN.Ncomp);

for i=1:IN.Ncomp
    xPlot{i} = (OUT.t(1:lastIndTime)-IN.tRes)/IN.kyr2s;
    yPlot{i} = molarComp(i,1:lastIndTime);
    plot(xPlot{i}, yPlot{i}, '-', 'color', cc(i,:), 'linewidth',1);

    xLoc(i) = 0.25 * max(lastErupt);
    yLoc(i) = 10^(log10(interp1(xPlot{i},yPlot{i},xLoc(i),'pchip'))+0.03*log10(YMax_comp/YMin_comp));
end

[~, order] = sort(yLoc,'descend');
xRange = get(gca,'XLim');

for i=1:IN.Ncomp
    j = order(i);
    
    xLoc2 = xLoc(j) + (i-1) * 0.5 * diff(xRange)/(IN.Ncomp-1);
    yLoc2 = 10^(log10(interp1(xPlot{j},yPlot{j},xLoc2,'pchip'))+0.03*log10(YMax_comp/YMin_comp));
    text(xLoc2,yLoc2,M.compLabels{j},'color', cc(j,:),'FontSize',tickSize)
end

% Vertical lines for eruptions
eruptTimes = OUT.eruptTimes(OUT.eruptTimes>0);
for i=1:20:numel(eruptTimes)
    xline((OUT.eruptTimes(i)-IN.tRes)/IN.kyr2s,'k','LineWidth',1,'alpha',0.25);
end

set(gca,'FontSize',tickSize);

xlabel('Time, kyr','FontSize',labelSize,'Interpreter','latex')
ylabel('Molar Concentration, ${mol_{solute}}/{mol_{H_2O}}$','FontSize',labelSize,'Interpreter','latex')

% Scale plot
title(COMP.sheets(IN.simu),"FontSize",titleSize,'FontWeight','bold')
set(gca,'XLimitMethod','tight','GridAlpha',0.025)
pbaspect([3/4 1 1]);
set(gca,'Layer','top')

figtitle = [OUT.path 'COMP.pdf'];
set(fh,'Units','Inches');
set(fh,'Position',[figPos(1) figPos(2)   figPos(3)   figPos(4)])
set(fh,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[figPos(3), figPos(4)])
print(fh,figtitle,'-dpdf','-r0')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Misc. plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fh = figure(3); clf; set(gcf,'color','w');
figPos = [1 1 10.3 7];

%  eruption intervals and volumes
subplot(231);
yyaxis left

xPlot = [0; (OUT.eruptTimes(OUT.eruptV~=0)-IN.tRes)/IN.kyr2s];
yPlot = [0; OUT.eruptV(OUT.eruptV~=0)/1e9];
yPlot = cumsum(yPlot);

plot(xPlot(1:end),yPlot(1:end), 'LineWidth', 1)
xlabel('Time, kyr')
ylabel({'Cumulative Erupted', 'Volume, km^{3}'})

yyaxis right

xPlot = (OUT.eruptTimes(1:M.eruption-2)-IN.tRes)/IN.kyr2s;
yPlot = 1./(diff(OUT.eruptTimes(1:M.eruption-1)/IN.kyr2s));
% yPlot = smooth(xPlot,yPlot,20);
plot(xPlot, yPlot, 'LineWidth', 1.5)

xlim([0,lastErupt])
xlabel('Time, kyr')
ylabel('Eruption Frequency, kyr^{-1}')
set(gca,'yscale','log')

box on; 
set(gca,'fontsize',30);


% Surface Temperature
subplot(232);

xPlot = (OUT.t(OUT.Tsurf~=0)-IN.tRes)/IN.kyr2s;
yPlot = OUT.Tsurf(OUT.Tsurf~=0)-OUT.Tsurf(startInd);


plot(xPlot(2:end),yPlot(2:end), 'k', 'LineWidth', 1.5)

% xlim([0,lastTime]);
xlim([0,500]);

box on; grid on; 
xlabel('Time, kyr')
ylabel({'Surface Temperature', 'Anomaly, K'})
set(gca,'fontsize',30);


% Ice thickness 
subplot(233);

xPlot = (OUT.t(OUT.Dice~=0)-IN.tRes)/IN.kyr2s;
yPlot = OUT.Dice(OUT.Dice~=0)/1e3;

plot(xPlot(2:end),yPlot(2:end), 'k', 'LineWidth', 1.5)

box on; grid on; 

%xlim([0,lastTime]);
xlim([0,5000]);

xlabel('Time, kyr')
ylabel({'Local Ice Shell', 'Thickness, km'})
set(gca,'fontsize',30);


% Liquid Temperature
subplot(234);

xPlot = (OUT.t(OUT.Tmelt~=0)-IN.tRes)/IN.kyr2s;
yPlot = OUT.Tmelt(OUT.Tmelt~=0);

plot(xPlot(2:end),yPlot(2:end), 'k', 'LineWidth', 1.5)

box on; grid on; 
xlim([0,lastErupt])
xlabel('Time, kyr')
ylabel({'Reservoir Freezing', 'Temperature, K'})
set(gca,'fontsize',30);

% Freezing Rate
subplot(235);

xPlot = (OUT.t(OUT.t~=0)-IN.tRes)/IN.kyr2s;
yPlot = OUT.freezeRate(OUT.t~=0);

plot(xPlot(xPlot>0 & xPlot < lastErupt),yPlot(xPlot>0 & xPlot < lastErupt), 'k', 'LineWidth', 1.5)

box on; grid on; 
xlim([0,lastErupt])
ylim([0,0.5])
xlabel('Time, kyr')
ylabel('Freezing rate, cm yr^{-1}')
set(gca,'yscale')
set(gca,'fontsize',30);


% Frozen fraction
subplot(236);

xPlot = (OUT.t(OUT.t~=0)-IN.tRes)/IN.kyr2s;
yPlot = OUT.fV(OUT.t~=0);

plot(xPlot(2:end),yPlot(2:end), 'k', 'LineWidth', 1.5)

box on; grid on; 
xlim([0,lastErupt])
xlabel('Time, kyr')
ylabel('Volumic frozen fraction')
set(gca,'fontsize',30);

figtitle = [OUT.path 'OBSV.pdf'];
set(fh,'Units','Inches');
set(fh,'Position',[figPos(1) figPos(2)   3*figPos(3)    1.5*figPos(4)])
set(fh,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[3*figPos(3)   1.5*figPos(4)])
print(fh,figtitle,'-dpdf','-r0')





