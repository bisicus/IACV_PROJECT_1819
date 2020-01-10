function [finger_tips] = FRONT_Finger_tips(frame, KBD_Mask)
%FRONT_Finger_tips returns an array containing [x,y] (= [col, row])
%coordinates of finger-tips, computed as a "Spike" of each finger
%
% OUTPUTS:
%    * finger_tips - vertically stacked [x,y] integer coordinates matrix
%
%
% INPUT:
%    * frame - RGB Frame
%
%    * KBD_Mask - Logical Mask representing "Playable Area" of the Keyboard
%
%
% PROCEDURE:
%    1) Hands extraction by color segmentation
% 
%    2) ROI Isolation: Fingers that are over Keyboard
%
%    3) Computation fingers' "spike" by extracting maxima from fingers
%       translated as a [X,Y] Signal
%
%
% See also FRONT_skin_segmentation, FRONT_Tips_Coord, UP_Finger_tips

   % ====== 1. Hand Segmentation ===== %

hands = FRONT_skin_segmentation(frame);


   % ====== 2. ROI Isolation ===== %
on_KBD_Hand = hands .* KBD_Mask;
% Isolate RED Component
on_KBD_Hand = on_KBD_Hand(:,:,1);

fingers = on_KBD_Hand>0;
fingers = bwmorph(fingers, 'bridge', Inf);
fingers = bwmorph(fingers, 'spur', Inf);
fingers = bwmorph(fingers, 'close', Inf);
fingers = medfilt2(fingers, [6,6]);


   % ====== 3. Coordinates Extraction ===== %
finger_tips = FRONT_Tips_Coord(fingers);

end
