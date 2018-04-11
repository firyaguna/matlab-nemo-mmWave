% FUNCTIONS FOR SYSTEM MODELING

%% ANALYTICAL BODY BLOCKAGE FUNCTIONS
% Blocking angle
phi = @(b,w) 2.*atan(((2.*b)./w).^-1);
inv_phi = @(p,w) w./(2.*tan(p/2));

% AP BLOCKED BY SELF-BODY PROBABILITY
P_SelfBlock = @(d,w) phi(d,w)./(2*pi);

%% AP BLOCKED PROBABILITY
P_ApBlocked = @(d,t,h,dtb,w,a,Nb) ...
    1 - (1-P_RandomBlock(d,t,h,w,a)).^Nb + ...
            (1-P_RandomBlock(d,t,h,w,a)).^Nb .* ...
            P_SelfBlock(dtb,w) .* ...
            (1 - heaviside(dtb-d.*t./h));
        
%% AP BLOCKED PROBABILITY 2
P_ApBlocked = @(d,t,h,dtb,w,a,Nb) ...
    1 - (1-P_RandomBlock(d,t,h,w,a)).^Nb + ...
            (1-P_RandomBlock(d,t,h,w,a)).^Nb .* ...
            P_RandomSelfBlock(d,t,h,w,a,dtb);

%% ANTENNA GAIN MODEL
Antenna_Gain = @(illuminated,m,M) illuminated.*M + (1-illuminated).*m;

%% CHANNEL GAIN MODEL
% PATH LOSS MODEL
channel.PL = @(d,p0_dB,n) db2pow( -p0_dB ) .* d .^( -n );

if strcmp(channel.model,'yoo2017measurements_office')
% SHADOWING FADING MODEL - signal envelope
channel.SHADOWING_FADING = cell(2);
for i=1:2 % [LOS;NLOS]
    for j=1:2 % [pocket,hand]
        channel.SHADOWING_FADING{i,j} = makedist('Gamma','a',channel.a(i,j),'b',channel.b(i,j));
    end
end
channel.SHADOWING_FADING_POWER_GAIN = @(los,d2b,size) ...
    random( channel.SHADOWING_FADING{los,d2b}, size ).^2;
end

if ~strcmp(channel.model,'nofading')
% SMALL-SCALE FADING MODEL - signal envelope
channel.SMALL_FADING = cell(2);
for i=1:2 % [LOS;NLOS]
    for j=1:2 % [pocket,hand]
        channel.SMALL_FADING{i,j} = makedist('Nakagami','mu',channel.m(i,j),'omega',channel.o(i,j));
    end
end
channel.SMALL_FADING_POWER_GAIN = @(los,d2b,size) ...
    random( channel.SMALL_FADING{los,d2b}, size ).^2;
end

if strcmp(channel.model,'userOrientedFading_2')
% FADING GAIN DUMMY MODEL
channel.FADING_REFLECTED = makedist('Nakagami','mu',channel.mu_R,'omega',channel.om);
channel.FADING_SCATTERED = makedist('Nakagami','mu',channel.mu_S,'omega',channel.om);
channel.FADING_DIRECT = makedist('Nakagami','mu',channel.mu_D,'omega',channel.om);
end

