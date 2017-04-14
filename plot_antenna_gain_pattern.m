%% Antenna pattern
w = deg2rad(0:180)';
M = MainLobeGain(beamWidth_vector,sideLobeGainTx); % w = 0
pattern = repmat( M, length(w), 1 );

for bw_id = 1:length(beamWidth_vector)
    side_ids = round(rad2deg(beamWidth_vector( bw_id ))/2)+1 : length(w);
    pattern( side_ids, bw_id ) = sideLobeGainTx;
end
 
colorSpecBw0 = jet(length( beamWidth_vector ));
colorSpecBw = imadjust( colorSpecBw0, [], [.6 1] );
beamWidthLegendCell = cellstr( num2str( rad2deg( beamWidth_vector' ), '%.0f deg' ) );


figure(5);
clf(5);
% hold on;
for bw_id = 1:length(beamWidth_vector)
    h(bw_id) = polarplot( [-flipud(w);w], ...
        [flipud(pow2db(pattern(:,bw_id))); pow2db(pattern(:,bw_id))] );
    hold on;
    set( h(bw_id), 'color', colorSpecBw(bw_id,:), 'Linestyle', '-' );
    rlim([-15,35]);
    thetalim([-180,180]);
end

bw_1 = 5; bw_2 = 17; bw_3 = 39;
set( h(bw_1), 'color', colorSpecBw0(bw_1,:), 'Linewidth', 2, 'Linestyle', '-' );
set( h(bw_2), 'color', colorSpecBw0(bw_2,:), 'Linewidth', 2, 'Linestyle', '-' );
set( h(bw_3), 'color', colorSpecBw0(bw_3,:), 'Linewidth', 2, 'Linestyle', '-' );

l=legend([h(bw_1),h(bw_2),h(bw_3)], ...
    beamWidthLegendCell{bw_1}, ...
    beamWidthLegendCell{bw_2}, ...
    beamWidthLegendCell{bw_3}, ...
    'Location', 'southwest');
set( get(l,'title'),'string','Beamwidth');

set( gca, 'RAxisLocation', 180 );
set( gca, 'RMinorTick', 'on' );
set( gca, 'RMinorGrid', 'on' );

annotation('textbox',...
    [0.29 0.50 0.22 0.07],...
    'String',{'Antenna Gain (dBi)'},...
    'LineStyle','none',...
    'FitBoxToText','off');

set(findall(gcf,'-property','FontSize'),'FontSize',12);