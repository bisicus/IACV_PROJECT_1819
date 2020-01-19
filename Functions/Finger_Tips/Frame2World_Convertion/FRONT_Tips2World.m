function Z_Coord = FRONT_Tips2World( Front_tips, ...
                                     front_geometric_features, ...
                                     WORLD_Measures )
%FRONT_TIPS2WORLD Computes Real World Coordinates of each Finger Tip
% OUTPUTS:
%    * Z_Coord - vector of coordinates of finger tips in real world system
%      coordinates
%
%
% INPUTS:
%    * Front_tips - matrix of stacked row vector in the form [x, y]
%
%    * front_geometric_features - struct containing geometric features such
%      as point, lines computed from background image
%
%    * WORLD_Measures - struct of hardcoded measurements of World Distances
%
%
% PROCEDURE for each Finger Tip:
%    1) CrossRatio Elements Computation
%       - Computation of 'line to the horizon' passing through Tip and 
%         Vanishing Point
%       - B Point, intersection of 'horizon line' and 'Black Keys
%         Termination' line
%       - W Point, intersection of 'horizon line' and 'White Keys
%         Termination' line
%
%    2) Computing CrossRatio for T, B, W, Vp
%
%    3) Using Cr quantity to Compute World Coordinates
%       - Cross-ratio is an invariant on projective transformations such as
%         the convertion from Image to Real-World system.
%       - Knowing some immutable measurements of the Real World,
%         Cross-ratio value can be used to compute depth of a known point
%         in image ([x,y] coordinates) that is unknown in world.
%         Refer to tip_2_world_depth documentation for further details
%
%
% NOTE:
%    - in real world coordinate system origin has been placed where keys
%      are attached to the plastic control board.
%      This makes computed Distances valuable as Coordinates
%
% See also tip_2_world_depth, cross_ratio, UP_Tips2World

num_elem = size(Front_tips, 1);

Z_Coord = zeros(num_elem, 1);


for kk = 1:num_elem
      T = [ Front_tips(kk, :), 1 ]; % Append 1 to make it Homogeneous
      
      horizon_line = homog_cross(T, front_geometric_features.vanish_point);
      B = homog_cross(horizon_line, front_geometric_features.horiz_BlackKey_line);
      W = homog_cross(horizon_line, front_geometric_features.horiz_whiteKey_line);
      
      %{
         Point order is fixed so that hardcoded 'real-world known properies'
         can be used.
         Points are loaded in the same order in which they could be
         encountered by going from camera to Vanishing Point:
         T, B, W, 
      %}
      
      C_r = cross_ratio(B, T, W, front_geometric_features.vanish_point);
      
      Z_Coord(kk) = tip_2_world_depth(WORLD_Measures, C_r);
end

end

