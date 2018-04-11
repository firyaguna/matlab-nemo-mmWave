function [ sinr ] = sim_Downlink( sim )
%SIM_DOWNLINK received power chain simulation
%   (c) CONNECT Centre, 2018
%   Trinity College Dublin
%
%   This function computes each gain on the received power
%       - Transmit power
%       - Path loss
%       - Body attenuation
%       - Directivity gain
%       - Fading
%   It outputs the received power of 4 different scenarios:
%       - No fading / min. distance cell association
%       - No fading / max. received power cell association
%       - With fading / min. distance cell association
%       - With fading / max. received power cell association
%
%   Author: Fadhil Firyaguna
%           PhD Student Researcher


    % DOWNLINK TRANSMIT POWER
    % Transmit power per area is constant
    rxPower = sim.txPower;

    % PATH LOSS
    rxPower = rxPower .* sim.PathLoss( ...
                            sim.distance3d,...
                            sim.p0_dB,...
                            sim.attenuationExponent );

    % BODY ATTENUATION
    blockedAps = binornd(...
        1,...
        sim.ProbApBlocked( sim.distance2d,...
                     sim.distanceToTopHead,...
                     sim.apHeight,...
                     sim.distanceToUserBody,...
                     sim.bodyWide,...
                     sim.areaSide/2,...
                     sim.numberOfHumanBlockages ),...
        1, length(sim.distance2d) );
    rxPower = (1-blockedAps) .* rxPower ...
            + blockedAps .* rxPower .* sim.bodyAttenuation;
    
    % Save data to histogram
    sim.blockageHist = [ sim.blockageHist(1,:) sim.blockedAps; ... 
                     sim.blockageHist(2,:) sim.distance2d ];
    
    % DIRECTIVITY GAIN
    illuminated = sim.distance2d < sim.mainLobeEdgeTx;
    rxPower = rxPower .* sim.DirectivityGain( ...
                            illuminated,...
                            sim.sideLobeGainTx,...
                            sim.mainLobeGainTx );             
                        
    % SMALL-SCALE FADING
    rxPower_fading = rxPower .* sim.FadingGain( ...
                            sim.fadingModel,...
                            size(rxPower),...
                            blockedAps,...
                            1 + ( sim.distanceToUserBody > 0 ) );
                        
    % CELL ASSOCIATION
    % Get the highest rx power
    [ ~, servingAP_id_maxPower ] = max( rxPower );
    % Get the closest AP
    [ ~, servingAP_id_minDist ] = min( sim.distance2d );
    
    % ------------------- NO FADING -----------------------
    % INTERFERENCE
    interfPower_maxPower = rxPower;
    interfPower_minDist = rxPower;

    % serving AP is not interferer
    interfPower_maxPower( servingAP_id_maxPower ) = 0;
    interfPower_minDist( servingAP_id_minDist ) = 0;

    % RECEIVED SINR
    sinr.maxPower = rxPower( servingAP_id_maxPower ) ./ ...
        ( sim.noisePower + sum( interfPower_maxPower ) );
    sinr.minDist = sum( interfPower_minDist );%rxPower( servingAP_id_minDist ) ./ ...
%         ( sim.noisePower + sum( interfPower_minDist ) );
    
    % -------------------- WITH FADING ------------------------
    % INTERFERENCE
    interfPower_maxPower = rxPower_fading;
    interfPower_minDist = rxPower_fading;

    % serving AP is not interferer
    interfPower_maxPower( servingAP_id_maxPower ) = 0;
    interfPower_minDist( servingAP_id_minDist ) = 0;

    % RECEIVED SINR
    sinr.fading.maxPower = rxPower_fading( servingAP_id_maxPower ) ./ ...
        ( sim.noisePower + sum( interfPower_maxPower ) );
    sinr.fading.minDist = rxPower_fading( servingAP_id_minDist ) ./ ...
        ( sim.noisePower + sum( interfPower_minDist ) );

end

