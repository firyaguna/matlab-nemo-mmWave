ca_string = { 'No Fading / Max. Power' ; 'No Fading / Min. Dist.';...
    'Nakagami Fading / Max. Power' ; 'Nakagami Fading / Min. Dist.'};
fixParam.height_id = 1;
fixParam.bodyAtt_id = 1;
fixParam.sinrThreshold = -5; %dB
ca = 4;

%% DRAW COVERAGE BLOCKAGE IMPACT
figure(7);
clf(7);

% uncrowded: --
% crowded: -
% hand: blue
% pocket: red

% uncrowded, hand
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      100.*peak_cov{ca}(:,3),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','b',...
    'DisplayName', 'uncrowded; hand');
hold on;

% crowded, hand
fixParam.numBodies_id = 3; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      100.*peak_cov{ca}(:,3),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','b',...
    'DisplayName', 'crowded; hand');
  
% uncrowded, pocket
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      100.*peak_cov{ca}(:,3),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','r',...
    'DisplayName', 'uncrowded; pocket');

% crowded, pocket
fixParam.numBodies_id = 3; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      100.*peak_cov{ca}(:,3),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','r',...
    'DisplayName', 'crowded; pocket');

ylim([ 0 102 ]);
xlim( [ .8 110 ] );
xlabel('Half Inter-site Distance (m)');
ylabel( num2str( fixParam.sinrThreshold, 'Coverage SINR > %d dB (%%)'));
title(ca_string(ca));
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
print(fig,'figures/fig07_cov_numbodies','-dpdf','-r0');

%% DRAW ASE BLOCKAGE IMPACT
figure(8);
clf(8);

% uncrowded: --
% crowded: -
% hand: blue
% pocket: red

% uncrowded, hand
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;
loglog( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','b',...
    'DisplayName', 'uncrowded; hand');
hold on;

% crowded, hand
fixParam.numBodies_id = 3; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;
loglog( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','b',...
    'DisplayName', 'crowded; hand');
  
% uncrowded, pocket
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
loglog( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','r',...
    'DisplayName', 'uncrowded; pocket');

% crowded, pocket
fixParam.numBodies_id = 3; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
loglog( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
      peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','r',...
    'DisplayName', 'crowded; pocket');

ylim([ 1e-5 2 ]);
xlim( [ .8 110 ] );
xlabel('Half Inter-site Distance (m)');
ylabel( 'Area Spectral Efficiency (bps/Hz/m2) ');
title(ca_string(ca));
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
print(fig,'figures/fig08_ase_numbodies','-dpdf','-r0');