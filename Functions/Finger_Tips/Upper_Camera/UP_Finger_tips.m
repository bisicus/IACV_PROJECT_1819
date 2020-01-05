function [tips] = UP_Finger_tips(frame)
%UP_FINGER_TIPS Summary of this function goes here
%   Detailed explanation goes here

hands = UP_skin_segmentation(frame);


% Isolating only RED component for better results
hands = hands(:,:,1);

% Elimination of Table Noise that survived on top of the image
hands(1:500, :) = 0;
   
hands_separated = separate_fingers(hands);
   
tips = UP_Tips_Coord(hands_separated);


end

