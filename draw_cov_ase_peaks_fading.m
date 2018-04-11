bw_string = @(bwid) num2str(...
    rad2deg(beamWidth_vector(bwid)),...
    '%.f deg');
ca_string = { 'No Fading / MaxP' ; 'No Fading / MinD';...
    'Nakagami Fading / MaxP' ; 'Nakagami Fading / MinD'};
fixParam.height_id = 1;
fixParam.bodyAtt_id = 1;
fixParam.sinrThreshold = -5; %dB
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;

blockFreeRadius = sim.apHeight * distanceToUserBody_vector(2) ...
    / sim.distanceToTopHead;
colorSpecBw0 = jet(length( beamWidth_vector ));
colorSpecBw = imadjust( colorSpecBw0, [], [.6 1] );
%% DRAW COVERAGE CURVES
figure(5);
clf(5);

% all beamwidths / with fading
ca = 4;
set( gca, 'ColorOrder', colorSpecBw, 'NextPlot', 'replacechildren' );
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

% peak / no fading
ca = 2;
hp1 = semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      100.*peak_cov{ca}(:,3),...
      'Linewidth', 0.8,...
      'Color','k',...
      'Marker','o' );
% peak / with fading
ca = 4;
hp2 = semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      100.*peak_cov{ca}(:,3),...
      'Linewidth', 1.2,...
      'Color','k',...
      'Marker','x' );

% self-block free radius
rblock = line([blockFreeRadius blockFreeRadius],[0 100],'Color',[.4 .4 .4]);
set( rblock, 'LineStyle', '--' );  

ylim([ 0 102 ]);
xlim( [ .8 100 ] );

xlabel('Half Inter-site Distance (m)');
ylabel( num2str( fixParam.sinrThreshold, 'Coverage SINR > %d dB (%%)'));

legend([h1,h2,hp1,hp2,rblock],...
    bw_string(b1),...
    bw_string(b2),...
    ca_string{2},...
    ca_string{4},...
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
fig=gcf;
fig.OuterPosition = [100 100 600 400];
fig.Units = 'inches';
pos = fig.Position;
fig.PaperPositionMode = 'Auto'; 
fig.PaperUnits = 'inches'; 
fig.PaperSize = [pos(3),pos(4)];
print(fig,'figures/fig05_cov_fading','-dpdf','-r0');
%% DRAW ASE CURVES
figure(6);
clf(6);

% all beamwidths / with fading
ca=4;
set( gca, 'ColorOrder', colorSpecBw, 'NextPlot', 'replacechildren' );
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

% peak / no fading
ca=2;
hp1 = loglog( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      peak_cov{ca}(:,4),...
      'Linewidth', 0.8,...
      'Color','k',...
      'Marker','o');
hold on;

% peak / with fading
ca=4;
hp2 = loglog( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      peak_cov{ca}(:,4),...
      'Linewidth', 1.2,...
      'Color','k',...
      'Marker','x');

% self-block free radius
rblock = line([blockFreeRadius blockFreeRadius],[1e-5 2],'Color',[.4 .4 .4]);
set( rblock, 'LineStyle', '--' );

ylim([ 1e-5 2 ]);
xlim( [ .8 100 ] );

xlabel('Half Inter-site Distance (m)');
ylabel( 'Area Spectral Efficiency (bps/Hz/m2) ');
legend([h1,h2,hp1,hp2,rblock],...
    bw_string(b1),...
    bw_string(b2),...
    ca_string{2},...
    ca_string{4},...
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
print(fig,'figures/fig06_ase_fading','-dpdf','-r0');