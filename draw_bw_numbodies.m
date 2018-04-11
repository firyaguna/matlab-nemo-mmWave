ca_string = { 'No Fading / Max. Power' ; 'No Fading / Min. Dist.';...
    'Nakagami Fading / Max. Power' ; 'Nakagami Fading / Min. Dist.'};
nb_string = {'One Body'; 'Uncrowded' ; 'Crowded' };
fixParam.height_id = 1;
fixParam.bodyAtt_id = 1;
fixParam.sinrThreshold = -5; %dB

%% DRAW BEAMWIDTH VS. INTER-SITE DISTANCE - BLOCKAGE - mindist
figure(13);
clf(13);

ca = 4;
% uncrowded: --
% crowded: -
% hand: blue
% pocket: red

% uncrowded, hand
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;

semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
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
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','b',...
    'DisplayName', 'crowded; hand');

% uncrowded, pocket
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;

semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','r',...
    'DisplayName', 'uncrowded; pocket');

% crowded, pocket
fixParam.numBodies_id = 3; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','r',...
    'DisplayName', 'crowded; pocket');

axis([0,100,0,180]);
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
print(fig,'figures/fig13_beamwidth_numbodies_mindist','-dpdf','-r0');

%% DRAW BEAMWIDTH VS. INTER-SITE DISTANCE - BLOCKAGE - maxpow
figure(14);
clf(14);

ca = 3;
% uncrowded: --
% crowded: -
% hand: blue
% pocket: red

% uncrowded, hand
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;

semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
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
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','b',...
    'DisplayName', 'crowded; hand');

% uncrowded, pocket
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;

semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','r',...
    'DisplayName', 'uncrowded; pocket');

% crowded, pocket
fixParam.numBodies_id = 3; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
out_DataProcessing;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','r',...
    'DisplayName', 'crowded; pocket');

axis([0,100,0,180]);
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
print(fig,'figures/fig14_beamwidth_numbodies_maxpower','-dpdf','-r0');