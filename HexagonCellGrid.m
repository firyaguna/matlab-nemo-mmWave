function [ position, numCells ] = HexagonCellGrid( areaSide, cellRay )
%HEXAGONCELLGRID Generates cell position coordinates around UE
%   (c) CONNECT Centre, 2016
%   Trinity College Dublin
%
%   Author: Fadhil Firyaguna

halfCells = ceil( areaSide / cellRay / 2);
numCells = ( 2 * halfCells )^2;

% Generate hexagonal grid
Rad3Over2 = sqrt(3) / 2;
[ X, Y ] = meshgrid( -halfCells : 1 : (halfCells-1) );
n = size( X, 1 );
X = Rad3Over2 * X;
Y = Y + repmat( [0 0.5], [n,n/2] );

% Fit to cell ray
X = cellRay * X;
Y = cellRay * Y;

% Reshape matrices to vector
position = reshape( X, 1, [] ) + 1i*reshape( Y, 1, [] );


end

