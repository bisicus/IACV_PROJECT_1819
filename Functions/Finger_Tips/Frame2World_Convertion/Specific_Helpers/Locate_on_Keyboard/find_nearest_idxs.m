function idxs = find_nearest_idxs(fixed_pts,query_pts, num)
%NEAREST_POINT_IDXS  returns 'num' indices of the closest points in 
%coordinate array 'pts' to the query points in 'query_pts'
%Distance is measured via Euclidean 

pt_x = fixed_pts(:,1);
pt_y = fixed_pts(:,2);

q_x = query_pts(:,1);
q_y = query_pts(:,2);


%{
   stores distance of each point of 'pts' to 'query_pts'.
   Row 'i' stores the distance of i-th point in 'pts' from all the points
   in 'query_pts'.
   Distances are stored as absolute values.
%} 
      
dist_X = abs(q_x - pt_x');
dist_Y = abs(q_y - pt_y');

% min_dist stores for each row [point of 'pts'] the distance to the closest
% point in 'query_pts'
% size = #row_pts * 1
dist = dist_X.^2 + dist_Y.^2; % can skip sqrt since i'm taking the minimum
[~, idxs] = mink(dist, num, 2);


end

