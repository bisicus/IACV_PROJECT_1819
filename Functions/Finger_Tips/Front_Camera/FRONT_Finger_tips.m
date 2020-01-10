function [finger_tips] = FRONT_Finger_tips(frame, KBD_Mask)
%FRONT_FINGER_TIPS
%
% OUTPUTS:
%    * finger_tips - integer array
%
% INPUT:
%    * pressed_Coords - matrix of vertically stacked [x,y] coordinates
%           represents centroid of computed 'pressed areas'
%
%    * KBD_Mask - Logical Mask "Playable Area" of the Keyboard
%
% PROCEDURE:
%    1) Hands extraction by color segmentation
% 
%    2) Isolation of Hand areas that are over Keyboard
%
%    3) Computation of 'vertical' extremities of each area
%    
%    4) Isolation of 'bottom' only coordinates
%
%    
% See also FRONT_SKIN_SEGMENTATION

hands = FRONT_skin_segmentation(frame);

on_KBD_Hand = im2double(hands) .* KBD_Mask;
on_KBD_Hand = rgb2gray(on_KBD_Hand);


finger_tips = FRONT_Tips_Coord(fingers);

% Finger Tip is the lowest point of each "Blob"
finger_tips = reshape( ...
   permute( fingers_extremities(2,:,:), [3,1,2] ), ...
   size(fingers_extremities,3), ...
   [] ...
);

end
