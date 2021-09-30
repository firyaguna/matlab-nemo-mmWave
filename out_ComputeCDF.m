function [yCDF, xCDF] = out_ComputeCDF(x,xBins,xMaxConstraint)

% if nargin <= 2
%     [B,xCDF]=hist(x,xBins);
%     yCDF = cumsum(B)/sum(B);
% else
%     x = x(x<=xMaxConstraint);
%     [B,xCDF]=hist(x,xBins);
%     yCDF = cumsum(B)/sum(B);
% end

if nargin == 1
    xBins = 100;
end



a_sorted = sort(x);
l = length(x);
perc = zeros(1,xBins+1);
perc(1) = a_sorted(1);

for n = 1:xBins

    pos_aTarget = ceil(l*n/xBins);
    aTarget = a_sorted(pos_aTarget);   
    perc(n+1) = aTarget;
    y = ceil(pos_aTarget/l*xBins);
    
end

xCDF = perc;

yCDF = 0:xBins;