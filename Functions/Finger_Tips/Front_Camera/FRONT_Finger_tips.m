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

on_KBD_Hand = hands .* KBD_Mask;
% Isolate RED Component
on_KBD_Hand = on_KBD_Hand(:,:,1);

fingers = on_KBD_Hand>0;
fingers = bwmorph(fingers, 'bridge', Inf);
fingers = bwmorph(fingers, 'spur', Inf);
fingers = bwmorph(fingers, 'close', Inf);
fingers = medfilt2(fingers, [6,6]);

finger_tips = FRONT_Tips_Coord(fingers);
end
