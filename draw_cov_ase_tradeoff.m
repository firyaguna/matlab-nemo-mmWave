ca_string = { 'No Fading / Max. Power' ; 'No Fading / Min. Dist.';...
    'Nakagami Fading / Max. Power' ; 'Nakagami Fading / Min. Dist.'};
nb_string = {'One Body'; 'Uncrowded' ; 'Crowded' };
fixParam.height_id = 1;
fixParam.bodyAtt_id = 1;
fixParam.sinrThreshold = -5; %dB

ca = 3;

%% DRAW COVERAGE VERSUS ASE TRADE-OFF
figure(11);
clf(11);

% uncrowded: --
% crowded: -
% hand: blue
% pocket: red

% fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
% fixParam.numBodies_id = 1; % 1 = one body, 2 = few bodies, 3 = many bodies
% out_DataProcessing;
% semilogy( 100.*peak_cov{ca}(:,3), peak_cov{ca}(:,4),...
%       'Linewidth', 1.5,...
%       'LineStyle', ':',...
%       'Color','r',...
%     'DisplayName', 'one body; pocket');
% 
% hold on;

fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
fixParam.numBodies_id = 1; % 1 = one body, 2 = few bodies, 3 = many bodies
out_DataProcessing;
semilogy( 100.*peak_cov{ca}(:,3), peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','r',...
    'DisplayName', 'uncrowded; pocket');

hold on;

fixParam.distanceToBody_id = 1; % 1 = pocket, 2 = hand
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
out_DataProcessing;
semilogy( 100.*peak_cov{ca}(:,3), peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','r',...
    'DisplayName', 'crowded; pocket');

% fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
% fixParam.numBodies_id = 1; % 1 = one body, 2 = few bodies, 3 = many bodies
% out_DataProcessing;
% semilogy( 100.*peak_cov{ca}(:,3), peak_cov{ca}(:,4),...
%       'Linewidth', 1.5,...
%       'LineStyle', ':',...
%       'Color','b',...
%     'DisplayName', 'one body; hand');

fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
fixParam.numBodies_id = 1; % 1 = one body, 2 = few bodies, 3 = many bodies
out_DataProcessing;
semilogy( 100.*peak_cov{ca}(:,3), peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '--',...
      'Color','b',...
    'DisplayName', 'uncrowded; hand');

fixParam.distanceToBody_id = 2; % 1 = pocket, 2 = hand
fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
out_DataProcessing;
semilogy( 100.*peak_cov{ca}(:,3), peak_cov{ca}(:,4),...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
      'Color','b',...
    'DisplayName', 'crowded; hand');

legend('Location','best');
%%
ylabel( 'Achieved Area Spectral Efficiency (bps/Hz/m2) ');
xlabel( num2str( sinrThreshold, 'Peak Coverage SINR > %d dB (%%)'));
ylim( [ 1e-4 1.3 ] );
xlim([ 70 102 ]);
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
%% set(findall(gcf,'-property','FontSize'),'FontSize',12);
clear fig;
fig=gcf;
fig.OuterPosition = [200 200 500 500];
fig.Units = 'inches';
pos = fig.Position;
fig.PaperPositionMode = 'Auto'; 
fig.PaperUnits = 'inches'; 
fig.PaperSize = [pos(3),pos(4)];
%%
print(11,'figures/fig11_cov_ase_tradeoff','-dpdf','-r0');