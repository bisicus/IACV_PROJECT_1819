function matched_tips = match_UpFront_tips(FRONT_tips, UP_tips, ...
                                          front_video_struct, ...
                                          up_video_struct, ...
                                          front_geometric_features)
%MATCH_UPFRONT_TIPS Alings and sort tips coordinates from the two videos
%while deleting tips that haven been detected in one of the two frame.
%
% OUTPUTS:
%    * matched_tips - 3D Matrix of coordinates where each depth level
%    contains a pair of [x,y], vertically stacked coordinates
%             [ [x_front, y_front];
%               [x_up, y_up]  ] 
%
% INPUT:
%    * \_tips - 2D matrix of vertically stacked coordinates of previously
%    computed finger tips [x,y]
%
%    * \_video_struct - structure containing all videos details and
%    measurements common to all the frames.
%
%    * front_geometric_features - structure containing geometric
%    elements like lines and point parameters.
%
% 
% PROCEDURE:
%    0) Each Front Tip is treated separately
%
%    1) Identification of keys that are the nearest to tip
%       Distance is computed via Euclidean measure
%       
%    2) Retrieval of those keys in the upper frame
%
%    3) Find Upper Tip by triagulation:
%       Use Tip that is the nearest to selected Keys
%       Distance is computed by absolute difference of X Coordinate
% 
%    4) Pair found coordinates
%
% NOTE on step 1:
%    Since Front Frame lacks in depth of the real world some front keys
%    can me mismatched.
%    In order to avoid this effect, front_video_struct is provided by two
%    distinct keys structures, INF and SUP, storing for each key different
%    centroid coordinates computed at superior and inferior extrema of each
%    key.
%    When computing nearest keys only one of this structure is choosen
%    depending on ROW [Y] value of Finger Tip:
%       - if tip is above "Black Keys Horizontal border line", then SUP
%       structure is selected
%       - if tip is under "Black Keys Horizontal border line", then INF
%       structure is selected


UP_Keys = up_video_struct.ALLKeys_centerCoord_INF;


% Preallocating result memory space (for speed)
matched_tips = zeros(2,2, size(FRONT_tips, 1));


for jj = 1:size(FRONT_tips, 1)
   
   F_Tip = FRONT_tips(jj,:);
   
   % ----- Choosing Appropriate Coordinate Structure ----- %
   if point_above_line(F_Tip, front_geometric_features.horiz_BlackKey_line)
      Front_Keys = front_video_struct.ALLKeys_centerCoord_SUP;
   else
      Front_Keys = front_video_struct.ALLKeys_centerCoord_INF;
   end
  
   % ----- Compute nearest keys ----- %
   FR_Near_keys_idxs = find_nearest_idxs(Front_Keys, F_Tip, 4);
   
   % ----- Keys Retrieval on Upper Frame ----- %
   UP_Near_keys_idxs = UP_Keys(FR_Near_keys_idxs(jj,:), :);
   
   
   % ----- Triangulation of Upper Tip ------ %
   x_keys_selected = UP_Near_keys_idxs(:, 1);
   
   x_tips = UP_tips(:,1);
   
   dist = abs(x_keys_selected - x_tips');
   
   dist = sum(dist, 1); %sum on cols
   [~, choosen_tip_idx] = min(dist);
   
   
   % ----- Stack FRONT and UP Tips in the 3D Tips Array ----- %
   matched_tips(1,:, jj) = F_Tip;
   matched_tips(2,:, jj) = UP_tips( choosen_tip_idx, : );
   
end


end