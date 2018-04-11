% NEMO DOWNLINK ANALYTICAL SCRIPT
%   (c) CONNECT Centre, 2018
%   Trinity College Dublin
%
%   This script simulates the body blockage of a set of mmW-APs placed in a
%   hexagonal grid where the user equipment (UE) is placed uniformly over 
%   the plane. The APs are deployed in the ceiling 'apHeight' meters above
%   the UE, and they are transmitting a fixed directional beam pointed to
%   the floor.
%   
%
%   Author: Fadhil Firyaguna
%           PhD Student Researcher

%% PARAMETERS
sim_Model_Parameters;
sim_Model_Functions;

%% INITIALIZE VECTORS
sinr_vector = zeros( numberOfIterations, ...
                       length( beamWidth_vector ), ...
                       length( apHeight_vector ), ...
                       length( interSiteDistance_vector ), ...
                       length( numberOfRandomBodies_vector ), ...
                       length( bodyAttenuation_vector ), ...
                       length( distanceToUserBody_vector ) );
sinr_struct.maxPower = sinr_vector;
sinr_struct.minDist = sinr_vector;
sinr_struct.fading.maxPower = sinr_vector;
sinr_struct.fading.minDist = sinr_vector;

lobeEdge_matrix = zeros( length( beamWidth_vector ), ...
                       length( apHeight_vector ) );
numberOfAps_vector = zeros( size( interSiteDistance_vector ) );
blockageRelFreq = cell(2,3);

%% ITERATIONS - CALCULATE SINR
tstart = tic;
currentProgress = 0;

for distanceToBody_id = 1:length( distanceToUserBody_vector )
    
    sim.distanceToUserBody = distanceToUserBody_vector( distanceToBody_id );
    
    for bodyAtt_id = 1:length( bodyAttenuation_vector )
                   
        sim.bodyAttenuation = bodyAttenuation_vector( bodyAtt_id );

        for numBodies_id = 1:length( numberOfRandomBodies_vector )

            sim.numberOfHumanBlockages = numberOfRandomBodies_vector( numBodies_id );

            for height_id = 1:length( apHeight_vector )

                sim.apHeight = apHeight_vector( height_id );

                for beamwidth_id = 1:length( beamWidth_vector )

                    % CELL PROPERTIES
                    beamWidthTx = beamWidth_vector( beamwidth_id );
                    sim.mainLobeGainTx = MainLobeGain( beamWidthTx, sim.sideLobeGainTx );
                    sim.mainLobeEdgeTx = sim.apHeight * tan( beamWidthTx / 2 );
                    lobeEdge_matrix( beamwidth_id, height_id ) = sim.mainLobeEdgeTx;

                    for density_id = 1:length( interSiteDistance_vector )

                        % GENERATE TOPOLOGY
                        apPosition = 0;

                        sim.blockageHist = zeros(2,0);
                        
                                                
                        for n_iter = 1:numberOfIterations
                            % PLACE USER EQUIPMENT
                            for uePosition = 1 : 20: sim.areaSide/2;
                            % Place UE in origin and shift cell positions
                            apPosition_temp = apPosition - uePosition;
                            % Get 2-D distance from AP to UE
                            sim.distance2d = abs( apPosition_temp );
                            % Get angle of arrival from AP to UE
                            sim.angleToAp = angle( apPosition_temp );
                            % Get 3-D distance from AP to UE
                            sim.distance3d = sqrt( sim.distance2d.^2 + sim.apHeight^2 );
                            
                            % COMPUTE PROBABILITY OF BLOCKAGE
                            sim_ProbBlockage;
                            end
                            

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
                        end % n_iter
                        
                        [bh,i] = sort(sim.blockageHist,2);
                        bh(1,:) = sim.blockageHist(1,i(2,:));
%%
                        prob = zeros(0,2);
                        for s = 1 :20: sim.areaSide/2;
%                             inter = intersect( find(bh(2,:)>s-1), find(bh(2,:)<s) );
%                             p = sum(bh(1,inter))./length(inter);
                        %     d = bh(2,s);
                        inter = bh(2,:) == s;
                        p = sum( bh(1,inter) )./numberOfIterations;
                            prob = [ prob(:,1) prob(:,2); ...
                                        p        s      ];
                        end
%%                        

                    end % density_id
                end % beamwidth_id
            end % height_id
            
            blockageRelFreq{distanceToBody_id, numBodies_id} = prob;
            
        end % numBodies_id
    end % bodyAtt_id
end % distanceToBody_id
toc(tstart);