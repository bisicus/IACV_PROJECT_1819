function [homog_line, p1, p2] = HoughLine_to_homog(line)
%HoughLine_to_homog transforms an Hough Line struct to its homogeneous dual
%vector
% OUTPUTS:
%    * homog_line - row vector in the form [x, y, 1]:
% 
%    * pi - row vector in the form [x, y, 1]:
%        extrema of line
%
% INPUTS:
%    * line - Struct containing Hough Line information
%
   
   p1 = [line.point1, 1];
   p2 = [line.point2, 1];

   homog_line = homog_cross(p1, p2);
    
end