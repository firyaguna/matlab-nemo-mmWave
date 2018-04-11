%% EXTRACT SINR DATA
sinr_cell = cell(2,2); %(ca,fading)
sinr_cell{1} = sinr_struct.maxPower;
sinr_cell{2} = sinr_struct.minDist;
sinr_cell{3} = sinr_struct.fading.maxPower;
sinr_cell{4} = sinr_struct.fading.minDist;

cov = cell(2,2);
peak_cov = cell(2,2);
peak_ase = cell(2,2);
ase = cell(2,2);
thpt = cell(2,2);
fair = cell(2,2);
peak_thpt = cell(2,2);
peak_fair = cell(2,2);

%% FIX ALL PARAMETERS
height_id = fixParam.height_id;
numBodies_id = fixParam.numBodies_id; % 1 = few bodies, 2 = many bodies
bodyAtt_id = fixParam.bodyAtt_id;
distanceToBody_id = fixParam.distanceToBody_id; % 1 = pocket, 2 = hand
sinrThreshold = fixParam.sinrThreshold; %dB

% COMPUTE COVERAGE AND SPECTRAL EFFICIENCY FROM SINR VECTOR
for i=1:4
    sinr_vector = sinr_cell{i};
    % set the SINR vector only as function of beamwidth and density
    s = squeeze( sinr_vector( ...
                    :, ... n_iter :::::::::::::::
                    :, ... beamwidth_id :::::::::
                    height_id, ... 
                    :, ... density_id :::::::::::
                    numBodies_id, ... 
                    bodyAtt_id, ... 
                    :  ... 
                ));
    % compute coverage and ASE as functions of beamwidth and density
    [ cov{i}, ase{i} ] = out_ComputeResults( ...
                   s(:,:,:,distanceToBody_id), ... % SINR vector
                   db2pow( sinrThreshold ), ... % SINR threshold in dB
                   numberOfIterations, ...
                   interSiteDistance_vector, ...
                   beamWidth_vector );
                               
    [ thpt{i}, fair{i} ] = out_ComputeFairness( ...
                            [s(:,:,:,1);s(:,:,:,2)], ...
                            bandWidth );
end

% COMPUTE COVERAGE PEAKS
for i=1:4
    z = cov{i};
    w = ase{i};
    [x,y] = meshgrid( 1:length(interSiteDistance_vector), ...
                      1:length(beamWidth_vector) );
    % Find Regional Maxima of Coverage higher than 0.2
    rm = imhmax(z,0.2,4);
    % Find the respective inter-site distance
    [ix] = find( rm );
    % [isd_id bw_id cov ase]
    conf = [x(ix),y(ix),z(ix),w(ix)];
    % Find optimal beamwidth for each inter-site distance
    opt = zeros(0,4);
    prev_m1 = 0;
    for isd_id = 1:length(interSiteDistance_vector)
        % get values of all beamwidths for each isd
        m = conf(conf(:,1)== isd_id,3);
        % get maximum value of coverage
        maxm = max(m);
        % get lower beamwidth for a margin below the maximum
        m1 = find( m > maxm-maxm*0.012 , 1 );
        if (~isempty(m))
            if m1 > prev_m1
                i2 = find( conf(:,1) == isd_id & conf(:,2) == m1 );
                opt = [ opt; conf(i2,:) ];
            end
            prev_m1 = m1;
        end
    end
    peak_cov{i} = opt;
    
    % Find maximum ASE
%     [mcov,ic] = max(z);
%     opt = zeros(0,4);
    [mase,ia] = max(w);
    opt2 = zeros(0,4);
    for isd_id = 1:length(interSiteDistance_vector)
%         opt = [ opt;...
%             isd_id, ic(isd_id), mcov(isd_id), w(ic(isd_id),isd_id)];
        opt2 = [ opt2;...
            isd_id, ia(isd_id), z(ia(isd_id),isd_id), mase(isd_id)];
    end
%     peak_cov{i} = opt;
    peak_ase{i} = opt2;
    
    
    % COMPUTE FAIRNESS/THROUGHPUT PEAKS
    tpk = zeros(1,length(peak_cov{i}));
    fpk = zeros(1,length(peak_cov{i}));
    for j = 1:length(peak_cov{i})
        tpk(j) = thpt{i}(peak_cov{i}(j,2),peak_cov{i}(j,1));
        fpk(j) = fair{i}(peak_cov{i}(j,2),peak_cov{i}(j,1));
    end
        peak_thpt{i} = tpk;
        peak_fair{i} = fpk;
end

