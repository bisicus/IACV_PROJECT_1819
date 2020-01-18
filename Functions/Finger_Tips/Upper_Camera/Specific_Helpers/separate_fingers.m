function hands_separated = separate_fingers(hand_frame)
%separate_fingers exploits color differences between fingers in order to
%add a black ([0,0,0] RGB value) thick border in between
%
% OUTPUTS:
%    * hand_separated - frame with black border in between fingers
%
%
% INPUT:
%    * hand_frame - RGB frame
%
%
% PROCEDURE:
%    1) Computing hand Perimeter while accounting for fingers' border
%
%    2) Subtraction from original frame of borders


% ===== 1. Enhanced Perimeter Computation ===== %

% 1) Enhancing Canny Edge Detection
edg = edge(hand_frame, 'Canny', 0.1, 1);
bw = imbinarize(hand_frame, 0.6);

canny_and_black = edg & bw;


% 2) Deletion of noisy palm nervatures and nails attachment
rumors = imopen(canny_and_black, strel('disk', 3));
canny_and_black = imsubtract(canny_and_black, rumors);
canny_and_black = canny_and_black == 1;


% 3) Combining Edges with Perimeter in order to obtain a cleaner image
perim = hand_perimeter(hand_frame);
perim = imdilate(perim, strel('diamond', 1));

enhanced_perim = perim | canny_and_black;
enhanced_perim = bwareaopen(enhanced_perim, 100, 4);



% ===== 2. Fingers Separation ===== %

enhanced_perim = imdilate(enhanced_perim, strel('diamond', 2));
hands_separated = imsubtract(hand_frame, im2double(enhanced_perim));


% ===== 3. Deleting Resulting Small Areas ===== %
mask = imbinarize(hands_separated);
mask = bwareaopen(mask, 100);
hands_separated = hands_separated .* mask;

end

