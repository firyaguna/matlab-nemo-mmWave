% SIM_PROBBLOCKAGE Monte-Carlo simulation of the probability of blockage
%   (c) CONNECT Centre, 2016-2018
%   Trinity College Dublin
%
%   Author: Fadhil Firyaguna
%           PhD Student Researcher

    % PLACE HUMAN BODY BLOCKERS
    humanBodies_temp = sim.areaSide/2 .* ...
        ( -1+2.*rand( 1, sim.numberOfHumanBlockages )...
        + -1i+2i.*rand( 1, sim.numberOfHumanBlockages ) );
    humanBodies_temp = humanBodies_temp - sim.areaSide/2 * uePosition;
    % Specify user body position
    userBodyAngle = -pi + 2*pi * rand(1); % angle of the user body center
    % User body is in a fixed distance from the UE device
    userBody = sim.distanceToUserBody * exp( 1i*userBodyAngle );
    % Put user body position in the beginning of vector
    humanBodies = [userBody, humanBodies_temp];
    % Get 2-D distance from UE to bodies
    distanceToBodies = abs( humanBodies );
    % Get angle from UE to bodies
    angleToBodies = angle( humanBodies );
    % Define the minimum critical distance where signal may
    % start to be blocked by the top of user's head
    bodyBlockDistances = sim.apHeight .* distanceToBodies ...
                        ./ sim.distanceToTopHead;
    % Compute blocking angle variation
    angleToBodiesVar = atan( (sim.bodyWide/2) ./ distanceToBodies );


    % SELF-BODY AND OTHER BODIES BLOCKAGE
    % Check if top head of bodies may be blocking APs
    checkMinDistance = ...
        repmat( sim.distance2d, length( bodyBlockDistances ), 1 ) > ...
        repmat( bodyBlockDistances', 1, length( sim.distance2d ) );
    % Check if bodies are in the same direction of APs
    checkDirection = abs( ...
        repmat( sim.angleToAp, length( angleToBodies ), 1 ) - ...
        repmat( angleToBodies', 1, length( sim.angleToAp ) ) ) < ...
        repmat( angleToBodiesVar', 1, length( sim.angleToAp ) );
    % Check how many bodies are blocking each AP
    numberOfBlockages = sum( ...
        checkDirection .* checkMinDistance, 1 );
    blockedAps = numberOfBlockages > 0;
    % Save data to histogram
    sim.blockageHist = [ sim.blockageHist(1,:) blockedAps; ... 
                     sim.blockageHist(2,:) sim.distance2d ];
