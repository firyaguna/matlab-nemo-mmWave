% NEMO DOWNLINK SIMULATION SCRIPT
%   (c) CONNECT Centre, 2016
%   Trinity College Dublin
%
%   This script simulates a set of mmW-APs placed in a hexagonal grid where
%   the user equipment (UE) is placed in the origin of the plane. The APs
%   are deployed in the ceiling 'apHeight' meters above the UE, and they
%   are transmitting a fixed directional beam pointed to the floor. The UE
%   is attached to the AP which is the closest one above.
%
%
%   Author: Fadhil Firyaguna
%           Phd Student Researcher

clear;

%% PARAMETERS
sim_parameters;

%% INITIALIZE VECTORS
sinr_vector = zeros( 1, numberOfIterations );
spectralEff_vector = zeros( 1, numberOfIterations );
inr_vector = zeros( 1, numberOfIterations );
selfBodyBlock = zeros( 1, numberOfIterations );

halfPercentile_sinr = zeros( length( beamWidth_vector ), ...
                       length( apHeight_vector ),...
                       length( bodyAttenuation_vector ) );
avg_spectralEff = zeros( length( beamWidth_vector ), ...
                       length( apHeight_vector ),...
                       length( bodyAttenuation_vector ) );
lobeEdge_matrix = zeros( length( beamWidth_vector ), ...
                       length( apHeight_vector ) );
rate_selfBodyBlock = zeros( length( beamWidth_vector ), ...
                       length( apHeight_vector ) );

%% SCENARIO

% GENERATE TOPOLOGY
[ apPosition, cellRadius ] = HexagonCellGrid( areaSide, apDensity );
    
% PATH LOSS MODEL
switch( pathLossModel )
    case 'belfast'
    PL_LOS = @(d) db2pow( - P_0_dB_L ) .* d .^ ( - n_L );
    PL_NLOS = @(d) db2pow( - P_0_dB_NL ) .* d .^ ( - n_NL );
    case 'abg'
    PL_LOS = @(d) db2pow( - P_0_dB_L ) .* d .^ ( - n_L ) ...
        .* frequency .^ ( - gamma_L );
    PL_NLOS = @(d) db2pow( - P_0_dB_NL ) .* d .^ ( - n_NL ) ...
        .* frequency .^ ( - gamma_NL );
    case { 'ci','generic' }
    PL_LOS = @(d) (4*pi*frequency*1e9/3e8)^2 .* d .^ ( - n_L );
    PL_NLOS = @(d) (4*pi*frequency*1e9/3e8)^2 .* d .^ ( - n_NL );
end
        
% SELF-BODY BLOCKAGE
bodyBlock_angle = 2 * atan( bodyWide / distanceToBody );
prob_selfBodyBlockage = bodyBlock_angle / (2*pi);

%% ITERATIONS
tic
currentProgress = 0;

for h_id = 1:length( uePosition_vector )

    apHeight = apHeight_vector( 1 );

    % SELF-BODY BLOCKAGE
    % Define the minimum critical distance where signal may start to be
    % blocked by the top of user's head
    bodyBlockDistance = apHeight * distanceToBody / distanceToTopHead;

    % PLACE USER EQUIPMENT
    uePosition = uePosition_vector( h_id );
    % Place UE in origin and shift cell positions
    apPosition_temp = apPosition + uePosition * cellRadius;
    % Get 2-D distance from AP to UE
    distance2d = abs( apPosition_temp );
    % Get angle of arrival from AP to UE
    angles = angle( apPosition_temp );
            
    for ba_id = 1:length( bodyAttenuation_vector )
    
        bodyAttenuation = bodyAttenuation_vector( ba_id );

        for bw_id = 1:length( beamWidth_vector )

            % CELL PROPERTIES
            beamWidthTx = beamWidth_vector( bw_id );
            mainLobeGainTx = MainLobeGain( beamWidthTx, sideLobeGainTx );
            mainLobeEdgeTx = apHeight * tan( beamWidthTx / 2 );
            lobeEdge_matrix( bw_id, h_id ) = mainLobeEdgeTx;
            
            % Get 3-D distance from AP to UE
            distance3d = sqrt( distance2d.^2 + apHeight^2 ); 
            
            % LINE-OF-SIGHT MODEL
            % Every AP is LOS (no building or wall shadowing in indoor venue)
            
            % BEAM COVERAGE
            % Define which AP are covering the UE
            inCell_id = find( distance2d <= mainLobeEdgeTx );
            outCell_id = find( distance2d > mainLobeEdgeTx );

            for n_iter = 1:numberOfIterations


                % DOWNLINK RECEIVED POWER
                rxPower = txPower .* PL_LOS( distance3d );

                % CELL ASSOCIATION
                % Get the highest omnidirectional rx power
                [ max_rxPower, servingAP_id ] = max( rxPower );

                % SELF-BODY BLOCKAGE
                % Define body orientation
                bodyCenter_angle = -pi + 2*pi * rand(1); % angle of the body center
                angle0 = bodyCenter_angle - bodyBlock_angle /2;
                angle1 = bodyCenter_angle + bodyBlock_angle /2;
                rangeFlag = 0;
                if angle0 < -pi
                    angle0 = angle0 + 2*pi;
                    rangeFlag = 1;
                end
                if angle1 > pi
                    angle1 = angle1 - 2*pi;
                    rangeFlag = 1;
                end

                % Define which APs are blocked
                if rangeFlag
                    angleSet = ( angles <= angle1 ) | ( angles > angle0 );
                else
                    angleSet = ( angles <= angle1 ) & ( angles > angle0 );
                end
                bodyBlock_id = find( ...
                    ( distance2d >= bodyBlockDistance ) ... % the ones in the critical area
                    & angleSet ); % the ones whose signal arrives from the blocked angle interval
                

                % Apply body attenuation
                rxPower( bodyBlock_id ) = rxPower( bodyBlock_id ) * bodyAttenuation;

                % DIRECTIVITY GAIN
                % Define which APs are covered by the UE
                % Get 2-d distance from APs to serving AP
                distance2ap = abs( apPosition_temp - apPosition_temp(servingAP_id) );
                % Get angle from APs to serving AP
                angles2ap = angle( apPosition_temp - apPosition_temp(servingAP_id) );
                % Get angle from serving AP to UE
                angle2ap = angle(apPosition_temp(servingAP_id));
                % Rotate the topology according to UE angle
                Z = abs(apPosition_temp) .* exp( 1i*(angle(apPosition_temp)-angle2ap));
                apPosition_temp = Z;
                % Define conic elements
                a_alpha = atan( apHeight / distance2d( servingAP_id ) );
                semiLatusRectum = distance3d( servingAP_id ) * tan( beamWidthRx / 2 ); % mainLobeEdgeRx
                if (a_alpha > beamWidthRx/2) && ...
                   (a_alpha - beamWidthRx/2) > 1e-15 
                % the illuminated area is a elipse
                % when the ceiling plane cuts through all the beam cone
                    a_beta = pi - beamWidthRx/2 - a_alpha;
                    a_gama = pi - beamWidthRx - a_beta;
                    semiMajorAxis = .5 * distance3d( servingAP_id ) * ...
                        ( sin( beamWidthRx ) * sin( a_alpha ) )/...
                        ( sin( a_gama ) * sin( a_beta ) );
                    semiMinorAxis_sq = semiLatusRectum * semiMajorAxis;
                    focus = sqrt( semiMajorAxis^2 - semiMinorAxis_sq );
                    eccentricity = focus / semiMajorAxis;
                    % Define the elipse range function
                    ElipseRadius = @( t ) ( semiMajorAxis * ( 1 - eccentricity^2 ) ) ./...
                        ( 1 - eccentricity .* cos(t) );
                    % Compute distance from the elipse border to the serving AP
                    % and compare to the distance from the APs
                    inUeBeam_id = find( distance2ap <= ElipseRadius( angles2ap ) );
                    outUeBeam_id = find( distance2ap > ElipseRadius( angles2ap ) );

                else
                % the illuminated area is a hyperbola
                % when the ceiling plane and the UE height plane cut the beam
                % cone
                    eccentricity = sec( beamWidthRx/2 );
                    semiMajorAxis = distance2d( servingAP_id ) / eccentricity;
                    trueAnomalyLimit = acos( -1 / eccentricity );
                    % Define the hiperbola range function
                    HiperbolaRadius = @(t) -( semiMajorAxis * ( eccentricity^2 - 1 ) ) ./...
                        ( 1 + eccentricity .* cos(t) );
                    % Define the angles outside the hiperbolic
                    % true anomaly limits
                    outTrueLimit_id = [ find( angles2ap <= -trueAnomalyLimit ), ...
                                        find( angles2ap >= trueAnomalyLimit ) ];
                    hiperbolaRadius = HiperbolaRadius( angles2ap );
                    hiperbolaRadius( outTrueLimit_id ) = +inf;
                    % Compute distance from the hiperbola border to the serving AP
                    % and compare to the distance from the APs
                    inUeBeam_id = find( distance2ap <= hiperbolaRadius );
                    outUeBeam_id = find( distance2ap > hiperbolaRadius );
                end
                
                % Define gains according to spotlight coverage
                % UE outside AP spotlight
                rxPower( outCell_id ) = rxPower( outCell_id ) * sideLobeGainTx;
                % UE inside AP spotlight
                rxPower( inCell_id ) = rxPower( inCell_id ) * mainLobeGainTx;
                % AP inside UE beam
                rxPower( inUeBeam_id ) = rxPower( inUeBeam_id ) * mainLobeGainRx;
                % AP outside UE beam
                rxPower( outUeBeam_id ) = rxPower( outUeBeam_id ) * sideLobeGainRx;

                % INTERFERENCE
                interfPower = rxPower;
                interfPower( servingAP_id ) = 0;

                % RECEIVED SINR
                sinr = rxPower( servingAP_id ) ./ ...
                    ( noisePower + sum( interfPower ) );
                sinr_vector( n_iter ) = sinr;

                % SPECTRAL EFFICIENCY log2(1+SINR)
                spectralEff_vector( n_iter ) = log2( 1 + sinr );
                
                % SELF-BODY BLOCK RATE
                selfBodyBlock( n_iter ) = ~isempty( ...
                    find( bodyBlock_id == servingAP_id, 1 ) );

                % DISPLAY PROGRESS
                totalProgress = length( beamWidth_vector ) * ...
                                length( uePosition_vector ) * ...
                                length( bodyAttenuation_vector ) * ...
                                numberOfIterations;
                currentProgress = currentProgress + 1;
                loopProgress = 100 * currentProgress / totalProgress;
                if mod(loopProgress,5) == 0
                    disp(['Loop progress: ' num2str(loopProgress)  '%']);
                    toc
                end

            end % iterations end

            % AVERAGE SPECTRAL EFFICIENCY
            avg_spectralEff( bw_id, h_id, ba_id ) = mean( spectralEff_vector );

            % 5th PERCENTILE OF SINR
            %   the greatest SINR value of the lowest 5%
            halfPercentile_sinr( bw_id, h_id, ba_id ) = pow2db( prctile( sinr_vector, 50 ) );

            % SELF-BODY BLOCK RATE
            rate_selfBodyBlock( bw_id, h_id, ba_id ) = mean( selfBodyBlock );
            
        end % beamwidth end
                            
    end % bodyAttenuation end
                
end % apHeight end

%% OUTPUTS
outputName = 'nemo_sim_output_';
outputName = strcat( outputName, pathLossModel, '.mat' );

save( outputName,  ...
    'avg_spectralEff', ...
    'halfPercentile_sinr', ...
    'lobeEdge_matrix' );
%% PLOTS

plot_nemo_output;
% plot_nemo_topology;