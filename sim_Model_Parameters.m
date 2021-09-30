% PARAMETERS OF THE SYSTEM

% TOPOLOGY
sim.areaSide = 400; % meters
interSiteDistance_vector = 10.^((1:23)/10); % meters
numberOfIterations = 1000;
apHeight_vector = 10; % height above UE plane (meters)
ppm2 = [0 .1 .8]; % people per square meter
numberOfRandomBodies_vector = ceil(ppm2.*(sim.areaSide^2)); 

% USER BODY PARAMETERS
bodyAttenuation_vector = db2pow( -40 ); %dB
sim.bodyWide = 0.4; % meters
distanceToUserBody_vector = [ 0 .3 ]; % meters
sim.distanceToTopHead = 0.4; % meters

% POWER
sim.txPower = db2pow( 20 ); %dBm to power
bandWidth = 100;    % MHz
frequency = 60;     % GHz
noiseFig = 9;       % dB
sim.noisePower = db2pow( -174 + noiseFig + 10*log10( bandWidth*1e6 ) );

% DIRECTIVITY GAIN
beamWidth_vector = 2.*atan( .5 .* 10.^( (-1:22/36:23) / 10  ) ./ 10 ); % rad
beamWidthRx = deg2rad( 360 ); % rad
sim.sideLobeGainTx = db2pow( -10 ); % dBi

% PATH LOSS
sim.p0_dB = 68.011; % dB
sim.attenuationExponent = 2;

% FADING
sim.fadingModel.model = 'Rayleigh'; % Rayleigh or Nakagami
% Rayleigh fading parameter
sim.fadingModel.Exponential.mean = 1;
% Nakagami fading parameters
ktom = @(k) (k^2+2*k+1)/(2*k+1);
sim.fadingModel.Nakagami.m.LOS = [ ktom(5) ktom(3.5) ]; %[pocket,hand]
sim.fadingModel.Nakagami.m.NLOS = [ 2.43 2.27 ];