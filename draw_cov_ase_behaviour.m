%% EXTRACT SINR DATA
cellAssociation = 'max_power';
if strcmp( cellAssociation, 'max_power' )
    % Maximum Received Power Cell Association
    load sinr_vector_no_fading_maxpower;
    s_no_fading = sinr_vector;
    load sinr_vector_yoo_fading_maxpower;
    s_yoo_fading = sinr_vector;
    load sinr_vector_body_fading_maxpower;
    s_body_fading = sinr_vector;
else
    % Mininum Distance Cell Association
    load sinr_vector_no_fading_mindist;
    s_no_fading = sinr_vector;
    load sinr_vector_yoo_fading_mindist;
    s_yoo_fading = sinr_vector;
    load sinr_vector_body_fading_mindist;
    s_body_fading = sinr_vector;
end
%%
sinr_cell = cell(1,3);
sinr_cell{1} = s_no_fading;
sinr_cell{2} = s_yoo_fading;
sinr_cell{3} = s_body_fading;
cov = cell(1,3);
ase = cell(1,3);

%% fix all parameters except density
beamwidth_id = 3;
height_id = 1;
numBodies_id = 1; % 1 = user body, 2 = 3200 bodies
bodyAtt_id = 1;
distanceToBody_id = 2; % 1 = pocket, 2 = hand
sinrThreshold = -5;

%% COMPUTE COVERAGE AND SPECTRAL EFFICIENCY FROM SINR VECTOR
for i=1:3
    sinr_vector = sinr_cell{i};
    % set the SINR vector only as function of beamwidth and density
    s = squeeze( sinr_vector( ...
                    :, ... n_iter :::::::::::::::
                    :, ... beamwidth_id :::::::::
                    height_id, ... 
                    :, ... density_id :::::::::::
                    numBodies_id, ... 
                    bodyAtt_id, ... 
                    distanceToBody_id  ... 
                ));
    % compute coverage and ASE as functions of beamwidth and density
    [ cov{i}, ase{i} ] = ComputeResults( s, ... % SINR vector
                                   db2pow( sinrThreshold ), ... % SINR threshold in dB
                                   numberOfIterations, ...
                                   interSiteDistance_vector, ...
                                   beamWidth_vector );
end
                           
%% DRAW COVERAGE CURVES
figure();

% all beamwidths
h1 = semilogx( .5.*interSiteDistance_vector, 100.*cov{1}(beamwidth_id,:), '-', 'Linewidth', .5 );
hold on;
h2 = semilogx( .5.*interSiteDistance_vector, 100.*cov{2}(beamwidth_id,:), '-.', 'Linewidth', .5 );
h3 = semilogx( .5.*interSiteDistance_vector, 100.*cov{3}(beamwidth_id,:), '-.', 'Linewidth', .5 );

ylim([ 0 102 ]);
xlim( [ .5 100 ] );

uepos = { ' pocket', ' hand' };
title( strcat( num2str( apHeight_vector(height_id), 'AP %gm above UE in' ), ...
        uepos{distanceToBody_id} ) );
% legend( ...    
%     strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(1)), '= %.0f ' ), '\circ' ), ...
%     strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(2)), '= %.0f ' ), '\circ' ), ...
%     strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(3)), '= %.0f ' ), '\circ' ) ...
%     );

legend( 'no fading', 'yoo fading', 'my fading' );

str_n_body = {'1 body (user)','3200 bodies'};
annotation('textbox',...
    [0.14 0.5 0.23 0.14],...
    'String',{strcat( '\Theta_{BW} ', ...
                    num2str( rad2deg(beamWidth_vector(beamwidth_id)), '= %.0f ' ), ...
                    '\circ' ), ...
        str_n_body{numBodies_id}},...
    'FitBoxToText','off');

xlabel('Half Inter-site Distance (m)');
ylabel( num2str( sinrThreshold, 'Coverage SINR > %d dB (%%)'));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
set(gca,'XTick',[1;2;5;10;20;50;100]);
set(gca,'XTickLabel',[1;2;5;10;20;50;100]);

set(findall(gcf,'-property','FontSize'),'FontSize',12);

%% DRAW SPECTRAL EFFICIENCY CURVES
figure();

% all beamwidths
h1 = loglog( .5.*interSiteDistance_vector, 100.*ase{1}(beamwidth_id,:), '-', 'Linewidth', .5 );
hold on;
h2 = loglog( .5.*interSiteDistance_vector, 100.*ase{2}(beamwidth_id,:), '-.', 'Linewidth', .5 );
h3 = loglog( .5.*interSiteDistance_vector, 100.*ase{3}(beamwidth_id,:), '-.', 'Linewidth', .5 );

ylim([ 1e-5 2 ]);
xlim( [ .5 100 ] );

uepos = { ' pocket', ' hand' };
title( strcat( num2str( apHeight_vector(height_id), 'AP %gm above UE in' ), ...
        uepos{distanceToBody_id} ) );

legend( 'no fading', 'yoo fading', 'my fading' );

str_n_body = {'1 body (user)','3200 bodies'};
annotation('textbox',...
    [0.14 0.5 0.23 0.14],...
    'String',{strcat( '\Theta_{BW} ', ...
                    num2str( rad2deg(beamWidth_vector(beamwidth_id)), '= %.0f ' ), ...
                    '\circ' ), ...
        str_n_body{numBodies_id}},...
    'FitBoxToText','off');

xlabel('Half Inter-site Distance (m)');
ylabel( 'Area Spectral Efficiency (bps/Hz/m2) ');
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
set(gca,'XTick',[1;2;5;10;20;50;100]);
set(gca,'XTickLabel',[1;2;5;10;20;50;100]);

set(findall(gcf,'-property','FontSize'),'FontSize',12);