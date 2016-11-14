function [ hexagon ] = HexagonShape( cellRadius, position )
%HEXAGONSHAPE Summary of this function goes here
%   Detailed explanation goes here

hx = cellRadius * [-1 -0.5 0.5 1 0.5 -0.5 -1] + real(position);
hy = (cellRadius * sqrt(3) * [0 -0.5 -0.5 0 0.5 0.5 0] + imag(position)) * 1i;

hexagon = hx+hy;

end

