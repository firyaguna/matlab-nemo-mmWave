%% COMPUTE CDF FROM SINR VECTOR



%% EXTRACT SINR DATA
sinr_cell = cell(2,2); %(ca,fading)
sinr_cell{1} = sinr_struct.maxPower;
sinr_cell{2} = sinr_struct.minDist;
sinr_cell{3} = sinr_struct.fading.maxPower;
sinr_cell{4} = sinr_struct.fading.minDist;

ca_string = { 'No Fading / Max. Power' ; 'No Fading / Min. Dist.';...
    'Nakagami Fading / Max. Power' ; 'Nakagami Fading / Min. Dist.'};
ca = 3;
sinr_vector = sinr_cell{ca};
fixParam.distanceToBody_id = 2;
fixParam.density_id = 11;
fixParam.beamwidth_id = 24;
fixParam.numBodies_id = 1;
% set the SINR vector 
s = squeeze( sinr_vector( ...
                :, ... n_iter :::::::::::::::
                fixParam.beamwidth_id, ... beamwidth_id, ...:::::::::::::::
                :, ... height_id, ... :::::::::::::::
                fixParam.density_id, ... density_id, ...:::::::::::::::
                fixParam.numBodies_id, ... numBodies_id, ... :::::::::::::::
                :, ... bodyAtt_id, ... 
                fixParam.distanceToBody_id  ... 
            ));
[y,x] = out_ComputeCDF( pow2db(s) ); 
%% ANALYTICAL CDF
% th = db2pow(-50:20);
% cp = zeros(size(th));
% for i=1:length(th)
% cp(i) = CoverageProbability(sim,th(i));
% end
cp = [-40, 0.998302;...
      -35, 0.994639;...
      -30, 0.983152;...
      -25, 0.947741;...
      -20, 0.844377;...
      -15, 0.589039;...
      -10, 0.197845;...
      -05, 0.00936208;...
       00, 7.62939e-6;...
       05, 2.96055e-11;...
       10, 1.97845e-18];

%% DRAW SINR CDF
figure(1);
clf(1);

plot(x,100-y,...
    'DisplayName', 'simulated - Nakagami',...
    'LineWidth', 1.5 );
hold on;
% plot(-50:20,100.*cp,...
%     'DisplayName', 'analytical - Rayleigh',...
%     'LineWidth', 1.5 );
plot(cp(:,1),100.*cp(:,2),...
    'DisplayName', 'analytical - Rayleigh',...
    'LineWidth', 1.5 );
% axis( [ -10 50 0 100 ] );
legend('location','best');

switch fixParam.distanceToBody_id
    case 1
        uepos = ' pocket';
    case 2
        uepos = ' hand';
end

title( strcat( num2str( apHeight_vector(height_id), 'h_{AP} = %gm,'), ...
        ' UE in ', uepos, ...
        ', \theta_{AP}', num2str(90, '= %.0f ' ), '\circ', ...
        ', ISD = ', num2str(20, '%gm' ) ) );
% title( strcat( num2str( apHeight_vector(height_id), 'h_{AP} = %gm,'), ...
%         ' UE in ', uepos, ...
%         ', \theta_{AP}', num2str( rad2deg(beamWidth_vector(fixParam.beamwidth_id)), '= %.0f ' ), '\circ', ...
%         ', ISD = ', num2str(interSiteDistance_vector(fixParam.density_id), '%gm' ) ) );

ylabel('CCDF [%]'); 
xlabel('SINR threshold \zeta (dB)');
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
%%
clear fig;
fig=gcf;
fig.OuterPosition = [100 100 600 400];
fig.Units = 'inches';
pos = fig.Position;
fig.PaperPositionMode = 'Auto'; 
fig.PaperUnits = 'inches'; 
fig.PaperSize = [pos(3),pos(4)];

figname = 'figures/ccdf_sinr_rayleigh_nakagami_spatial_averaged';
print(fig,figname,'-dpdf','-r0');