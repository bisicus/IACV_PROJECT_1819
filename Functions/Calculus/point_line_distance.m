function [distance, nearest_point] = point_line_distance(point, line)
%point_line_distance computes minimum distance from point to line expressed
%in homogeneous coordinates
%It also returns homogeneous coordinates of point belonging to the line
%that is the nearest w.r.t. input point
%
% OUTPUTS:
%    * distance - float number
% 
%    * nearest_point - homogeneous row vector in the form [x, y, 1]:
%        coordinate of point belonging to line, that is the nearest to
%        input point
%
%
% INPUTS:
%    * point - homogeneous row vector in the form [x, y, 1]:
%
%    * line - homogeneous row vector in the form [a, b, c]:
%
%
% PROCEDURE:
%    * distance is computed as:
%
%                 |ax + by + c| 
%           d = -----------------
%                sqrt(a^2 + b^2)
%
%
%    * instersection point have coordinates:
%
%                b*(bx - ay) - ac          a*(-bx + ay) - bc  
%           x = ------------------,   y = -------------------
%                 sqrt(a^2 + b^2)           sqrt(a^2 + b^2)  
%
% Reference:
%     https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line
%     https://math.stackexchange.com/questions/2512088/distance-between-line-and-point-in-homogeneous-coordinates


   % ===== Parameter Extraction ===== %
x = point(1);
y = point(2);

a = line(1);
b = line(2);
c = line(3);

denom = (a^2 + b^2)^(0.5);

   % ===== Measurements ===== %
distance = (point * line') / denom;


c1 = ( b*(b*x - a*y) - a*c ) / denom;
c2 = ( a*(a*y - b*x) - b*c ) / denom;
nearest_point = [c1, c2, 1];
end

