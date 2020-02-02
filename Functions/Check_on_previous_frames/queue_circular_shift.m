function circular_queue = queue_circular_shift( circular_queue , new_elem)
%QUEUE_CIRCULAR_SHIFT Summary of this function goes here
%   Detailed explanation goes here

circular_queue(2:end) = circular_queue(1:end-1);
circular_queue{1} = new_elem;

end

