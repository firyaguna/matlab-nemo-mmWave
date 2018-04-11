%% ANALYTICAL BODY BLOCKAGE FUNCTIONS
% Blocking angle
phi = @(b,w) 2.*atan(((2.*b)./w).^-1);
inv_phi = @(p,w) w./(2.*tan(p/2));

% AP BLOCKED BY SELF-BODY PROBABILITY
P_SelfBlock = @(d,w) phi(d,w)./(2*pi);

% AP BLOCKED BY ONE RANDOM BODY
P_RandomBlock = @(d,t,h,w,a) model_ProbBlockageByOneRandomBody(d,t,h,w,a);

% AP BLOCKED PROBABILITY
sim.ProbApBlocked = @(d,t,h,dtb,w,a,Nb) ...
    1 - (1-P_RandomBlock(d,t,h,w,a)).^Nb + ...
            (1-P_RandomBlock(d,t,h,w,a)).^Nb .* ...
            P_SelfBlock(dtb,w) .* ...
            (1 - heaviside(dtb-d.*t./h));
        
%% DIRECTIVITY GAIN MODEL

MainLobeGain = @(beamWidth,sideLobe) (2-sideLobe.*(1+cos(beamWidth./2))) ... 
                                        ./(1-cos(beamWidth./2));
sim.DirectivityGain = @(illuminated,m,M) illuminated.*M + (1-illuminated).*m;

%% PATH LOSS MODEL
sim.PathLoss = @(d,p0_dB,n) db2pow( -p0_dB ) .* d .^( -n );

%% FADING MODEL
sim.FadingGain = @(model,size,nlos,hold) ...
    model_FadingGain( model, size, nlos, hold );