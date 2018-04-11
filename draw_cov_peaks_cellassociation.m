ca_string = { 'No Fading / Max. Power' ; 'No Fading / Min. Dist.';...
    'Nakagami Fading / Max. Power' ; 'Nakagami Fading / Min. Dist.'};
nb_string = {'One Body'; 'Uncrowded' ; 'Crowded' };
fixParam.height_id = 1;
fixParam.bodyAtt_id = 1;
fixParam.sinrThreshold = -5; %dB
nb = 3;
fixParam.numBodies_id = nb; % 1 = one body, 2 = few bodies, 3 = many bodies

%% DRAW COVERAGE CELL ASSOCIATION IMPACT
figure(9);
clf(9);

% maxpower: -o
% mindist: --
% hand: blue
% pocket: red

% maxpower, hand
ca = 3;
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      100.*peak_cov{ca}(:,3),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Marker','o',...
      'Color','b',...
    'DisplayName', 'max power; hand');
hold on;

% mindist, hand
ca = 4;
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      100.*peak_cov{ca}(:,3),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','b',...
    'DisplayName', 'min dist; hand');
  
% maxpower, pocket
ca = 3;
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      100.*peak_cov{ca}(:,3),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Marker','o',...
      'Color','r',...
    'DisplayName', 'max power; pocket');

% mindist, pocket
ca = 4;
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      100.*peak_cov{ca}(:,3),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','r',...
    'DisplayName', 'min dist; pocket');

ylim([ 0 102 ]);
xlim( [ .8 110 ] );
xlabel('Half Inter-site Distance (m)');
ylabel( num2str( fixParam.sinrThreshold, 'Coverage SINR > %d dB (%%)'));
title(nb_string(nb));
legend('Location','best');
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
set(gca,'XTick',[1;2;5;10;20;50;100]);
set(gca,'XTickLabel',[1;2;5;10;20;50;100]);
% set(findall(gcf,'-property','FontSize'),'FontSize',12);
clear fig;
fig=gcf;
fig.OuterPosition = [100 100 600 400];
fig.Units = 'inches';
pos = fig.Position;
fig.PaperPositionMode = 'Auto'; 
fig.PaperUnits = 'inches'; 
fig.PaperSize = [pos(3),pos(4)];
print(fig,'figures/fig09_cov_cellassociation','-dpdf','-r0');

%% DRAW ASE CELL ASSOCIATION IMPACT
figure(10);
clf(10);

% maxpower: -o
% mindist: --
% hand: blue
% pocket: red

% maxpower, hand
ca = 3;
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;
loglog( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Marker','o',...
      'Color','b',...
    'DisplayName', 'max power; hand');
hold on;

% mindist, hand
ca = 4;
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;
loglog( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','b',...
    'DisplayName', 'min dist; hand');
  
% maxpower, pocket
ca = 3;
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
loglog( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Marker','o',...
      'Color','r',...
    'DisplayName', 'max power; pocket');

% mindist, pocket
ca = 4;
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
loglog( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','r',...
    'DisplayName', 'min dist; pocket');

ylim([ 1e-5 2 ]);
xlim( [ .8 110 ] );
xlabel('Half Inter-site Distance (m)');
ylabel( 'Area Spectral Efficiency (bps/Hz/m2) ');
title(nb_string(nb));
legend('Location','best');
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
set(gca,'XTick',[1;2;5;10;20;50;100]);
set(gca,'XTickLabel',[1;2;5;10;20;50;100]);
% set(findall(gcf,'-property','FontSize'),'FontSize',12);
clear fig;
fig=gcf;
fig.OuterPosition = [100 100 600 400];
fig.Units = 'inches';
pos = fig.Position;
fig.PaperPositionMode = 'Auto'; 
fig.PaperUnits = 'inches'; 
fig.PaperSize = [pos(3),pos(4)];
print(fig,'figures/fig10_ase_cellassociation','-dpdf','-r0');