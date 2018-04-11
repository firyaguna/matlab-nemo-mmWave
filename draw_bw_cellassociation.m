ca_string = { 'No Fading / Max. Power' ; 'No Fading / Min. Dist.';...
    'Nakagami Fading / Max. Power' ; 'Nakagami Fading / Min. Dist.'};
nb_string = {'One Body'; 'Uncrowded' ; 'Crowded' };
fixParam.height_id = 1;
fixParam.bodyAtt_id = 1;
fixParam.sinrThreshold = -5; %dB
nb = 2;
fixParam.numBodies_id = nb; % 1 = one body, 2 = few bodies, 3 = many bodies

%% DRAW BEAMWIDTH VS. INTER-SITE DISTANCE - BLOCKAGE - mindist
figure(15);
clf(15);

% maxpower: -o
% mindist: --
% hand: blue
% pocket: red

% maxpower
ca = 3;
% hand
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','b',...
      'Marker','o',...
    'DisplayName', 'max. power; hand');

hold on;

% pocket
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','r',...
      'Marker','o',...
    'DisplayName', 'max. power; pocket');

% mindist
ca = 4;
%  hand
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','b',...
    'DisplayName', 'min. dist.; hand');

hold on;

% pocket
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','r',...
    'DisplayName', 'min. dist.; pocket');

axis([0,100,0,180]);
title(nb_string(nb));
xlabel('Half Inter-site Distance (m)');
ylabel('Beamwidth (degrees)');
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
set(gca,'XTick',[1;2;5;10;20;50;100]);
set(gca,'XTickLabel',[1;2;5;10;20;50;100]);
set(gca,'YTick',[0;30;60;90;120;150;180]);
set(gca,'YTickLabel',[0;30;60;90;120;150;180]);
legend('Location','best');
clear fig;
fig=gcf;
fig.OuterPosition = [100 100 600 400];
fig.Units = 'inches';
pos = fig.Position;
fig.PaperPositionMode = 'Auto'; 
fig.PaperUnits = 'inches'; 
fig.PaperSize = [pos(3),pos(4)];
print(fig,'figures/fig15_beamwidth_cellassociation','-dpdf','-r0');

