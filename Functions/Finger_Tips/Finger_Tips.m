function [finger_tips] = Finger_Tips(frame, KBD_Mask)
%FINGER_TIP
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
%    1) Isolation of Hand areas that are over Keyboard
%
%    2) Computation of 'vertical' extremities of each area
%    
%    3) Isolation of 'bottom' only coordinates
%
% NOTE: 
%    
% See also FRONT_SKIN_SEGMENTATION

on_KBD_Hand = im2double(frame) .* KBD_Mask;
on_KBD_Hand = rgb2gray(on_KBD_Hand);


fingers_extremities = fingersExtremities(on_KBD_Hand);

% Finger Tip is the lowest point of each "Blob"
finger_tips = reshape( ...
   permute( fingers_extremities(2,:,:), [3,1,2] ), ...
   size(fingers_extremities,3), ...
   [] ...
);

end
