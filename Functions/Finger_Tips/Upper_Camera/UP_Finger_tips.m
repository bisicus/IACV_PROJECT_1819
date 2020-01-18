function [tips] = UP_Finger_tips(frame)
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
% See also UP_skin_segmentation, UP_Tips_Coord, FRONT_Finger_tips

hands = UP_skin_segmentation(frame);


% Isolating only RED component for better results
hands = hands(:,:,1);

% Elimination of Table Noise that survived on top of the image
hands(1:500, :) = 0;
   
hands_separated = separate_fingers(hands);
   
tips = UP_Tips_Coord(hands_separated);


end

