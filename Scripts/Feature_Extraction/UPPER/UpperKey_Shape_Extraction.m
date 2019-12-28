

%% ----- WHITE KEYS EXTRACTION ----- %
BW = imbinarize(up_video.background, 0.50);
BW = all(BW, 3);

% 'Control Board Plastic' region will also be enlightened
% Since this region will be much wider than all the white keys -strictly
% contained within their borders- it could be easily identified and removed
% 1) Grouping all the Plastic Region
BW = imfill(BW, 'holes');
% 2) Remotion of biggest area that is Plastic Region
BW = BW & ~bwareafilt(BW, 1);
% 3) Noise remotion
BW = bwareaopen(BW, 7000);

up_video.WhiteKeys_Mask = imerode(BW, strel('diamond', 1));

% Centroid Feature extraction
props = regionprops(BW, 'Centroid', 'MinFeretProperties');

% Store keys as matrix of vertically stacked [x,y] centroid coordinates
up_video.WhiteKeys_centerCoordinates = vertcat(props.Centroid);


%% ----- BLACK KEYS EXTRACTION ----- %

% color filtering: some light affects keys, RGB value is't totally black
Black_Mask = all(up_video.background <= 75, 3);
% black key pixels that were too bright are incorporated
Black_Mask = imfill(Black_Mask, 'holes');


% In order to extract clean keyboard White Key Mask is used:
% Since black keys are closed by white keys, by enlarging white mask surely
% those keys will be included.
angle = vertcat(props.MinFeretAngle);
angle(angle>0) = angle(angle>0)-180;
angle = mean(angle);
BW_dilated = imdilate(BW, strel('line', 200, angle));
BW_dilated  = imfill(BW_dilated , 'holes');

% Retaining only Black keys
Black_Mask  = Black_Mask & BW_dilated;
Black_Mask = imopen(Black_Mask, strel('square', 15));
% Combining with dilated mask has also included side Plastic Border of the
% keyboard. Those areas are surely wider than single keys making them
% easilly identifiable.
up_video.BlackKeys_Mask = Black_Mask & ~bwareafilt(Black_Mask, 2, 'largest');

% Centroid Feature extraction
props = regionprops(Black_Mask, 'Centroid'); 

% Store keys as matrix of vertically stacked [x,y] centroid coordinates
up_video.BlackKeys_centerCoordinates = vertcat(props.Centroid);


%% Cleaning Workspace
clear BW BW_dilated Black_Mask props angle