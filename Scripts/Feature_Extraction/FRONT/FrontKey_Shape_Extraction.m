

%% ----- WHITE KEYS EXTRACTION ----- %

% color filtering: white pixels will be enlightened
BW = imbinarize(front_video.background, 0.7);
BW = all(BW, 3);
% BW = imerode(BW, strel('diamond', 1));
BW = bwareaopen(BW, 50);

BW = imfill(BW, 'holes');

% Some Plastic elements could have survived, White Keys are enlarged in
% order to include also black keys creating a unique wide 'rectangle'.
% In that way all other elements will be surelly smaller and can be easily
% identified and deleted
BW_dilated = imdilate(BW, strel('line', 120, -1.5));
BW_dilated = bwareafilt(BW_dilated, 1, 'largest');

% Combination of 'dirty White Key' and 'Keys rectangle' will give the
% actual White Key mask.
front_video.WhiteKeys_Mask = BW & BW_dilated;

% Centroid Feature extraction
props = regionprops(front_video.WhiteKeys_Mask, 'Centroid');

% Store keys as matrix of vertically stacked [x,y] centroid coordinates
front_video.WhiteKeys_centerCoordinates = vertcat(props.Centroid);



%% ----- BLACK KEYS EXTRACTION ----- %

% color filtering: some light affects keys, RGB value is't totally black
BlackKeys_Mask = all(front_video.background <= 140, 3);


% Rectificiation produced a series of black pixels that have to be deleted
NoiseElement_mask = all(front_video.background <= 5, 3);
% Mask is enlarged by mean of all other plastic elements that do not belong
% the keyboard itself
NoiseElement_mask = NoiseElement_mask | ~BW_dilated;
NoiseElement_mask = imdilate(NoiseElement_mask, strel('diamond', 3));


BlackKeys_Mask = BlackKeys_Mask & ~NoiseElement_mask;
BlackKeys_Mask = imfill(BlackKeys_Mask, 'holes');
front_video.BlackKeys_Mask = bwareaopen(BlackKeys_Mask, 100);

props = regionprops(front_video.BlackKeys_Mask, 'Centroid');

% Store keys as matrix of vertically stacked [x,y] centroid coordinates
front_video.BlackKeys_centerCoordinates = vertcat(props.Centroid);

%% Cleaning Workspace
clear BW BW_dilated FV_mask BlackKeys_Mask props NoiseElement_mask