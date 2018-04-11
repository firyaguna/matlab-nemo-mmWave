function [ gain ] = model_FadingGain( m, v_size, nlos, hold )
%MODEL_FADINGGAIN Summary of this function goes here
%   Detailed explanation goes here

switch m.model
    case 'Rayleigh'
        % amplitude gain
        gain = random('exp', m.Exponential.mean, v_size); 
        % power gain
%         gain = gain.^2; 
    case 'Nakagami'
        % amplitude gain
        gain = nlos.*random( 'nakagami', m.Nakagami.m.NLOS(hold),1, v_size ) + ...
            (1-nlos).*random( 'nakagami', m.Nakagami.m.LOS(hold),1, v_size );
        % power gain
        gain = gain.^2; 
    otherwise
        gain = ones(v_size);
end

end

