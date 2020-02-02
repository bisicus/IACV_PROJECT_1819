function [ pressed_idx, ...
           corresponding_data ] = compare_on_prev_frames( candidate_tips, ...
                                                          prev_pressed_queue, ...
                                                          dist_thsh, ...
                                                          freq_thsh, ...
                                                          varargin )
%COMPARE_ON_PREV_FRAMES Summary of this function goes here
%   Detailed explanation goes here

   pressed_idx = [];
   if ~isempty(candidate_tips)
      
      freq_count = zeros(size(candidate_tips, 1), 1);
      
      for kk = 1:length(prev_pressed_queue)
         if ~isempty(prev_pressed_queue{kk})
            [~, dists] = find_nearest_idxs( prev_pressed_queue{kk}, ...
                                            candidate_tips, ...
                                            1, ...
                                            'method', 'only_x' );
                       
            freq_count( dists < dist_thsh ) = freq_count( dists < dist_thsh ) + 1;
         end
      end
      
      pressed_idx = find(freq_count >= freq_thsh);
      
   end
   
   corresponding_data = candidate_tips(pressed_idx, :);
      

end
