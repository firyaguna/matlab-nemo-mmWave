% PARAMETERS FOR nemo_sim.m

% TOPOLOGY
areaSide = 100; % meters
interSiteDistance_vector = [ 1:13 15 17 20 21 26 29 34 51 58 ]; % meters
numberOfIterations = 10000;
apHeight_vector = 1:5 ; % height above UE plane (meters)
blockageDensity_vector = 1 - 1; %[100 200 500 1000] - 1 ;

% USER BODY PARAMETERS
bodyAttenuation_vector = db2pow(-40); %db2pow( [-40 0] );
bodyWide = 0.3; % meters
distanceToUserBody = 0.3; % meters
distanceToTopHead = 0.4; % meters

% POWER
txPower = db2pow( 20 ); %dBm to power
bandWidth = 100;    % MHz
frequency = 60;     % GHz
noiseFig = 9;       % dB
noisePower = db2pow( -174 + noiseFig + 10*log10( bandWidth*1e6 ) );
sinrThreshold_vector = db2pow( -20:5:20 );

% DIRECTIVITY GAIN
beamWidth_vector = deg2rad( [30 60 90 120 150] );
beamWidthRx = deg2rad( 360 );
sideLobeGainTx = db2pow( -10 );
sideLobeGainRx = db2pow( -10 );
MainLobeGain = @(beamWidth,sideLobe) (2-sideLobe.*(1+cos(beamWidth./2))) ... 
                                        ./(1-cos(beamWidth./2));
mainLobeGainRx = MainLobeGain( beamWidthRx, sideLobeGainRx );

% PATH LOSS
pathLossModel = 'generic';  
    % 'belfast' - empirical Belfast off-body CAR PARK measurements results
    % 'abg' - alpha-beta-gamma NYU urban micro open square
    % 'ci' - close-in NYU urban micro open square

switch( pathLossModel )
    case 'generic'
        n_L = 2.0;          % LOS attenuation exponent
        n_NL = 6.0;         % NLOS attenuation exponent
    case 'belfast'
        n_L = 1.7;          % LOS attenuation exponent
        n_NL = 1.9;         % NLOS attenuation exponent
        P_0_dB_L = 18.2;	% LOS path loss reference
        P_0_dB_NL = 58.0;	% NLOS path loss reference
    case 'abg'
        n_L = 2.6;          % LOS attenuation exponent
        n_NL = 4.4;         % NLOS attenuation exponent
        P_0_dB_L = 24;      % LOS path loss reference
        P_0_dB_NL = 2.4;	% NLOS path loss reference
        gamma_L = 1.6;      % LOS frequency attenuation exponent
        gamma_NL = 1.9;     % NLOS frequency attenuation exponent
    case 'ci'
        n_L = 1.9;          % LOS attenuation exponent
        n_NL = 2.8;         % NLOS attenuation exponent
end