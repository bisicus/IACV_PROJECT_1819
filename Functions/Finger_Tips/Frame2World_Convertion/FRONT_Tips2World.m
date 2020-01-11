function [X_Coord, Z_Coord] = ...
            FRONT_Tips2World(Front_finger_tips,front_geometric_features)
%FRONT_TIPS2WORLD Computation of Real World Coordinates of Finger Tips
% 
%    PROCEDURE for each Finger Tip:
%       1) CrossRatio Elements Computation
%          - Computation of 'line to the horizon' passing through Tip and 
%            Vanishing Point
%          - B Point, intersection of 'horizon line' and 'Black Keys
%            Termination' line
%          - W Point, intersection of 'horizon line' and 'White Keys
%            Termination' line
%       2) Computing CrossRatio for T, B, W, Vp
%       3) Using Cr quantity to Compute World Coordinates
%          - TODO:

X_Coord = Front_finger_tips(:, 1);

Z_Coord = zeros(size(Front_finger_tips, 1), 1);


for kk = 1:size(Front_finger_tips, 1)
      T = [ Front_finger_tips(kk, :), 1 ];
      
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
      
      C_r = cross_ratio(T, B, W, front_geometric_features.vanish_point);
      
      Z_Coord(kk) = tip_2_world_depth(WORLD_Measures, C_r);
end

end

