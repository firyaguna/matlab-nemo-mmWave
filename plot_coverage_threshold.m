h_id = 1;
isd = interSiteDistance_vector;
%%
lineSpecSt = { '-.'; '-'; '--' };
markerSpecSt = { 'o'; 's'; 'x' };
st = -5:5:0;

for db_id = [ 1 4 ]
    
    % self-body block free radius
    blockFreeRadius = apHeight_vector(h_id) * ...
        distanceToUserBody_vector(db_id) ...
        / distanceToTopHead;
            
    figure(db_id);
    clf(db_id);
    for ca_id = 1:2
        if ca_id == 1
        set( gca, 'ColorOrder', autumn(length(st)+1), 'NextPlot', 'add' );
        end
        if ca_id == 2
        set( gca, 'ColorOrder', winter(length(st)), 'NextPlot', 'add' );
        end
        for st_id = st

            s = squeeze( sinrv{ca_id}( :,:,h_id,:,:,:,db_id ) ); % 10000 50 101
            sinr_threshold = db2pow( st_id );
            cov = sum( s > sinr_threshold, 1 ) ./ numberOfIterations;
            cov = squeeze( cov );

            [ max_cc, m_isd ] = max( cov, [], 2 );
            
            for bw_id = 1:length(beamWidth_vector)
                m_isd( bw_id ) = find( cov(bw_id,:) == max_cc(bw_id), 1, 'last' );
            end

            h( ca_id, st_id/5 +2 ) = semilogx( .5.*isd(m_isd(10:end-10)), 100.*max_cc( 10:end-10 ) );
            hold on;
            set( h( ca_id, st_id/5 +2 ), 'Marker', markerSpecSt{2+ st_id/5} );
            set( h( ca_id, st_id/5 +2 ), 'LineStyle', lineSpecSt{2+ st_id/5} );

            if st_id == 0
                if db_id == 1
                    if ca_id == 2
                        bw_id = 23;
                    end
                    if ca_id == 1
                        bw_id = 20;
                    end
                else
                    if ca_id == 2
                        bw_id = 32;
                    end
                    if ca_id == 1
                        bw_id = 31;
                    end
                end
            
                semilogx(.5.*isd(m_isd(bw_id)), 100.*max_cc(bw_id),'hk');
                text( .5.*isd(m_isd(bw_id)), 100.*max_cc(bw_id), ...
                        { strcat( ' \Theta_{BW}', ...
                                num2str( rad2deg(beamWidth_vector(bw_id)), ' = %.0f '), ...
                                '\circ' ) ...
                        } ...
                    );
            end
        end % st_id
            
        

    end % cell association
    
    rblock = line([blockFreeRadius blockFreeRadius],[0 100],'Color',[.3 .3 .3] );
    set( rblock, 'LineStyle', '--' );
    
    legend( [h(1,1), h(1,2), h(2,1), h(2,2)], ...
            'min dist, T = -5 dB', ...
            'min dist, T = 0 dB', ...
            'max pow, T = -5 dB', ...
            'max pow, T = 0 dB', ...
            'Location', 'southwest' );

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
    grid on;
    set(gca,'XMinorTick','on');
    set(gca,'YMinorTick','on');
    set(gca,'XMinorGrid','on');
    set(gca,'YMinorGrid','on');
    set(gca,'XScale','log');
    set(gca,'XTick',[1;2;5;10;20;50;100]);
    set(gca,'XTickLabel',[1;2;5;10;20;50;100]);
    ylim([ 0 105 ]);
    xlim( [ .5 100 ] );

    xlabel('Half Inter-site Distance (m)');
    ylabel( 'Coverage SINR > T (%)');

    set(findall(gcf,'-property','FontSize'),'FontSize',12);
    
end % db_id
