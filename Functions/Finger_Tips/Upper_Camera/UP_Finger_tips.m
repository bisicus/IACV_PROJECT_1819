function [tips] = UP_Finger_tips(frame, KBD_Mask)
%UP_Finger_tips returns an array containing [x,y] (= [col, row])
%coordinates of finger-tips, computed as a "Spike" of each finger
%
% OUTPUTS:
%    * finger_tips - vertically stacked [x,y] integer coordinates matrix
%
%
% INPUT:
%    * frame - RGB Frame
%
%
% PROCEDURE:
%    1) Hands extraction by color segmentation
% 
%    2) Fingers enlightening by border subtraction
%
%    3) Computation fingers' "spike" by extracting maxima from fingers
%       translated as a [X,Y] Signal
%
%
% See also UP_skin_segmentation, UP_Tips_Coord, hand_perimeter, FRONT_Finger_tips

hands = UP_skin_segmentation(frame);


% Isolating only RED component for better results
hands = hands(:,:,1);

% Elimination of Table Noise that survived on top of the image
on_KBD_Hand = hands .* KBD_Mask;

% Compute Perimeter
perim = hand_perimeter(on_KBD_Hand);


tips = UP_Tips_Coord(perim);

end

