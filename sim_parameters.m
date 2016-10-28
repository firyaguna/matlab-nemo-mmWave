% PARAMETERS FOR nemo_sim.m

% TOPOLOGY
areaSide = 100;
numberOfIterations = 8000;
apHeight_vector = 1:9;

% USER BODY PARAMETERS
bodyAttenuation_vector = db2pow( [-inf -40 -20 0] ); % infinite, some, and no attenuation
bodyWide = 0.3;
distanceToBody = 0.3;
distanceToTopHead = 0.4;

% POWER
txPower = db2pow( 30 ); % 1 W
sinrThreshold = db2pow( 19 );
inrThreshold = db2pow( -10 );
bandWidth = 100;    % MHz
frequency = 60;     % GHz
noiseFig = 9;       % dB
noisePower = db2pow( -174 + noiseFig + 10*log10( bandWidth*1e6 ) );

% DIRECTIVITY GAIN
mainLobeGainTx = db2pow( 20 );	% main lobe gain
sideLobeGainTx = db2pow( -20 );	% side lobe gain
beamWidth_vector = deg2rad( [30 90 150] );
mainLobeGainRx = db2pow( 10 );  % main lobe gain
sideLobeGainRx = db2pow( -10 ); % side lobe gain

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