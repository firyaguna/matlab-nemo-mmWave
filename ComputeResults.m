function [ cov, ase ] = ComputeResults( sinr_vector, ...
                                        sinr_threshold, ...
                                        numberOfIterations, ...
                                        interSiteDistance_vector, ...
                                        beamWidth_vector )
    % INPUTS
    %   [ sinr_vector ] double
    %       size( numberOfIterations, 
    %                         length( interSiteDistance_vector ),
    %                         length( beamWidth_vector ) )
    %   [ sinr_threshold ] double 1x1
    %   [ numberOfIterations ] int 1x1
    %
    % OUTPUTS
    %   [ cov, ase ] double
    %       size( length( interSiteDistance_vector ),
    %             length( beamWidth_vector ) )
    
    s = sinr_vector;
    isd = interSiteDistance_vector;
    
    % Coverage
    cov = sum( s > sinr_threshold, 1 ) ./ numberOfIterations;
    cov = squeeze(cov);
    
    % Area Spectral Efficiency
    n_se = log2( 1 + s );
    avg_se = squeeze( mean( n_se, 1 ) );
    cellarea = repmat((2*sqrt(3).*(.5.*isd).^2),length(beamWidth_vector),1);
    ase = avg_se ./ cellarea;
end
