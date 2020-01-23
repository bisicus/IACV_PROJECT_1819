function Z_Coord = UP_Tips2World( Up_tips, ...
                                  up_geometric_features, ...
                                  WORLD_Measures )
%UP_TIPS2WORLD Computes Real World Coordinates of each Finger Tip
% OUTPUTS:
%    * Z_Coord - vector of coordinates of finger tips in real world system
%      coordinates
%
%
% INPUTS:
%    * Up_tips - matrix of stacked row vector in the form [x, y]
%
%    * up_geometric_features - struct containing geometric features such as
%      point, lines computed from background image
%
%    * WORLD_Measures - struct containing hardcoded values from real world
%      system coordinate
% 
%
% PROCEDURE for each Finger Tip:
%    1) Compute distance between Tip and 'starting keys line' (placed at
%       the end of the plastic control board
%
%    2) Compute Z_Coord as the convertion of Pixel distance to Real World
%       metric system (millimeters)
%
% NOTE:
%    - in real world coordinate system origin has been placed where keys
%      are attached to the plastic control board.
%      This makes computed Distances valuable as Coordinates
%
% See also FRONT_Tips2World, point_line_distance

num_elem = size(Up_tips, 1);

Z_Coord = zeros( num_elem, 1);

for kk = 1:num_elem
   dist = point_line_distance( Up_tips(kk, :), ...
                               up_geometric_features.keys_start_line );
   
   Z_Coord(kk) = dist * WORLD_Measures.Up_Cam.metr_over_px_RATIO;
end

end

