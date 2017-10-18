% FUNCTIONS FOR SYSTEM MODELING

% PATH LOSS MODEL
PL = @(d,p0_dB,n) db2pow( -p0_dB ) .* d .^( -n );

% SHADOWING FADING MODEL - signal envelope
SHADOWING_FADING = cell(2);
for i=1:2 % [LOS;NLOS]
    for j=1:2 % [pocket,hand]
        SHADOWING_FADING{i,j} = makedist('Gamma','a',a(i,j),'b',b(i,j));
    end
end
SHADOWING_FADING_POWER_GAIN = @(los,d2b,size) ...
    random( SHADOWING_FADING{los,d2b}, size ).^2;

% SMALL-SCALE FADING MODEL - signal envelope
SMALL_FADING = cell(2);
for i=1:2 % [LOS;NLOS]
    for j=1:2 % [pocket,hand]
        SMALL_FADING{i,j} = makedist('Nakagami','mu',m(i,j),'omega',o(i,j));
    end
end
SMALL_FADING_POWER_GAIN = @(los,d2b,size) ...
    random( SMALL_FADING{los,d2b}, size ).^2;

% TOTAL CHANNEL LOSS
CHANNEL_LOSS = @(d,blockedAps,d2b) ...
    (1-blockedAps) .* ( ... % line-of-sight
        PL( d, p0_dB(1,d2b), n(1,d2b) ) .* ...
        SHADOWING_FADING_POWER_GAIN( 1, d2b, size(d) ) .* ...
        SMALL_FADING_POWER_GAIN( 1, d2b, size(d) ) ) + ...
    blockedAps .* (... % non-line-of-sight
        PL( d, p0_dB(2,d2b), n(2,d2b) ) .* ...
        SHADOWING_FADING_POWER_GAIN( 2, d2b, size(d) ) .* ...
        SMALL_FADING_POWER_GAIN(  2, d2b, size(d) ) );

% ANTENNA GAIN MODEL
% ANT_GAIN = @(d,rm,m,M) m + (M-m).*heaviside(-d+rm); % d is the 2d distance
ANT_GAIN = @(illuminated,m,M) illuminated.*M + (1-illuminated).*m;

% FADING GAIN DUMMY MODEL 1
FADING_REFLECTED = makedist('Nakagami','mu',mu_R,'omega',om);
FADING_SCATTERED = makedist('Nakagami','mu',mu_S,'omega',om);
FADING_DIRECT = makedist('Nakagami','mu',mu_D,'omega',om);
FADING_BODY_GAIN = @(isReflected) ...
    isReflected .* random( FADING_REFLECTED, size(isReflected) ) + ...
    (1 - isReflected) .* random( FADING_DIRECT, size(isReflected) );
FADING_BODY_GAIN_3 = @(angles) ...
    (angles < pi/3) .* random( FADING_REFLECTED, size(angles) ) + ...
    (1 - angles < pi/3) .* ( ...
        (angles < 2*pi/3) .* random( FADING_SCATTERED, size(angles) ) + ...
        ( 1 - angles < 2*pi/3) .* random( FADING_DIRECT, size(angles) ) );
