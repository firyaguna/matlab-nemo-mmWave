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
%   according to the strongest received signal power (maximum received
%   power association).
%
%
%   Author: Fadhil Firyaguna
%           PhD Student Researcher

clear;

%% PARAMETERS
sim_parameters;

function_models;

%% INITIALIZE VECTORS
sinr_vector = zeros( numberOfIterations, ...
                       length( beamWidth_vector ), ...
                       length( apHeight_vector ), ...
                       length( interSiteDistance_vector ), ...
                       length( numberOfRandomBodies_vector ), ...
                       length( bodyAttenuation_vector ), ...
                       length( distanceToUserBody_vector ) );
% numberOfBlockages_vector = zeros( numberOfIterations, ...
%                        23, ...
%                        length( beamWidth_vector ), ...
%                        length( apHeight_vector ), ...
%                        length( interSiteDistance_vector ), ...
%                        length( numberOfRandomBodies_vector ), ...
%                        length( bodyAttenuation_vector ), ...
%                        length( distanceToUserBody_vector ) );
% sinr2_vector = sinr_vector;
lobeEdge_matrix = zeros( length( beamWidth_vector ), ...
                       length( apHeight_vector ) );
numberOfAps_vector = zeros( size( interSiteDistance_vector ) );

%% ITERATIONS
tstart = tic;
currentProgress = 0;


for distanceToBody_id = 1:length( distanceToUserBody_vector )
    
    distanceToUserBody = distanceToUserBody_vector( distanceToBody_id );
    
    for bodyAtt_id = 1:length( bodyAttenuation_vector )
                   
        bodyAttenuation = bodyAttenuation_vector( bodyAtt_id );

        for numBodies_id = 1:length( numberOfRandomBodies_vector )

            numberOfHumanBlockages = numberOfRandomBodies_vector( numBodies_id );

            for height_id = 1:length( apHeight_vector )

                apHeight = apHeight_vector( height_id );

                for beamwidth_id = 1:length( beamWidth_vector )

                    % CELL PROPERTIES
                    beamWidthTx = beamWidth_vector( beamwidth_id );
                    mainLobeGainTx = MainLobeGain( beamWidthTx, sideLobeGainTx );
                    mainLobeEdgeTx = apHeight * tan( beamWidthTx / 2 );
                    lobeEdge_matrix( beamwidth_id, height_id ) = mainLobeEdgeTx;

                    for density_id = 1:length( interSiteDistance_vector )

                        % GENERATE TOPOLOGY
                        interSiteDistance = interSiteDistance_vector( density_id );
                        [ apPosition, numberOfAps ] = ...
                            HexagonCellGrid( areaSide, interSiteDistance );
                        numberOfAps_vector( density_id ) = numberOfAps;
                        cellRadius = interSiteDistance * sin( pi/6 ) / sin( 2*pi/3 );
                        
                        blockageHist = zeros(2,0);

                        for n_iter = 1:numberOfIterations

                            % PLACE USER EQUIPMENT
                            uePosition = ( -1+2*rand(1) + -1i+2i*rand(1) );
                            % Place UE in origin and shift cell positions
                            apPosition_temp = apPosition - areaSide/2 * uePosition;
                            % Get 2-D distance from AP to UE
                            distance2d = abs( apPosition_temp );
                            % Get angle of arrival from AP to UE
                            angleToAp = angle( apPosition_temp );
                            % Get 3-D distance from AP to UE
                            distance3d = sqrt( distance2d.^2 + apHeight^2 );


                            % PLACE HUMAN BODY BLOCKERS
                            humanBodies_temp = areaSide/2 .* ...
                                ( -1+2.*rand( 1, numberOfHumanBlockages )...
                                + -1i+2i.*rand( 1, numberOfHumanBlockages ) );
                            humanBodies_temp = humanBodies_temp - areaSide/2 * uePosition;
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
                            
                            % DEFINE ON/OFF APs
%                             distance2d_matrix = abs( ...
%                                 repmat( apPosition_temp, length( humanBodies_temp ), 1 ) - ...
%                                 repmat( humanBodies_temp.', 1, length( apPosition_temp ) ) ...
%                                 );
%                             distance3d_matrix = sqrt( distance2d_matrix.^2 + apHeight^2 );
%                             illuminated_matrix = distance2d_matrix < mainLobeEdgeTx;
%                             rxPower_matrix = txPower ...
%                                         .* PL_LOS( distance3d_matrix ) ...
%                                         .* ANT_GAIN( illuminated_matrix,...
%                                                      sideLobeGainTx,...
%                                                      mainLobeGainTx );
%                             aboveThresh_matrix = rxPower_matrix > rxPower_threshold;
%                             onOffAp_vector = sum(aboveThresh_matrix,1) > 0;
                            
                            % DOWNLINK TRANSMIT POWER
                            % Transmit power per area is constant
                            rxPower = txPower;% / numberOfAps;

                            % DOWNLINK RECEIVE POWER
                            rxPower = rxPower .* PL_LOS( distance3d );

%                             % CELL ASSOCIATION
%                             % Get the highest omnidirectional rx power
%                             [ max_rxPower, servingAP_id ] = max( rxPower );

                            % SELF-BODY AND OTHER BODIES BLOCKAGE
                            % Check if top head of bodies may be blocking APs
                            checkMinDistance = ...
                                repmat( distance2d, length( bodyBlockDistances ), 1 ) > ...
                                repmat( bodyBlockDistances', 1, length( distance2d ) );
                            % Check if bodies are in the same direction of APs
                            checkDirection = abs( ...
                                repmat( angleToAp, length( angleToBodies ), 1 ) - ...
                                repmat( angleToBodies', 1, length( angleToAp ) ) ) < ...
                                repmat( angleToBodiesVar', 1, length( angleToAp ) );
                            % Check how many bodies are blocking each AP
                            numberOfBlockages = sum( ...
                                checkDirection .* checkMinDistance, 1 );
                            % Save data to histogram
                            blockageHist = [ blockageHist(1,:) (numberOfBlockages > 0); ... 
                                             blockageHist(2,:)  distance2d ];
                            % Apply body attenuation
                            rxPower = rxPower .* bodyAttenuation .^ ( numberOfBlockages > 0 );
                            
                            % BODY EFFECT ON FADING GAIN
                            % Check if body orientation leads to body reflection
                            % Condition: any body fraction should be aligned 
                            % with both UE and AP
                            isReflected = abs( ...
                                repmat( angleToAp, length( userBodyAngle ), 1 ) - ...
                                repmat( userBodyAngle', 1, length( angleToAp ) ) ) < ...
                                repmat( angleToBodiesVar(1) + pi, 1, length( angleToAp ) );

                            rxPower = rxPower .* FADING_BODY_GAIN( isReflected );
                            
                            % DIRECTIVITY GAIN
                            % Define gains according to spotlight coverage
                            illuminated = distance2d < mainLobeEdgeTx;
                            rxPower = rxPower .* ANT_GAIN( illuminated,...
                                                        sideLobeGainTx,...
                                                        mainLobeGainTx );

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
%                             sinr2 = rxPower( servingAP_id ) ./ ...
%                                 ( noisePower + sum( interfPower.* onOffAp_vector ) );
                            
                            sinr_vector( n_iter,...
                                beamwidth_id,...
                                height_id,...
                                density_id,...
                                numBodies_id,...
                                bodyAtt_id,...
                                distanceToBody_id ) = sinr;
%                             numberOfBlockages_vector( n_iter, :, bw_id, h_id, d_id, bl_id, ba_id, db_id ) = ...
%                                 numberOfBlockages_vector( n_iter, :, bw_id, h_id, d_id, bl_id, ba_id, db_id ) ...
%                                 + (numberOfBlockages > 0);

                            % DISPLAY PROGRESS
                            totalProgress = length( beamWidth_vector ) * ...
                                            length( interSiteDistance_vector ) * ...
                                            length( apHeight_vector ) * ...
                                            length( numberOfRandomBodies_vector ) * ...
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
                                disp(['Estimated end in ' num2str(estimatedEnd) ' seconds.' ]);
                                hms = fix(mod(estimatedEnd, [0, 3600, 60]) ./ [3600, 60, 1]);
                                disp(['Estimated duration ' ...
                                    num2str(hms(1)) ':' num2str(hms(2)) ':' num2str(hms(3)) ]);
                            end


                        end % iterations end

                    end % apDensity end

                end % beamwidth end

            end % apHeight end

        end % blockageDensity end
                
    end % bodyAttenuation end
    
end % distanceToUserBody end

toc(tstart);

%% OUTPUTS
outputName = 'output/nemo_sim_maxpower_output';
save( strcat( outputName, '.mat' ) );
save( strcat( outputName, '_', datestr(now,'yyyymmddHHMM'), '.mat' ) );

%% PLOTS

% plot_nemo_output;
