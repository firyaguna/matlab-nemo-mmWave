% PARAMETERS OF THE SYSTEM

% TOPOLOGY
areaSide = 80; % meters
interSiteDistance_vector = 20; %10.^((3:1:23)/10); % meters
numberOfIterations = 10000;
apHeight_vector = 10; % height above UE plane (meters)
ppm2 = [.8]; % people per square meter
numberOfRandomBodies_vector = ceil(ppm2.*(areaSide^2)); %6*10.^(0:1:5); %[ 1 20 50 100 200 500 1000] - 1 ;

% USER BODY PARAMETERS
bodyAttenuation_vector = db2pow( -40 );
bodyWide = 0.4; % meters
distanceToUserBody_vector = [ .3 ]; %[ 0 .05 .15 .3 inf ]; % meters
distanceToTopHead = 0.4; % meters

% POWER
txPower = db2pow( 20 ); %dBm to power
bandWidth = 100;    % MHz
frequency = 60;     % GHz
noiseFig = 9;       % dB
noisePower = db2pow( -174 + noiseFig + 10*log10( bandWidth*1e6 ) );
cellAssociation = 'max_power'; % 'max_power' or 'min_dist'
rxPower_threshold = db2pow( -65 ); %dBm threshold for AP association

% DIRECTIVITY GAIN
beamWidth_vector = 2.*atan( .5 .* 10.^( (-1:22/36:29) / 10  ) ./ 10 );
beamWidthRx = deg2rad( 360 );
sideLobeGainTx = db2pow( -10 );
sideLobeGainRx = db2pow( -10 );
MainLobeGain = @(beamWidth,sideLobe) (2-sideLobe.*(1+cos(beamWidth./2))) ... 
                                        ./(1-cos(beamWidth./2));
mainLobeGainRx = MainLobeGain( beamWidthRx, sideLobeGainRx );


% CHANNEL LOSS
m_K = @(k) (k+1)^2/(2*k+1);
channel.model = 'nofading';
switch( channel.model )
    case 'yoo2017measurements_office'
        % PATH LOSS
        channel.n = [ 1.30, 1.51 ; ... %[LOS][ pocket, hand ]
              0.24, 1.25 ];    %[NLOS]
        channel.p0_dB = [ 48.6, 54.1 ; ...
                  67.3, 55.2 ];
        % SHADOWING FADING
        channel.a = [ 5.14, 9.34 ; ...
              16.37, 8.33 ];
        channel.b = [ 0.24, 0.12 ; ...
              0.07, 0.13 ];
        % SMALL-SCALE FADING
        channel.m = [ m_K(5), m_K(3.5) ; ...
              2.43, 2.27 ];
        channel.o = [ 1.0, 1.0; ...
               1.1, 1.1 ];
    case 'yoo2017fading_hallway'
        % Free-space
        channel.n = 2 .* ones(2); % attenuation exponent
        channel.p0_dB = 68.011 .* ones(2);
        % SMALL-SCALE FADING
        channel.m = [ m_K(3.02), 1.33 ; ...
              1.19, 1.38 ];
        channel.o = [ 1.31, 1.53; ...
               1.61, 1.50 ];
    case 'userOrientedFading_2'
        % Free-space
        channel.n = 2 .* ones(2); % attenuation exponent
        channel.p0_dB = 68.011 .* ones(2);
        % SMALL-SCALE FADING
        channel.mu_R = .8;
        channel.mu_S = 2;
        channel.mu_D = 3;
        channel.om = 1;
    otherwise
        % Free-space
        channel.n = 2 .* ones(2); % attenuation exponent
        channel.p0_dB = 68.011 .* ones(2);
end
