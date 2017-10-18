% FUNCTIONS FOR SYSTEM MODELING

% PATH LOSS MODEL
PL_LOS = @(d) (4*pi*frequency*1e9/3e8)^-2 .* d .^ ( - n_L );

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
