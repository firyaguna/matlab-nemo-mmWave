fixParam.height_id = 1;
fixParam.bodyAtt_id = 1;
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = intermediate, 3 = hand
fixParam.sinrThreshold = -5; %dB
out_DataProcessing;

%% DRAW BEAMWIDTH VS. INTER-SITE DISTANCE - FADING
figure(12);
clf(12);

ca = 2; % 1 = maxPower, 2 = minDist

semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
    'b',...
    'Linewidth', 1.5,...
    'DisplayName', 'no fading');

hold on;

ca = 4;
semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
    'r',...
    'Linewidth', 1.5,...
    'DisplayName', 'Nakagami fading');

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
print(fig,'figures/fig12_beamwidth_fading','-dpdf','-r0');
