function [ position, numCells ] = HexagonCellGrid( areaSide, cellRay )
%HEXAGONCELLGRID Generates cell position coordinates around UE
%   (c) CONNECT Centre, 2016
%   Trinity College Dublin
%
%   Author: Fadhil Firyaguna

halfCells = ceil( areaSide / cellRay / 2);
numCells = ( 2 * halfCells + 1 )^2;

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
X = 2 * cellRay * X;
Y = 2 * cellRay * Y;

% Reshape matrices to vector
position = reshape( X, 1, [] ) + 1i*reshape( Y, 1, [] );

end

