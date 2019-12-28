function result = homog_cross(vec_1,vec_2)
%HOMOG_CROSS cross product for Homogenous Coordinate System
% OUTPUTS:
%    * result - column vector in the form [x; y; 1]:
%
% INPUTS:
%    * vec_i - 2d homogeneous vector represented in a row vector
%        Xi = [x, y, w]
%
   
result = cross(vec_1, vec_2);
result = result / result(3);

end

