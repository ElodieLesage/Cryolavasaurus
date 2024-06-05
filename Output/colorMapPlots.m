%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Elodie Lesage, Sam Howell, Julia Miller
% (C)2024 California Institute of Technology. All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Depth and thickness arrays

Radius  = [100 250 500 1250 2500];
Depth   = [1000 2500 5000 10000 15000];

% Matrixes we want to plot
% Depth is the y axis, radius is x

% Time trackers
CM.time         = NaN(5,5);
CI.time         = NaN(5,5);
MCC.time        = NaN(5,5);
H2O.time        = NaN(5,5);

% Total erupted volume - initialize
CM.Verupt       = NaN(5,5);
CI.Verupt       = NaN(5,5);
MCC.Verupt      = NaN(5,5);
H2O.Verupt      = NaN(5,5);

% Max surface temperature anomaly - initialize
CM.Tanomaly     = NaN(5,5);
CI.Tanomaly     = NaN(5,5);
MCC.Tanomaly    = NaN(5,5);
H2O.Tanomaly    = NaN(5,5);

% Max thickness change - initialize
CM.DThickness   = NaN(5,5);
CI.DThickness   = NaN(5,5);
MCC.DThickness  = NaN(5,5);
H2O.DThickness  = NaN(5,5);

% Populate

% IN.simu entries:
% 1  = Eq EM-CM carb
% 3  = Eq EM-CI carb
% 8  = Eq MC-Scale carb + comets
% 17 = Pure Water

D = dir;

for k = 4:(length(D)-2)
    folder = D(k).name;
    cd(folder);

    output = load('output.mat');

    x = find(Radius == output.IN.rRes);
    y = find(Depth == output.IN.zResTop);

    % CM
    if output.IN.simu == 1
        time                = output.OUT.t - output.IN.tRes;
        % CM.Verupt(y,x)      = floor(log10((sum(output.OUT.eruptV)/1e9)));
        CM.Verupt(y,x)      = sum(output.OUT.eruptV)/1e9;
        CM.Tanomaly(y,x)    = max(output.OUT.Tsurf(time>0))-min(output.OUT.Tsurf(time>0));
        % Exception for the few cases where the reservoir reaches the
        % ocean, which induces a large ice shell thickness variation at the
        % end of the simulation and would not be physical as we would
        % expect relatively fast viscous relaxation:
        if isfield(output.OUT, 'tDrain') && output.OUT.tDrain > 0
            time            = output.OUT.t(output.OUT.t < output.OUT.tDrain) - output.IN.tRes;
        end
        CM.DThickness(y,x)  = max(output.OUT.Dice(time>0))-min(output.OUT.Dice(time>0));
        
    end
        
    % CI
    if output.IN.simu == 3
        time                = output.OUT.t - output.IN.tRes;
        % CI.Verupt(y,x)      = floor(log10((sum(output.OUT.eruptV)/1e9)));
        CI.Verupt(y,x)      = sum(output.OUT.eruptV)/1e9;
        CI.Tanomaly(y,x)    = max(output.OUT.Tsurf(time>0))-min(output.OUT.Tsurf(time>0));
        % Exception for reservoirs sinking into ocean:
        if isfield(output.OUT, 'tDrain') && output.OUT.tDrain > 0
            time            = output.OUT.t(output.OUT.t < output.OUT.tDrain) - output.IN.tRes;
        end
        CI.DThickness(y,x)  = max(output.OUT.Dice(time>0))-min(output.OUT.Dice(time>0));
    end

    % MCC + Comet
    if output.IN.simu == 8
        time                 = output.OUT.t - output.IN.tRes;
        % MCC.Verupt(y,x)      = floor(log10((sum(output.OUT.eruptV)/1e9)));
        MCC.Verupt(y,x)      = sum(output.OUT.eruptV)/1e9;
        MCC.Tanomaly(y,x)    = max(output.OUT.Tsurf(time>0))-min(output.OUT.Tsurf(time>0));
        % Exception for reservoirs sinking into ocean:
        if isfield(output.OUT, 'tDrain') && output.OUT.tDrain > 0
            time             = output.OUT.t(output.OUT.t < output.OUT.tDrain) - output.IN.tRes;
        end
        MCC.DThickness(y,x)  = max(output.OUT.Dice(time>0))-min(output.OUT.Dice(time>0));
    end

    % H2O
    if output.IN.simu == 17
        time                 = output.OUT.t - output.IN.tRes;
        % H2O.Verupt(y,x)      = floor(log10((sum(output.OUT.eruptV)/1e9)));
        H2O.Verupt(y,x)      = sum(output.OUT.eruptV)/1e9;
        H2O.Tanomaly(y,x)    = max(output.OUT.Tsurf(time>0))-min(output.OUT.Tsurf(time>0));
        % Exception for reservoirs sinking into ocean:
        if isfield(output.OUT, 'tDrain') && output.OUT.tDrain > 0
            time             = output.OUT.t(output.OUT.t < output.OUT.tDrain) - output.IN.tRes;
        end
        H2O.DThickness(y,x)  = max(output.OUT.Dice(time>0))-min(output.OUT.Dice(time>0));
    end

    clear output
    clear folder
    cd ..
end

%% 


figPos = [1 1 9 9];
fh = figure(3); clf; set(gcf,'color','w'); 

% Conversion to km
% Diameter    = Radius *2 ./1000;
% Depth       = Depth ./1000;
x = [1 2 3 4 5];
y = [1 2 3 4 5];

titleSize = 25;
labelSize = 25;
tickSize = 14;
% whitebg('w');

subplot(431);
imagesc(x, y, CM.Tanomaly);
xticks([1 2 3 4 5]);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([1 2.5 5 10 15]);
clim([0 1.5]);
ylabel({'{\bf{CM chondrites}}' 'Reservoir depth (km)'});
title({'(a) Surface maximum', 'temperature anomaly (K)'});
% h1 = text(-0.25, 0.5,'CM chondrites'); text position doesn't work
% set(h1, 'rotation', 90)
colorbar

subplot(432);
imagesc(x, y, CM.DThickness);
xticks([1 2 3 4 5]);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([1 2.5 5 10 15]);
% clim([1 1000])
title({'(b) Ice shell thickness', 'variation (m)'});
set(gca, 'ColorScale', 'log')
cb = colorbar;
cb.Ticks = [10^(0) 10^(1) 10^(2)];

subplot(433);
m = imagesc(x, y, CM.Verupt);
set(m,'alphadata',CM.Verupt>0);
xticks([1 2 3 4 5]);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([1 2.5 5 10 15]);
set(gca, 'ColorScale', 'log')
title('(c) Total erupted volume (km^3)');
cb = colorbar;
cb.Ticks = [10^(-4) 10^(-3) 10^(-2) 10^(-1) 1];

subplot(434);
imagesc(x, y, CI.Tanomaly);
xticks([1 2 3 4 5]);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([1 2.5 5 10 15]);
clim([0 1.5])
ylabel({'{\bf{CI chondrites}}' 'Reservoir depth (km)'});
colorbar

subplot(435);
imagesc(x, y, CI.DThickness);
xticks([1 2 3 4 5]);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([1 2.5 5 10 15]);
set(gca, 'ColorScale', 'log')
cb = colorbar;
cb.Ticks = [10^(0) 10^(1) 10^(2)];

subplot(436);
m = imagesc(x, y, CI.Verupt);
set(m,'alphadata',CI.Verupt>0);
xticks([1 2 3 4 5]);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([0.2 0.5 1 2.5 5]);
set(gca, 'ColorScale', 'log')
cb = colorbar;
cb.Ticks = [10^(-4) 10^(-3) 10^(-2) 10^(-1) 1];

subplot(437);
imagesc(x, y, MCC.Tanomaly);
xticks([1 2 3 4 5]);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([1 2.5 5 10 15]);
clim([0 1.5]);
ylabel({'{\bf{Monte Carlo (chondrites + comets)}}' 'Reservoir depth (km)'})
colorbar

subplot(438);
imagesc(x, y, MCC.DThickness);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([1 2.5 5 10 15]);
set(gca, 'ColorScale', 'log')
cb = colorbar;
cb.Ticks = [10^(0) 10^(1) 10^(2)];

subplot(439);
m = imagesc(x, y, MCC.Verupt);
set(m,'alphadata',MCC.Verupt>0);
xticks([1 2 3 4 5]);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([1 2.5 5 10 15]);
set(gca, 'ColorScale', 'log')
cb = colorbar;
cb.Ticks = [10^(-4) 10^(-3) 10^(-2) 10^(-1) 1];

subplot(4,3,10);
imagesc(x, y, H2O.Tanomaly);
xticks([1 2 3 4 5]);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([1 2.5 5 10 15]);
clim([0 1.5])
xlabel({'Reservoir thickness (km)'})
ylabel({'{\bf{H2O}}' 'Reservoir depth (km)'})
colorbar

subplot(4,3,11);
imagesc(x, y, H2O.DThickness);
xticks([1 2 3 4 5]);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([1 2.5 5 10 15]);
xlabel({'Reservoir thickness (km)'});
set(gca, 'ColorScale', 'log')
cb = colorbar;
cb.Ticks = [10^(0) 10^(1) 10^(2)];

subplot(4,3,12);
m = imagesc(x, y, H2O.Verupt);
set(m,'alphadata',H2O.Verupt>0);
xticks([1 2 3 4 5]);
xticklabels([0.2 0.5 1 2.5 5]);
yticks ([1 2 3 4 5]);
yticklabels([1 2.5 5 10 15]);
set(gca, 'ColorScale', 'log')
xlabel({'Reservoir thickness (km)'});
cb = colorbar;
cb.Ticks = [10^(-4) 10^(-3) 10^(-2) 10^(-1) 1];


figtitle = 'ReservoirGeometry.pdf';
set(fh,'Units','Inches');
set(fh,'Position',[figPos(1) figPos(2)   figPos(3)   figPos(4)])
set(fh,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[figPos(3), figPos(4)])
print(fh,figtitle,'-dpdf','-r0')


%%

