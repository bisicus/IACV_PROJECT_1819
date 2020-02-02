function circular_queue = remove_from_queue( circular_queue, to_delete_coords, dist_thsh )
%REMOVE_FROM_QUEUE Summary of this function goes here
%   Detailed explanation goes here

for kk = 1:length(circular_queue)
   if ~isempty(circular_queue{kk})
      [~, dists] = find_nearest_idxs( to_delete_coords, ...
                                      circular_queue{kk}, ...
                                      1, ...
                                      'method', 'only_x' );
                       
      circular_queue{kk}(dists < dist_thsh, :) = [];
      
   end
end

end

