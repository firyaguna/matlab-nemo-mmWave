%% DRAW COVERAGE AND SPECTRAL EFFECIENCY CURVES

% fix all parameters except beamwidth and density
s = squeeze( sinr_vector( ...
                :, ... n_iter :::::::::::::::
                :, ... beamwidth_id :::::::::
                1, ... height_id
                :, ... density_id :::::::::::
                1, ... numBodies_id
                1, ... bodyAtt_id
                1  ... distanceToBody_id
            ));
% compute coverage and ASE as functions of beamwidth and density
[ cov, ase ] = ComputeResults( s, ... % SINR vector
                               db2pow( -5 ), ... % SINR threshold in dB
                               numberOfIterations, ...
                               interSiteDistance_vector, ...
                               beamWidth_vector );

%%
% % beamwidth design
% lhr = 2; % lobe-halfdistance-ratio
% for d_id = 1:length( isd )
%     bw_isd(d_id) = find( lobeEdge_matrix(:,2) > lhr.*.5.*isd(d_id), 1 );
%     design_cov(d_id) = cov( bw_isd(d_id), d_id );
%     design_ase(d_id) = ase( bw_isd(d_id), d_id );
% end % bw_isd: beamwidth designed for a given cell size

% envelope1: best density for each beamwidth
[ max_ss, s_isd ] = max( ase, [], 2 );
[ max_cc, c_isd ] = max( cov, [], 2 );
map_cc = diag( cov( :, s_isd ) )';

% for bw_id = 1:length(beamWidth_vector)
%     c_isd( bw_id ) = find( cov(bw_id,:) == max_cc(bw_id), 1, 'last' );
% end
map_ss = diag( ase( :, c_isd ) )';

% envelope2: best beamwidth for each density
[ max_ss2, s_bw ] = max( ase );
[ max_cc2, c_bw ] = max( cov );
map_cc2 = diag( cov( s_bw, : ) )';

% for d_id = 1:length(isd)
%     c_bw( d_id ) = find( cov(:,d_id) == max_cc2(d_id), 1, 'last' );
% end
map_ss2 = diag( ase( c_bw, : ) )';
%%

colorSpecBw0 = jet(length( beamWidth_vector ));
colorSpecBw = imadjust( colorSpecBw0, [], [.6 1] );
bw_id = 1;
bw_id2 = 11;

%%
figure(8);
clf(8);

r1 = annotation('textbox',...
    [0.13 0.11 0.19 0.82],...
    'String',{'I - high main-lobe interference'},...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'VerticalAlignment','middle',...
    'HorizontalAlignment','center',...
    'BackgroundColor','none');
r2 = annotation('textbox',...
    [0.32 0.11 0.18 0.82],...
    'String',{'II - min. main-lobe interfence'},...
    'LineStyle','none',...
    'VerticalAlignment','middle',...
    'HorizontalAlignment','center',...
    'BackgroundColor','none');
r3 = annotation('textbox',...
    [0.50 0.11 0.2 0.82],...
    'String',{'III - high side-lobe interfence'},...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'VerticalAlignment','middle',...
    'HorizontalAlignment','center',...
    'BackgroundColor','none');
r4 = annotation('textbox',...
    [0.7 0.11 0.2 0.82],...
    'String',{'IV - low interfence'},...
    'LineStyle','none',...
    'FitBoxToText','off',...
    'VerticalAlignment','middle',...
    'HorizontalAlignment','center',...
    'BackgroundColor','none');

set( gca, 'ColorOrder', colorSpecBw, 'NextPlot', 'replacechildren' );
% % all beamwidths
% h0 = semilogx( .5.*isd, 100.*cov, '-.' );
% set( h0, 'Linewidth', .5 );
% hold on;
% highlight one beamwidth
h1 = semilogx( .5.*isd, 100.*cov(bw_id,:), '-' );
hold on;
set( h1, 'Color', colorSpecBw0(bw_id,:) );
set( h1, 'Linewidth', 2 );
patch( [.5 .5 1.9 1.9], [0 102 102 0], [-1 -1 -1 -1], [.9 .9 .9], ...
    'LineStyle','none');
patch( [1.9 1.9 6 6], [0 102 102 0], [-1 -1 -1 -1], [.8 .8 .8], ...
    'LineStyle','none');
patch( [6 6 24 24], [0 102 102 0], [-1 -1 -1 -1], [.9 .9 .9], ...
    'LineStyle','none');
patch( [24 24 100 100], [0 102 102 0], [-1 -1 -1 -1], [.8 .8 .8], ...
    'LineStyle','none');
% h1x = semilogx( .5.*isd, 100.*cov(end-3,:), '-' );
% set( h1x, 'Color', colorSpecBw0(end-3,:) );
% set( h1x, 'Linewidth', 2 );
% % envelope
% h2 = semilogx( .5.*isd(c_isd(2:end-2)), 100.*max_cc(2:end-2), 'o-k' );
% % envelope2
% % h2x = semilogx( .5.*isd, 100.*max_cc2, 'v-m' );
% % designed
% % h3 = semilogx( .5.*isd, 100.*design_cov, 's--k' );
% % self-block free radius
% rblock = line([blockFreeRadius blockFreeRadius],[0 100],'Color',[.4 .4 .4]);
% set( rblock, 'LineStyle', '--' );

legend( h1, ...
    strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(bw_id)), '= %.0f ' ), '\circ' ),...
    'Location', 'northwest');

ylim([ 0 102 ]);
xlim( [ .5 100 ] );

switch db_id
    case 1
        uepos = ' pocket';
    case 2
        uepos = ' hand 50cm';
    case 3
        uepos = ' hand 15cm';
    case 4
        uepos = ' hand 30cm';
    case 5
        uepos = ' no body att';
end
title( strcat( num2str( apHeight_vector(h_id), 'AP %gm above UE in' ), ...
        uepos, ' with body att ', ...
        num2str( pow2db(bodyAttenuation_vector(ba_id)), '=%g dB' ) ) );

xlabel('Half Inter-site Distance (m)');
ylabel( num2str( st, 'Coverage SINR > %d dB (%%)'));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
set(gca,'XTick',[1;2;5;10;20;50;100]);
set(gca,'XTickLabel',[1;2;5;10;20;50;100]);

set(findall(gcf,'-property','FontSize'),'FontSize',12);

%%
figure(10);
clf(10);

set( gca, 'ColorOrder', colorSpecBw, 'NextPlot', 'replacechildren' );
% all beamwidths
h0 = semilogx( .5.*isd, 100.*cov, '-.' );
set( h0, 'Linewidth', .5 );
hold on;
% highlight one beamwidth
h1 = semilogx( .5.*isd, 100.*cov(bw_id,:), '-' );
set( h1, 'Color', colorSpecBw0(bw_id,:) );
set( h1, 'Linewidth', 2 );
% h1x = semilogx( .5.*isd, 100.*cov(end-bw_id2,:), '-' );
% set( h1x, 'Color', colorSpecBw0(end-bw_id2,:) );
% set( h1x, 'Linewidth', 2 );
% envelope
% h2 = semilogx( .5.*isd(c_isd(8:end-10)), 100.*max_cc(8:end-10), 'o-k' );
% set( h2, 'Linewidth', 1.5 );
% envelope2
% h2x = semilogx( .5.*isd, 100.*max_cc2, 'v-m' );
% designed
% h3 = semilogx( .5.*isd, 100.*design_cov, 's--k' );
% self-block free radius
rblock = line([blockFreeRadius blockFreeRadius],[0 100],'Color',[.4 .4 .4]);
set( rblock, 'LineStyle', '--' );

% legend( [h1,h1x,h2,rblock], ...
%     strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(bw_id)), '= %.0f ' ), '\circ' ), ...
%     strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(end-bw_id2)), '= %.0f ' ), '\circ' ), ...
%     'peak cov.', ...
%     'r_{blockFree}', ...
%     'Location', 'west');

ylim([ 0 102 ]);
xlim( [ .5 100 ] );

switch db_id
    case 1
        uepos = ' pocket';
    case 2
        uepos = ' hand 50cm';
    case 3
        uepos = ' hand 15cm';
    case 4
        uepos = ' hand 30cm';
    case 5
        uepos = ' no body att';
end
title( strcat( num2str( apHeight_vector(h_id), 'AP %gm above UE in' ), ...
        uepos, ' with body att ', ...
        num2str( pow2db(bodyAttenuation_vector(ba_id)), '=%g dB' ) ) );

xlabel('Half Inter-site Distance (m)');
ylabel( num2str( st, 'Coverage SINR > %d dB (%%)'));
grid on;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','on');
set(gca,'YMinorGrid','on');
set(gca,'XTick',[1;2;5;10;20;50;100]);
set(gca,'XTickLabel',[1;2;5;10;20;50;100]);

set(findall(gcf,'-property','FontSize'),'FontSize',12);

%%
figure(11);
clf(11);

set( gca, 'ColorOrder', colorSpecBw, 'NextPlot', 'replacechildren' );
% all beamwidths
h0 = loglog( .5.*isd, ase, '-.' );
set( h0, 'Linewidth', .5 );
hold on;
% highlight one beamwidth
h1 = loglog( .5.*isd, ase(bw_id,:), '-' );
set( h1, 'Color', colorSpecBw0(bw_id,:) );
set( h1, 'Linewidth', 2 );
h1x = loglog( .5.*isd, ase(end-bw_id2,:), '-' );
set( h1x, 'Color', colorSpecBw0(end-bw_id2,:) );
set( h1x, 'Linewidth', 2 );
%envelope
h2 = loglog( .5.*isd(c_isd(8:end-10)), map_ss(8:end-10), 'o-k' );
set( h2, 'Linewidth', 1.5 );
%envelope2
% h2x = loglog( .5.*isd, map_ss2, 'v-m' );
% designed ase
% h3 = loglog( .5.*isd, design_ase, 's--k' );
% self-block free radius
rblock = line([blockFreeRadius blockFreeRadius],[1e-5 1],'Color',[.4 .4 .4]);
set( rblock, 'LineStyle', '--' );

legend( [h1,h1x,h2,rblock], ...
    strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(bw_id)), '= %.0f ' ), '\circ' ), ...
    strcat( '\Theta_{BW} ', num2str( rad2deg(beamWidth_vector(end-bw_id2)), '= %.0f ' ), '\circ' ), ...
    'achieved ASE', ...
    'r_{blockFree}', ...
    'Location', 'northeast');

ylim([ 1e-5 2 ]);
xlim( [ .5 100 ] );

title( strcat( num2str( apHeight_vector(h_id), 'AP %gm above UE in' ), ...
        uepos, ' with body att ', ...
        num2str( pow2db(bodyAttenuation_vector(ba_id)), '=%g dB' ) ) );

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