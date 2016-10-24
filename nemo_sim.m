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
spectralEff = zeros( 1, numberOfIterations );
inr_vector = zeros( 1, numberOfIterations );

coverage_sinr = zeros( 1, length( beamWidth_vector ) );
avg_spectralEff = zeros( 1, length( beamWidth_vector ) );
limitation_inr = zeros( 1, length( beamWidth_vector ) );
apDensity = zeros( 1, length( beamWidth_vector ) );

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
    PL_LOS = @(d) (4*pi*frequency*1e9/3e8)^2 .* d .^ ( - n_L );
    PL_NLOS = @(d) (4*pi*frequency*1e9/3e8)^2 .* d .^ ( - n_NL );
end

% DIRECTIVITY GAIN
dirGain = [ mainLobeGainRx * mainLobeGainTx ... serving AP gain
            sideLobeGainRx * mainLobeGainTx ... neighbor AP gain
            sideLobeGainRx * sideLobeGainTx ... other AP gain
            ];
        
% SELF-BODY BLOCKAGE
bodyBlockDistance = apHeight * distanceToBody / distanceToTopHead;
bodyBlock_angle = 2 * atan( bodyWide / distanceToBody );
prob_selfBodyBlockage = bodyBlock_angle / (2*pi);

%% ITERATIONS
tic
currentProgress = 0;

for bw_id = 1:length( beamWidth_vector )
        
    % CELL PROPERTIES
    beamWidth = beamWidth_vector( bw_id );
    cellRadius = apHeight * tan( beamWidth/2 );
    
    % GENERATE TOPOLOGY
    [ apPosition, numOfPoints ] = HexagonCellGrid( areaSide, cellRadius );
    apDensity( bw_id ) = numOfPoints;
    
for n_iter = 1:numberOfIterations
     
    % PLACE USER EQUIPMENT
    % Random UE position within the cell
    uePosition = cellRadius * ( -1+2*rand(1) + -1i+2i*rand(1) );
    % Place UE in origin and shift cell positions
    apPosition = apPosition + uePosition;
    % Get 2-D distance from AP to UE
    distance2d = abs( apPosition );
    % Get 3-D distance from AP to UE
    distance3d = sqrt( abs( apPosition ).^2 + apHeight^2 );
    % Get angle of arrival from AP to UE
    angles = angle( apPosition );
    
    % LINE-OF-SIGHT MODEL
    % Every AP is LOS (no building or wall shadowing in indoor venue)
    % Define which AP are covering the UE
    inCell_id = find( distance2d <= cellRadius );
    outCell_id = find( distance2d > cellRadius );
    
    % DOWNLINK RECEIVED POWER
    rxPower = txPower .* PL_LOS( distance3d );
%     rxPower = zeros( 1, numOfPoints );
%     rxPower( LOS_id ) = txPower .* PL_LOS( distance( LOS_id ) );
%     rxPower( NLOS_id ) = txPower .* PL_LOS( distance( NLOS_id ) );
    
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
%     plot_nemo_topology;

    % Apply body attenuation
    rxPower( bodyBlock_id ) = rxPower( bodyBlock_id ) * bodyAttenuation;
        
    % DIRECTIVITY GAIN
    % Apply minimum directivity gain to non-neighbor APs
    rxPower( outCell_id ) = rxPower( outCell_id ) * dirGain(3);
    % Apply intermediate directivity gain to neighbor APs
    rxPower( inCell_id ) = rxPower( inCell_id ) * dirGain(2);
    % Apply maximum directivity gain to associated AP
    % Assume associated AP signal does not suffer body attenuation
    rxPower( servingAP_id ) = max_rxPower * dirGain(1);
    
    % INTERFERENCE
    interfPower = rxPower;
    interfPower( servingAP_id ) = 0;
    
    % RECEIVED SINR
    sinr = rxPower( servingAP_id ) ./ ...
        ( noisePower + sum( interfPower ) );
    sinr_vector( n_iter ) = sinr;
    
    % SPECTRAL EFFICIENCY log2(1+SINR)
    spectralEff( n_iter ) = log2( 1 + sinr );
    
    % INTERFERENCE-TO-NOISE RATIO
    inr_vector( n_iter ) = sum( interfPower ) / noisePower;
    
    % DISPLAY PROGRESS
    totalProgress = length( beamWidth_vector ) * numberOfIterations;
    currentProgress = currentProgress + 1;
    loopProgress = 100 * currentProgress / totalProgress;
    disp(['Loop progress: ' num2str(loopProgress)  '%']);
    toc
    
end

    % AVERAGE SPECTRAL EFFICIENCY
    avg_spectralEff( bw_id ) = mean( spectralEff );
    
    % COVERAGE RATE
    %   the rate that the received SINR is larger than some threshold
    coverage_sinr( bw_id ) = sum( sinr_vector > sinrThreshold ) / ...
        length( sinr_vector );
    
    % INTERFERENCE LIMITATION RATE
    %   the rate that the INR is larger than some threshold
    limitation_inr( bw_id ) = sum( inr_vector > inrThreshold ) / ...
        length( inr_vector );
    
    
end

%% OUTPUTS
outputName = 'nemo_sim_output_';
outputName = strcat( outputName, pathLossModel, '.mat' );

save( outputName,  ...
    'apDensity', ...
    'beamWidth_vector', ...
    'avg_spectralEff', ...
    'coverage_sinr', ...
    'limitation_inr', ...
    'inrThreshold', ...
    'sinrThreshold' );
%% PLOTS