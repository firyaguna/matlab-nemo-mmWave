% PARAMETERS FOR nemo_sim.m

% TOPOLOGY
areaSide = 500;
apDensity = 300/(1000*1000); % 100 AP/km2
numberOfIterations = 1000;
apHeight_vector = [1 3 5];

% PLACE USER EQUIPMENT
% Random UE position
% uePosition = ( -1+2*rand(1) + -1i+2i*rand(1) );
% UE on cell center
% uePosition = 0;
% UE on 3 cells edges
% uePosition = 1;
% UE on 2 cells edges
uePosition = .5 + 1i;

% USER BODY PARAMETERS
bodyAttenuation_vector = db2pow( [-inf -3 0] ); % infinite, some, and no attenuation
bodyWide = 0.3;
distanceToBody = 0.3;
distanceToTopHead = 0.4;

% POWER
txPower = db2pow( 10 );
sinrThreshold = db2pow( 0 );
inrThreshold = db2pow( -10 );
bandWidth = 100;    % MHz
frequency = 60;     % GHz
noiseFig = 9;       % dB
noisePower = db2pow( -174 + noiseFig + 10*log10( bandWidth*1e6 ) );

% DIRECTIVITY GAIN
beamWidth_vector = deg2rad( [30 90 120 150] );
sideLobeGainTx = db2pow( -10 );
sideLobeGainRx = db2pow( -10 );
MainLobeGain = @(beamWidth,sideLobe) (2-sideLobe.*(1+cos(beamWidth./2))) ... 
                                        ./(1-cos(beamWidth./2));
mainLobeGainRx = MainLobeGain( deg2rad(90), sideLobeGainRx );

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