function fingers_extremities = fingersExtremities(fingers)
%FINGERSEXTREMITIES Given a greyscale image containing hand parts that are
% over the Keyboard, extracts their extremities in term of [x,y] coordinates.
% 'fingers_extremities' result is a 2*2*5 matrix containing:
%     - upper [x,y] coordinates
%     - bottom [x,y] coordinates
%  Sorted from Thumb to Pinkie
% 
% Data Requirement:
%     - 'fingers' is a greyscale image, double
%     - 'sorting_direction' is a string detailing how fingers have to be
%        ordered depending on which hand has been given in inputz


fingers_props = regionprops(...
        fingers>0, fingers, ...
        'WeightedCentroid', 'MaxFeretProperties', 'MinFeretProperties', 'Orientation'...
);

fingers_extremities = zeros(...
        2, 2, numel(fingers_props) ...
);
% The only relevant feature is the extremity coordinates of fingers.
%{
obtain a 5-layer matrix so that at each level there is:
   [col,row] of one extremity  =  [x,y]
   [col,row] of other extremity   =  [x,y]
   for each finger
%}
for kk = 1:numel(fingers_props)
   if fingers_props(kk).Orientation > -45 && fingers_props(kk).Orientation < 45
      fingers_extremities(:, :, kk) =  fingers_props(kk).MinFeretCoordinates;
      
   else
       fingers_extremities(:, :, kk) =  fingers_props(kk).MaxFeretCoordinates;
   end
end

%{
Since there could be cases in which extremities are put at random,
sort so that at the end  matrix will contain:
   [col,row] of upper extremity    =  [x,y]
   [col,row] of bottom extremity   =  [x,y]
   for each finger

NOTE: Since Y axis grows going down, bottom extremity will have a greater
value than upper one.
%}
for ii = 1:numel(fingers_props)
   if fingers_extremities(1,2,ii) > fingers_extremities(2,2,ii)
     fingers_extremities(:,:,ii) = flip(fingers_extremities(:,:,ii), 1);
   end
end

end

