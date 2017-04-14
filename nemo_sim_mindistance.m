% NEMO DOWNLINK SIMULATION SCRIPT
%   (c) CONNECT Centre, 2016-2017
%   Trinity College Dublin
%
%   This script simulates a set of mmW-APs placed in a hexagonal grid where
%   the user equipment (UE) is placed in the origin of the plane. The APs
%   are deployed in the ceiling 'apHeight' meters above the UE, and they
%   are transmitting a fixed directional beam pointed to the floor.
%   
%   The UE is associated with the AP that provides with a downlink signal
%   according to the shortest 3D Euclidean distance (minimum distance
%   association).
%
%
%   Author: Fadhil Firyaguna
%           PhD Student Researcher

clear;

%% PARAMETERS
sim_parameters;

%% INITIALIZE VECTORS
sinr_vector = zeros( numberOfIterations, ...
                       length( beamWidth_vector ), ...
                       length( apHeight_vector ), ...
                       length( interSiteDistance_vector ), ...
                       length( blockageDensity_vector ), ...
                       length( bodyAttenuation_vector ), ...
                       length( distanceToUserBody_vector ) );
spectralEff_vector = zeros( 1, numberOfIterations );
avg_spectralEff = zeros( length( beamWidth_vector ), ...
                       length( apHeight_vector ), ...
                       length( interSiteDistance_vector ), ...
                       length( blockageDensity_vector ), ...
                       length( bodyAttenuation_vector ), ...
                       length( distanceToUserBody_vector ) );
lobeEdge_matrix = zeros( length( beamWidth_vector ), ...
                       length( apHeight_vector ) );
numberOfAps_vector = zeros( size( interSiteDistance_vector ) );

%% SCENARIO

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
    PL_LOS = @(d) (4*pi*frequency*1e9/3e8)^-2 .* d .^ ( - n_L );
    PL_NLOS = @(d) (4*pi*frequency*1e9/3e8)^-2 .* d .^ ( - n_NL );
end

%% ITERATIONS
tstart = tic;
currentProgress = 0;


for db_id = 1:length( distanceToUserBody_vector )
    
    distanceToUserBody = distanceToUserBody_vector( db_id );
    
    for ba_id = 1:length( bodyAttenuation_vector )
                    
        bodyAttenuation = bodyAttenuation_vector( ba_id );

        for bl_id = 1:length( blockageDensity_vector )

            numberOfHumanBlockages = blockageDensity_vector( bl_id );

            for h_id = 1:length( apHeight_vector )

                apHeight = apHeight_vector( h_id );

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

                        for n_iter = 1:numberOfIterations

                            % PLACE USER EQUIPMENT
                            ueInCell = 0;
                            while( ~ueInCell )
                                % Generate random position
                                uePosition = ( -1+2*rand(1) + -1i+2i*rand(1) );
                                xq = real( uePosition );
                                yq = imag( uePosition );
                                % Define hexagon cell limits
                                L = linspace(0,2.*pi,7);
                                xv = cos(L)';
                                yv = sin(L)';
                                % Check if random position is inside hexagon
                                ueInCell = inpolygon(xq,yq,xv,yv);
                            end
                            % Place UE in origin and shift cell positions
                            apPosition_temp = apPosition + cellRadius * uePosition;
                            % Get 2-D distance from AP to UE
                            distance2d = abs( apPosition_temp );
                            % Get angle of arrival from AP to UE
                            angleToAp = angle( apPosition_temp );
                            % Get 3-D distance from AP to UE
                            distance3d = sqrt( distance2d.^2 + apHeight^2 );

                            % BEAM COVERAGE
                            % Define which AP are covering the UE
                            inCell_id = find( distance2d <= mainLobeEdgeTx );
                            outCell_id = find( distance2d > mainLobeEdgeTx );

                            % PLACE HUMAN BODY BLOCKERS
                            humanBodies_temp = areaSide .* ...
                                ( -1+2.*rand( 1, numberOfHumanBlockages )...
                                + -1i+2i.*rand( 1, numberOfHumanBlockages ) );
                            % Specify user body position
                            userBodyAngle = -pi + 2*pi * rand(1); % angle of the user body center
                            % User body is in a specific distance from the UE device
                            userBody = distanceToUserBody * exp( 1i*userBodyAngle );
                            % Put user body position in the beginning of vector
                            humanBodies = [ userBody, humanBodies_temp ];
                            % Get 2-D distance from UE to bodies
                            distanceToBodies = abs( humanBodies );
                            % Get angle from UE to bodies
                            angleToBodies = angle( humanBodies );
                            % Define the minimum critical distance where signal may
                            % start to be blocked by the top of user's head
                            bodyBlockDistances = apHeight .* distanceToBodies ...
                                                ./ distanceToTopHead;
                            % Compute blocking angle variation
                            angleToBodiesVar = atan( (bodyWide/2) ./ distanceToBodies );

                            % DOWNLINK TRANSMIT POWER
                            % Transmit power per area is constant
                            rxPower = txPower;% / numberOfAps;

                            % DOWNLINK RECEIVE POWER
                            rxPower = rxPower .* PL_LOS( distance3d );

                            % CELL ASSOCIATION
                            % Get the highest omnidirectional rx power
                            [ max_rxPower, servingAP_id ] = max( rxPower );

                            % SELF-BODY AND OTHER BODIES BLOCKAGE
                            % Check if bodies are between APs and UE
                            checkDistance = ...
                                repmat( distance2d, length( distanceToBodies ), 1 ) > ...
                                repmat( distanceToBodies', 1, length( distance2d ) );
                            % Check if top head of bodies may be blocking APs
                            checkMinDistance = abs( ...
                                repmat( distance2d, length( bodyBlockDistances ), 1 ) - ...
                                repmat( distanceToBodies', 1, length( distance2d ) ) ) > ...
                                repmat( bodyBlockDistances', 1, length( distance2d ) );
                            % Check if bodies are in the same direction of APs
                            checkDirection = abs( ...
                                repmat( angleToAp, length( angleToBodies ), 1 ) - ...
                                repmat( angleToBodies', 1, length( angleToAp ) ) ) < ...
                                repmat( angleToBodiesVar', 1, length( angleToAp ) );
                            % Check how many bodies are blocking each AP
                            numberOfBlockages = sum( ...
                                checkDirection .* checkMinDistance .* checkDistance, 1 );
                            % Apply body attenuation
                            rxPower = rxPower .* bodyAttenuation .^ ( numberOfBlockages );

                            % DIRECTIVITY GAIN
                            % Define gains according to spotlight coverage
                            % UE outside AP spotlight
                            rxPower( outCell_id ) = rxPower( outCell_id ) * sideLobeGainTx;
                            % UE inside AP spotlight
                            rxPower( inCell_id ) = rxPower( inCell_id ) * mainLobeGainTx;

                            % CELL ASSOCIATION
                            % Get the highest rx power
%                            [ max_rxPower, servingAP_id ] = max( rxPower );

                            % INTERFERENCE
                            interfPower = rxPower;
                            interfPower( servingAP_id ) = 0;

                            % RECEIVED SINR
                            sinr = rxPower( servingAP_id ) ./ ...
                                ( noisePower + sum( interfPower ) );
                            sinr_vector( n_iter, bw_id, h_id, d_id, bl_id, ba_id, db_id ) = sinr;

                            % SPECTRAL EFFICIENCY log2(1+SINR)
                            spectralEff_vector( n_iter ) = log2( 1 + sinr );

                            % DISPLAY PROGRESS
                            totalProgress = length( beamWidth_vector ) * ...
                                            length( interSiteDistance_vector ) * ...
                                            length( apHeight_vector ) * ...
                                            length( blockageDensity_vector ) * ...
                                            length( bodyAttenuation_vector ) * ...
                                            length( distanceToUserBody_vector ) * ...
                                            numberOfIterations;
                            currentProgress = currentProgress + 1;
                            loopProgress = 100 * currentProgress / totalProgress;
                            if mod(loopProgress,2) == 0
                                clc
                                disp(['Loop progress: ' num2str(loopProgress)  '%']);
                                tnow = toc( tstart );
                                toc( tstart );
                                estimatedEnd = ( tnow * 100 / loopProgress ) - tnow;
                                disp(['Estimated end time is ' num2str(estimatedEnd) ' seconds.']);
                            end



                        end % iterations end

                        % AVERAGE SPECTRAL EFFICIENCY
                        avg_spectralEff( bw_id, h_id, d_id, bl_id, ba_id, db_id ) = ...
                            mean( spectralEff_vector );

                    end % apDensity end

                end % beamwidth end

            end % apHeight end

        end % blockageDensity end
        
    end % bodyAttenuation end
end % distanceToUserBody end

toc(tstart);

%% OUTPUTS
outputName = 'nemo/output/nemo_sim_mindistance_output';
save( strcat( outputName, '.mat' ) );
save( strcat( outputName, '_', datestr(now,'yyyymmddHHMM'), '.mat' ) );

%% PLOTS

% plot_nemo_output;
