function [ position, cellRadius ] = HexagonCellGrid( areaSide, density )
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

% Fit to cell ray
X = 2 * hexagonSide * X;
Y = 2 * hexagonSide * Y;

% Reshape matrices to vector
position = reshape( X, 1, [] ) + 1i*reshape( Y, 1, [] );
cellRadius = hexagonSide * 2 * tan(deg2rad(30));

end

