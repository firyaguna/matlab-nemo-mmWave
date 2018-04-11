bw_string = @(bwid) num2str(...
    rad2deg(beamWidth_vector(bwid)),...
    '%.f deg');
ca_string = { 'Max. Power' ; 'Min. Dist.';...
    'Fading Max. Power' ; 'Fading Min. Dist.'};
fixParam.height_id = 1;
fixParam.bodyAtt_id = 1;
fixParam.sinrThreshold = -5; %dB
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;
ca = 2;

blockFreeRadius = sim.apHeight * distanceToUserBody_vector(2) ...
    / sim.distanceToTopHead;

colorSpecBw0 = jet(length( beamWidth_vector ));
colorSpecBw = imadjust( colorSpecBw0, [], [.6 1] );
%% DRAW COVERAGE CURVES
figure(3);
clf(3);

set( gca, 'ColorOrder', colorSpecBw, 'NextPlot', 'replacechildren' );
% all beamwidths
h0 = semilogx( .5.*interSiteDistance_vector,...
         100.*cov{ca},...
         '--', 'Linewidth', .5 );
hold on;

% highlight beamwidths
b1 = 15; b2 = 30;
h1 = semilogx( .5.*interSiteDistance_vector, ...
    100.*cov{ca}(b1,:),...
    '-', 'Linewidth', 2,...
    'Color', colorSpecBw0(b1,:));
h2 = semilogx( .5.*interSiteDistance_vector, ...
    100.*cov{ca}(b2,:),...
    '-', 'Linewidth', 2,...
    'Color', colorSpecBw0(b2,:));

% peak
hp = semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      100.*peak_cov{ca}(:,3),...
      'xk-', 'Linewidth', 1.2 );
% peak
hp2 = semilogx( .5.*interSiteDistance_vector(peak_ase{ca}(:,1)), ...
      100.*peak_ase{ca}(:,3),...
      'ok-', 'Linewidth', 0.8 );

% self-block free radius
rblock = line([blockFreeRadius blockFreeRadius],[0 100],'Color',[.4 .4 .4]);
set( rblock, 'LineStyle', '--' );  

ylim([ 0 102 ]);
xlim( [ .8 100 ] );

xlabel('Half Inter-site Distance (m)');
ylabel( num2str( fixParam.sinrThreshold, 'Coverage SINR > %d dB (%%)'));
legend([h1,h2,hp,hp2,rblock],...
    bw_string(b1),...
    bw_string(b2),...
    'peak coverage',...
    'achieved coverage',...
    'r_{blockFree}', ...
    'Location','best');
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
set(gca,'XTick',[1;2;5;10;20;50;100]);
set(gca,'XTickLabel',[1;2;5;10;20;50;100]);
clear fig;
% set(findall(gcf,'-property','FontSize'),'FontSize',13);
fig=gcf;
fig.OuterPosition = [100 100 600 400];
fig.Units = 'inches';
pos = fig.Position;
fig.PaperPositionMode = 'Auto'; 
fig.PaperUnits = 'inches'; 
fig.PaperSize = [pos(3),pos(4)];
print(fig,'figures/fig03_cov_peaks','-dpdf','-r0');
%% DRAW ASE CURVES
figure(4);
clf(4);

set( gca, 'ColorOrder', colorSpecBw, 'NextPlot', 'replacechildren' );
% all beamwidths
h0 = loglog( .5.*interSiteDistance_vector,...
         ase{ca},...
         '--', 'Linewidth', .5 );
hold on;

% highlight beamwidths
b1 = 15; b2 = 30;
h1 = loglog( .5.*interSiteDistance_vector, ...
    ase{ca}(b1,:),...
    '-', 'Linewidth', 2,...
    'Color', colorSpecBw0(b1,:));
h2 = loglog( .5.*interSiteDistance_vector, ...
    ase{ca}(b2,:),...
    '-', 'Linewidth', 2,...
    'Color', colorSpecBw0(b2,:));

% peak
hp = loglog( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      peak_cov{ca}(:,4),...
      'xk-', 'Linewidth', 1.2 );
% peak
hp2 = loglog( .5.*interSiteDistance_vector(peak_ase{ca}(:,1)), ...
      peak_ase{ca}(:,4),...
      'ok-', 'Linewidth', 0.8 );

% self-block free radius
rblock = line([blockFreeRadius blockFreeRadius],[1e-5 2],'Color',[.4 .4 .4]);
set( rblock, 'LineStyle', '--' );

ylim([ 1e-5 2 ]);
xlim( [ .8 100 ] );

xlabel('Half Inter-site Distance (m)');
ylabel( 'Area Spectral Efficiency (bps/Hz/m2) ');
legend([h1,h2,hp,hp2,rblock],...
    bw_string(b1),...
    bw_string(b2),...
    'achieved ASE',...
    'peak ASE',...
    'r_{blockFree}', ...
    'Location','best');
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
set(gca,'XTick',[1;2;5;10;20;50;100]);
set(gca,'XTickLabel',[1;2;5;10;20;50;100]);
clear fig;
% set(findall(gcf,'-property','FontSize'),'FontSize',13);
fig=gcf;
fig.OuterPosition = [100 100 600 400];
fig.Units = 'inches';
pos = fig.Position;
fig.PaperPositionMode = 'Auto'; 
fig.PaperUnits = 'inches'; 
fig.PaperSize = [pos(3),pos(4)];
print(fig,'figures/fig04_ase_peaks','-dpdf','-r0');