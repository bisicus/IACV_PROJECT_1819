function [ idxs, dists ] = find_nearest_idxs(fixed_pts,query_pts, varargin)
%NEAREST_POINT_IDXS  returns 'num' indices of the closest points in 
%coordinate array 'pts' to the query points in 'query_pts'
%Distance measure is given by 'choosen_method'

% ===== INPUT SANITATION ===== %
parser = inputParser();
addRequired(parser, 'fixed_pts');
addRequired(parser, 'query_pts');

addOptional(parser, 'num', 1);

addParameter( parser, 'method', 'euclidean', ...
              @(met) ismember(met, {'manhattan', 'only_x', 'euclidean'}) );


parse(parser, fixed_pts, query_pts, varargin{:});
fixed_pts = parser.Results.fixed_pts;
query_pts = parser.Results.query_pts;
num       = parser.Results.num;
method    = lower( parser.Results.method );

   % ------ %

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
switch method
   case 'manhattan'
      dist = dist_X + dist_Y;
   case 'only_x'
      dist = dist_X;
   otherwise %Euclidean
      dist = dist_X.^2 + dist_Y.^2;
end

[dists, idxs] = mink(dist, num, 2);


end

