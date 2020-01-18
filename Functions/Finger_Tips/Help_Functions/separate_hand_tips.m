function [left_tips, right_tips] = separate_hand_tips(tips)
%SEPARATE_HAND_TIPS returns two distinct tip-arrays for the two distinct
%hands
% OUTPUTS/INPUTS:
%    *_tips - vertically stacked [x,y] integer coordinates matrix


% extract columns
cols = tips(:,1);

% search for a great interruption in the array
diff = abs( cols(1:end-1) - cols(2:end) );
[~, interrupt_idx] = max(diff);

left_tips = tips( 1:interrupt_idx, : );
right_tips = tips( interrupt_idx+1:end , :);

end

