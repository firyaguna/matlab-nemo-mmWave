sim_parameters;

% PATH LOSS MODEL
PL_LOS = @(d) (4*pi*frequency*1e9/3e8)^-2 .* d .^ ( - n_L ); % d is the 3d distance
% ANTENNA GAIN MODEL
ANT_GAIN = @(d,rm,m,M) m + (M-m).*heaviside(-d+rm); % d is the 2d distance

% blocking angle
 phi = @(b,w) 2.*atan(((2.*b)./w).^-1);
 inv_phi = @(p,w) w./(2.*tan(p/2));

% AP BLOCKED BY ONE RANDOM BODY PROBABILITY
% CDF of angle approximation
Ft = @(t) t./(2*pi);
% PDF of blocking angle
fl1 = @(p,w,a) ...
    ( - 2.*pi.*inv_phi(p,w)./(2.*a).^2 ...
      + 8.*(inv_phi(p,w)).^2./(2.*a).^3 ...
      - 2.*(inv_phi(p,w)).^3./(2.*a).^4 ).* ...
    ( w./(2.*(cos(p)-1)) );

P_block = @(d,t,h,w,a) ...
    integral(@(p) Ft(p).*fl1(p,w,a),phi(d.*t./h,w),pi);

% P_block = @(d,t,h,w,a) ...
%     -(w/(4*a))^2.*...
%     ( pi/2 + ...
%     ( phi(t.*d./h,w)+ sin(phi(t.*d./h,w)) )./...
%     ( cos(phi(t.*d./h,w)) - 1 ) );
% P_block = @(d,t,h,w,a) ...
%     (2*a)^-2 .* ( ...
%     d.*w ...
%     - d.^2 .* (1-t/h)^2 .* asin(w./(2.*d.*(1-t/h))) ...
%     - .5.*w.*sqrt( d.^2 .* (1-t/h)^2 + (w/2)^2 ) ...
%     );
% AP BLOCKED BY SELF-BODY PROBABILITY
P_selfBlock = @(d,w) phi(d,w)./(2*pi);

% AP BLOCKED PROBABILITY
P_ApBlocked = @(d,t,h,dtb,w,a,Nb) ...
    1 - (1-P_blockL(d,t,h,w,a)).^Nb + ...
            (1-P_blockL(d,t,h,w,a)).^Nb .* ...
            P_selfBlock(dtb,w) .* ...
            (1 - heaviside(dtb-d.*t./h));
%% INITIALIZE VECTORS
sinr_vector = zeros( numberOfIterations, ...
                       length( numberOfRandomBodies_vector) );
lobeEdge_matrix = zeros( length( beamWidth_vector ), ...
                       length( apHeight_vector ) );
numberOfAps_vector = zeros( size( interSiteDistance_vector ) );

%% CALCULATE SINR
distanceToBody = distanceToUserBody_vector;
h_id = 1;
apHeight = apHeight_vector(h_id);

for bl_id = 1:length( numberOfRandomBodies_vector )

    numberOfBodies = numberOfRandomBodies_vector( bl_id );

    for bw_id = 1:length( beamWidth_vector )

        % CELL PROPERTIES
        beamWidthTx = beamWidth_vector( bw_id );
        mainLobeGainTx = MainLobeGain( beamWidthTx, sideLobeGainTx );
        mainLobeEdgeTx = apHeight * tan( beamWidthTx / 2 );
        lobeEdge_matrix( bw_id, h_id ) = mainLobeEdgeTx;

        for d_id = 1:length( interSiteDistance_vector )

            % GENERATE TOPOLOGY
            interSiteDistance = interSiteDistance_vector( d_id );
            [ apPosition, numberOfAps ] = ...
                HexagonCellGrid( areaSide, interSiteDistance );
            numberOfAps_vector( d_id ) = numberOfAps;
            cellRadius = interSiteDistance * sin( pi/6 ) / sin( 2*pi/3 );
            blockageTrialsIndy = zeros( 1, numberOfAps );
            blockageTrialsCorr = zeros( 1, numberOfAps );
            
                            
            for n_iter = 1:numberOfIterations

                % PLACE USER EQUIPMENT
                uePosition= ( -1+2*rand(1) + -1i+2i*rand(1) );
%               uePosition = .9 + 1i*.8;
%                 ueInCell = 0;
%                 while( ~ueInCell )
%                     % Generate random position
%                     uePosition = ( -1+2*rand(1) + -1i+2i*rand(1) );
%                     xq = real( uePosition );
%                     yq = imag( uePosition );
%                     % Define hexagon cell limits
%                     L = linspace(0,2.*pi,7);
%                     xv = cos(L)';
%                     yv = sin(L)';
%                     % Check if random position is inside hexagon
%                     ueInCell = inpolygon(xq,yq,xv,yv);
%                 end
                % Place UE in origin and shift cell positions
                apPosition_temp = apPosition - areaSide/2 * uePosition;
                % Get 2-D distance from AP to UE
                distance2d = abs( apPosition_temp );
                % Get angle of arrival from AP to UE
                angleToAp = angle( apPosition_temp );
                % Get 3-D distance from AP to UE
                distance3d = sqrt( distance2d.^2 + apHeight^2 );

                % DOWNLINK TRANSMIT POWER
                % Transmit power per area is constant
                rxPower = txPower;
                
                % Apply directional antenna gain
                rxPower = rxPower .* ANT_GAIN( distance2d,...
                                        mainLobeEdgeTx,...
                                        sideLobeGainTx,...
                                        mainLobeGainTx );

                % Apply path loss
                rxPower = rxPower .* PL_LOS( distance3d );
                            
                % Apply body blockage
%                 % APs behind blocked APs are also blocked
%                 % Sort APs by distance
%                 [sortedDistance2d,i_sorted] = sort( distance2d );
%                 for i = i_sorted
%                     % compute the blockage from the closest
%                     blockageTrialsCorr(i) = or( ...
%                         blockageTrialsCorr(i) , binornd(...
%                             1,...
%                             P_ApBlocked( distance2d(i),...
%                                          distanceToTopHead,...
%                                          apHeight,...
%                                          distanceToBody,...
%                                          bodyWide,...
%                                          areaSide/2,...
%                                          numberOfBodies ) ) );
%                     % if it's blocked, find the APs behind 
%                     % and set as blocked
%                     if blockageTrialsCorr(i)
%                         behind_i = [];
%                         closeAngle = [];
%                         aux_i = [];
%                         closeAngle_i = find( ...
%                             abs( angleToAp(i)-angleToAp ) < pi/180 );
%                         aux_i = find( ...
%                             distance2d(closeAngle_i) > distance2d(i) );
%                         behind_i = closeAngle_i(aux_i);
%                         blockageTrialsCorr( behind_i ) = or( ...
%                             blockageTrialsCorr( behind_i ) , 1);
%                     end
%                 end
                
                % APs are blocked independently
                blockageTrialsIndy = binornd(...
                    1,...
                    P_ApBlocked( distance2d,...
                                 distanceToTopHead,...
                                 apHeight,...
                                 distanceToBody,...
                                 bodyWide,...
                                 areaSide/2,...
                                 numberOfBodies ),...
                    1, length(rxPower) );
                
                bodyAttenuationIndy = 1 - blockageTrialsIndy + ...
                	blockageTrialsIndy .* bodyAttenuation_vector(1);
%                 bodyAttenuationCorr = 1 - blockageTrialsCorr + ...
%                 	blockageTrialsCorr .* bodyAttenuation_vector(1);
                
                rxPower = rxPower .* bodyAttenuationIndy;
                
                % CELL ASSOCIATION
                % Get the highest rx power
                [ max_rxPower, servingAP_id ] = max( rxPower );

                % INTERFERENCE
                interfPower = rxPower;
                % turn off idle APs
%                             interfPower = interfPower .* onOffApVector;
                % serving AP is not interferer
                interfPower( servingAP_id ) = 0;

                % RECEIVED SINR
                sinr = rxPower( servingAP_id ) ./ ...
                    ( noisePower + sum( interfPower ) );

                sinr_vector( n_iter, bl_id, d_id ) = sinr;
                
            end % n_iter
        end % d_id
    end % bw_id
end % bl_id
%%
    