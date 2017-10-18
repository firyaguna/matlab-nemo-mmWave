%% COMPUTE COVERAGE AND SPECTRAL EFFICIENCY FROM SINR VECTOR

% fix all parameters except beamwidth and density
height_id = 1;
numBodies_id = 1;
bodyAtt_id = 1;
distanceToBody_id = 2;
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
sinrThreshold = -5;
[ cov, ase ] = ComputeResults( s, ... % SINR vector
                               db2pow( sinrThreshold ), ... % SINR threshold in dB
                               numberOfIterations, ...
                               interSiteDistance_vector, ...
                               beamWidth_vector );
                           
%% DRAW COVERAGE CURVES
figure();

% all beamwidths
h0 = semilogx( .5.*interSiteDistance_vector, 100.*cov, '-.' );
set( h0, 'Linewidth', .5 );
ylim([ 0 102 ]);
xlim( [ .5 100 ] );

switch distanceToBody_id
    case 1
        uepos = ' pocket';
    case 2
        uepos = ' hand';
end

title( strcat( num2str( apHeight_vector(height_id), 'AP %gm above UE in' ), ...
        uepos ) );
legend( ...    
    strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(1)), '= %.0f ' ), '\circ' ), ...
    strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(2)), '= %.0f ' ), '\circ' ), ...
    strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(3)), '= %.0f ' ), '\circ' ) ...
    );

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
h0 = loglog( .5.*interSiteDistance_vector, ase, '-.' );
set( h0, 'Linewidth', .5 );
hold on;
ylim([ 1e-5 2 ]);
xlim( [ .5 100 ] );

switch distanceToBody_id
    case 1
        uepos = ' pocket';
    case 2
        uepos = ' hand';
end

title( strcat( num2str( apHeight_vector(height_id), 'AP %gm above UE in' ), ...
        uepos ) );
legend( ...    
    strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(1)), '= %.0f ' ), '\circ' ), ...
    strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(2)), '= %.0f ' ), '\circ' ), ...
    strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(3)), '= %.0f ' ), '\circ' ) ...
    );

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