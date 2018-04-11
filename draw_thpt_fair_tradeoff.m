ca_string = { 'No Fading / Max. Power' ; 'No Fading / Min. Dist.';...
    'Nakagami Fading / Max. Power' ; 'Nakagami Fading / Min. Dist.'};
nb_string = {'One Body'; 'Uncrowded' ; 'Crowded' };
fixParam.height_id = 1;
fixParam.bodyAtt_id = 1;
fixParam.sinrThreshold = -5; %dB

ca = 3;

%% DRAW COVERAGE VERSUS ASE TRADE-OFF
figure(21);
clf(21);

% uncrowded: --
% crowded: -
fixParam.distanceToBody_id = 2;

% fixParam.numBodies_id = 1; % 1 = one body, 2 = few bodies, 3 = many bodies
% out_DataProcessing;

% plot( peak_fair{ca}, peak_thpt{ca}./1e9,...
%       'Linewidth', 1.5,...
%       'LineStyle', '--',...
%     'DisplayName', 'uncrowded');
% 
% hold on;

fixParam.numBodies_id = 2; % 1 = one body, 2 = few bodies, 3 = many bodies
out_DataProcessing;
plot( peak_fair{ca}, peak_thpt{ca}./1e9,...
      'Linewidth', 1.5,...
      'LineStyle', '-',...
    'DisplayName', 'crowded');


legend('Location','best');

ylabel( 'Average UE Throughput (Gbps) ');
xlabel( 'Jain Fairness Index');
% ylim( [ 1e-4 1.3 ] );
% xlim([ 70 102 ]);
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
print(fig,'figures/fig21_thpt_fair_tradeoff','-dpdf','-r0');