function result = point_above_line(point,line)
%POINT_ABOVE_LINE returns a Boolean indicating if given point is Above or
%Below a given line.
%
% IMPORTANT NOTE:
%    Since Image coordinate system origin is placed on Top-left corner of
%    image itself, Y grows going down.
%    This implies that 'above' and 'below'
%
%
% OUTPUTS:
%    * result - logical value
%
%
% INPUTS:
%    * point - 2d homogeneous vector represented as a row vector [x, y, 1]
%
%    * line - 2d homogeneous vector represented as a row vector [a, b, c]
%
%
% PROCEDURE:
%    1) m and q coefficient are computed from Homogeneous vector
%
%             l = [a,b,c]  -->  ax + by + c = 0
% 
%                   (a)    ||         (c)
%             m = -( - )   ||   q = -( - )
%                   (b)    ||         (b)
%
%   2) Points above a given line respects inequality
%             y > mx + q
%       
%       - A point is above the line if:
%             mX + q  - Y < 0
%
%       - On the contrary a point is under the line if
%             mX + q  - Y > 0
%
%        - Points that are "On the Line" 
%             mX + q  - Y = 0
%          Are threated as if is above line 
%
%   3) Swapping Results since of Image Coordinate System Origin


X = point(1);
Y = point(2);

m = -( line(1)/line(2) );
q = -( line(3)/line(2) );


result = ~ (m*X + q  - Y <= 0);
end

