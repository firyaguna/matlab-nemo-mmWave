fixParam.height_id = 1;
fixParam.bodyAtt_id = 1;
ca = 4;
fixParam.sinrThreshold = -5; %dB
fixParam.numBodies_id = 1; % 1 = one body, 2 = few bodies, 3 = many bodies
fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
out_DataProcessing;

%% DRAW BEAMWIDTH VS. INTER-SITE DISTANCE 
figure();

semilogx( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','b',...
    'DisplayName', 'peak coverage');

hold on;

semilogx( .5.*interSiteDistance_vector(peak_ase{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_ase{ca}(:,2))),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','m',...
    'DisplayName', 'peak ASE');

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
%%

figure();
mesh( .5.*interSiteDistance_vector, ...
    rad2deg(beamWidth_vector),...
    100.*cov{ca} );
view(120,70);
hold on;
pa = plot3( .5.*interSiteDistance_vector(peak_ase{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_ase{ca}(:,2))), ...
    100.*peak_ase{ca}(:,3),...
    'o-');
pc = plot3( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))), ...
    100.*peak_cov{ca}(:,3),...
    'x-');
legend([pa,pc],...
    'Peak ASE',...
    'Peak Coverage',...
    'Location','best');
zlabel( num2str( fixParam.sinrThreshold, 'Coverage SINR > %d dB (%%)'));
xlabel('Half Inter-site Distance (m)');
ylabel('Beamwidth (degrees)');
set(gca,'XTick',[1;2;5;10;20;50;100]);
set(gca,'XTickLabel',[1;2;5;10;20;50;100]);
set(gca,'YTick',[0;30;60;90;120;150;180]);
set(gca,'YTickLabel',[0;30;60;90;120;150;180]);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
set(gca,'XScale','log');
%%
figure();
h = mesh( .5.*interSiteDistance_vector, ...
    rad2deg(beamWidth_vector),...
    ase{ca} );
h.CData = log10(h.CData);
view(140,20);
hold on;
pa = plot3( .5.*interSiteDistance_vector(peak_ase{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_ase{ca}(:,2))), ...
    peak_ase{ca}(:,4),...
    'o-');
pc = plot3( .5.*interSiteDistance_vector(peak_cov{ca}(:,1)), ...
    rad2deg(beamWidth_vector(peak_cov{ca}(:,2))), ...
    peak_cov{ca}(:,4),...
    'x-');

legend([pa,pc],...
    'Peak ASE',...
    'Peak Coverage',...
    'Location','best');
zlabel('Area Spectral Efficiency (b/s/Hz)');
xlabel('Half Inter-site Distance (m)');
ylabel('Beamwidth (degrees)');
set(gca,'XTick',[1;2;5;10;20;50;100]);
set(gca,'XTickLabel',[1;2;5;10;20;50;100]);
set(gca,'YTick',[0;30;60;90;120;150;180]);
set(gca,'YTickLabel',[0;30;60;90;120;150;180]);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
set(gca,'XScale','log');
set(gca,'ZScale','log');