function [ position, numberOfAps, interSiteDistance ] = HexagonCellGrid( areaSide, density )
%HEXAGONCELLGRID Generates cell position coordinates around UE
%   (c) CONNECT Centre, 2016
%   Trinity College Dublin
%
%   Author: Fadhil Firyaguna

halfCells = ceil( ( areaSide * sqrt( density ) - 1 )/2 );
hexagonSide = areaSide / ( areaSide * sqrt( density ) - 1 );

% Generate hexagonal grid
Rad3Over2 = sqrt(3) / 2;
[ X, Y ] = meshgrid( -halfCells : 1 : (halfCells) );
n = size( X, 1 );
X = Rad3Over2 * X;
if mod(n-1,4) == 0
    Y = Y + [ repmat( [0 .5], [n,floor(n/2)] ), zeros(n,1) ];
else
    Y = Y + [ repmat( [.5 0], [n,floor(n/2)] ), .5*ones(n,1) ];
end

interSiteDistance = hexagonSide * sin( 2*pi/3 ) / sin( pi/6);

% Fit to cell ray
X = .5 * interSiteDistance * X;
Y = .5 * interSiteDistance * Y;

% Reshape matrices to vector
position = reshape( X, 1, [] ) + 1i*reshape( Y, 1, [] );

% Delete positions outside the area
xv = [ -areaSide/2, areaSide/2 ];
yv = [ -areaSide/2 + interSiteDistance/2, areaSide/2 ];
xq = real( position );
yq = imag( position );
in = inpolygon(xq,yq,xv,yv);
position = position(in);
numberOfAps = numel(in);

end

