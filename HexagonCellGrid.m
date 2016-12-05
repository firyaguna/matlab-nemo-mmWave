function [ position, numberOfAps ] = ...
    HexagonCellGrid( areaSide, interSiteDistance )
%HEXAGONCELLGRID Generates cell position coordinates around UE
%   (c) CONNECT Centre, 2016
%   Trinity College Dublin
%
%   Author: Fadhil Firyaguna

% Define parameters
id = interSiteDistance;
hs = id * .5 / sin( pi/3 ); % hexagon side
has = .5 * areaSide;
hy1 = ceil( has / id ) * id;
hx1 = ceil( has/(3*hs) ) * 3*hs;
hy2 = hy1 - .5*id;
hx2 = ceil( has/(1.5*hs) ) * 1.5*hs;
if hx2 == hx1
    hx2 = hx2 - 1.5*hs;
end

% Generate hexagonal grid
[ x1, y1 ] = meshgrid( -hx1 : 3*hs : hx1, -hy1 : id : hy1 );
[ x2, y2 ] = meshgrid( -hx2 : 3*hs : hx2, -hy2 : id : hy2 );

% Reshape matrices to complex vector
position1 = reshape( x1, 1, [] ) + 1i*reshape( y1, 1, [] );
position2 = reshape( x2, 1, [] ) + 1i*reshape( y2, 1, [] );
position = [ position1 position2 ];

% Delete positions outside the area
xv = [ -has, has ];
yv = [ -has, has ];
xq = real( position );
yq = imag( position );
in = inpolygon(xq,yq,xv,yv);
position = position(in);

% Compute density
numberOfAps = numel( position );

end

