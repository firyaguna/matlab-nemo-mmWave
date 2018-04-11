function [ mean_thpt, fair ] = out_ComputeFairness( ...
                                        sinr_vector, ...
                                        bandWidth)
% SINR from hand and pocket scenario
    s = sinr_vector;
% Spectral Efficiency
    n_se = log2( 1 + s );
% Average UE Throughput
    thpt = n_se .* bandWidth*10e6; % throughput bps
    mean_thpt = squeeze(mean( thpt ));
% Jain's Fairness Index
    fair = sum( thpt ).^2 ./ (length(thpt) .* sum( thpt.^2 ));
    fair = squeeze(fair);