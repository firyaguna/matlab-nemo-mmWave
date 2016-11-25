% PARAMETERS FOR nemo_sim.m

debug = 1;

% TOPOLOGY
areaSide = 100;
apDensity = 100/(100*100); % AP/hm2
numberOfIterations = 500;
apHeight_vector = 2; % height above UE plane

% PLACE USER EQUIPMENT
uePosition_vector_0 = [ 0, ...        % circle
                      .1, ...       % elipse
                      .2, .4, .99 ];  % hiperbola
uePosition_vector = [ uePosition_vector_0 uePosition_vector_0(2:end).*exp(1i*deg2rad(30)) ];

% USER BODY PARAMETERS
bodyAttenuation_vector = db2pow( [-40 0] ); % infinite, some, and no attenuation
bodyWide = 0.3;
distanceToBody = 0.3;
distanceToTopHead = 0.4;

% POWER
txPower = db2pow( 0 ); %dBm to power
bandWidth = 100;    % MHz
frequency = 60;     % GHz
noiseFig = 9;       % dB
noisePower = db2pow( -174 + noiseFig + 10*log10( bandWidth*1e6 ) );

% DIRECTIVITY GAIN
beamWidth_vector = deg2rad( [30 60 90 120 135 150 165] );
beamWidthRx = deg2rad( 30 );
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