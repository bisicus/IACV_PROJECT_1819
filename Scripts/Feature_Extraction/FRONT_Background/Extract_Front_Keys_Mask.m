
      %% ===== WHITE KEYS Keyboard Mask Detection ====== %

% 1) color filtering: white pixels will be enlightened
BW = imbinarize(front_video.background, 0.74);
BW = all(BW, 3);
BW = bwareaopen(BW, 50);

BW = imfill(BW, 'holes');

   % ----- 'Control Board Plastic' removal ----- %
%{
   'Control Board Plastic' region will also be enlightened
   Since this region will be much wider than all the white keys -strictly
   contained within their borders- it could be easily identified and removed
%}

% 1) Grouping all the Plastic Region
BW_dilated = imdilate(BW, strel('line', 120, -1.5));
BW_dilated = bwareafilt(BW_dilated, 1, 'largest');

% 2) Combination of 'dirty White Key' and 'Keys rectangle' will give the
% actual White Key mask.

front_video.WhiteKeys_Mask = BW & BW_dilated;

                     % ==================== %
            
                     
      %% ===== BLACK KEYS Keyboard Mask Detection ====== %
      
   % ----- color filtering ----- %
% 1) some light affects keys, RGB value is't totally black
BlackKeys_Mask = all(front_video.background <= 140, 3);

% 2) Find Areas that have been obscured by Frame-Preprocessing
NoiseElement_mask = all(front_video.background <= 5, 3);

% 3) Enlarging to include all other plastic elements that do not belong
% keyboard itself
NoiseElement_mask = NoiseElement_mask | ~BW_dilated;
NoiseElement_mask = imdilate(NoiseElement_mask, strel('diamond', 3));

% 4) Mask Cleaning
% Remove Plastic and Preprocessing
BlackKeys_Mask = BlackKeys_Mask & ~NoiseElement_mask;
BlackKeys_Mask = imfill(BlackKeys_Mask, 'holes');
BlackKeys_Mask = bwareaopen(BlackKeys_Mask, 150);

front_video.BlackKeys_Mask = BlackKeys_Mask;

                     % ==================== %


      %% ===== Joining Masks to Obtain 'Hand Playing ROI' ====== %
  
% Combine Masks
KBD_Mask = front_video.BlackKeys_Mask | front_video.WhiteKeys_Mask;
KBD_Mask = bwareaopen(KBD_Mask, 150);

% Dilation to fill Leaks between keys
s1 = strel('line', 15, -1.5);
s2 = strel('rectangle', [30, 1]);

KBD_Mask = imdilate( KBD_Mask, [s1, s2] );


front_video.HandsOnKBD_Mask = KBD_Mask;


%% ----- Cleaning Workspace ----- %

clear BW BW_dilated 
clear BlackKeys_Mask NoiseElement_mask
clear KBD_Mask s1 s2

