
%% Notes
%{
   This script is composed of two different operations repeated for White
   and Black Keys:
   1) Keyboard Detection:
      Definition of a 'Logical Mask' enlightening only keys belonging to a
      specific color
   
   2) Centroid Extraction:
      Centroids defines each key center-of-mass in term of
         [x,y] (=[col,row]) coordinates.

      Those are usefull for keys identification and sorting w.r.t. 
      keyboard width.
      
      Later on those coordinates will be used for identification and
      matching of computed finger-tips from two distinct cameras
   
         - White Keys are identified by (approximately) it's "center"
         - Black Keys are identified by its Bottom Y Coordinate
   
%}

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

front_video.BlackKeys_Mask = bwareaopen(BlackKeys_Mask, 150);

                     % ==================== %

                     
      %% ===== WHITE KEYS Centroid Feature extraction ====== %

props = regionprops(front_video.WhiteKeys_Mask, 'Centroid', ... 
                                                'Extrema');

   % ----- 'Upper Extrema' ----- %
% Store 'Upper Extrema' as a vertically stacked [x,y] coordinates matrix
% Extrema are represented by Keys' centroid

centroids = vertcat(props.Centroid);
front_video.WHITE_Keys_centerCoord_SUP = centroids;



   % ----- 'Lower Extrema' ----- %
% Store 'Lower Extrema' as a vertically stacked [x,y] coordinates matrix
% Extrema are represented by Keys' central lowest Point
bottom_extrema = Extrema_Coord_AVG(props, 'low');
front_video.WHITE_Keys_centerCoord_INF = bottom_extrema;


   % ----- Plotting ----- %
% figure(200);
% imshow( front_video.WhiteKeys_Mask );
% hold on;
% scatter( front_video.WHITE_Keys_centerCoord_SUP(:,1), ...
%          front_video.WHITE_Keys_centerCoord_SUP(:,2), ...
%          'ro' );
%       
% scatter( front_video.WHITE_Keys_centerCoord_INF(:,1), ...
%          front_video.WHITE_Keys_centerCoord_INF(:,2), ...
%          'go' );
 
                     % ==================== %
            
                     
      %% ===== BLACK KEYS Centroid Feature extraction ====== %
   
props = regionprops(front_video.BlackKeys_Mask, 'Centroid', 'Extrema');


   % ----- Coordinate Computation ----- %
   
% Store 'Upper Extrema' as a vertically stacked [x,y] coordinates matrix
% centroids = vertcat(props.Centroid);
upper_extrema = Extrema_Coord_AVG(props, 'high');

% Store 'Low Extrema' as a vertically stacked [x,y] coordinates matrix
bottom_extrema = Extrema_Coord_AVG(props, 'low');

   
   % ----- Coordinate Storing ----- %

front_video.BLACK_Keys_centerCoord_SUP = upper_extrema;
front_video.BLACK_Keys_centerCoord_INF = bottom_extrema;
   

   % ----- Plotting ----- %
% figure(201);
% imshow( front_video.BlackKeys_Mask );
% hold on;
% scatter( front_video.BLACK_Keys_centerCoord_SUP(:,1), ...
%          front_video.BLACK_Keys_centerCoord_SUP(:,2), ...
%          'ro' );
%       
% scatter( front_video.BLACK_Keys_centerCoord_INF(:,1), ...
%          front_video.BLACK_Keys_centerCoord_INF(:,2), ...
%          'go' );


      %% ===== Joining Centroids ===== %

   % ----- Top Values ----- %
centr = cat( 1, ...
            front_video.WHITE_Keys_centerCoord_SUP, ...
            front_video.BLACK_Keys_centerCoord_SUP );

% Sort on X Coordinate Value
centr = sortrows( centr, 1, 'ascend' );

front_video.ALLKeys_centerCoord_SUP = centr;


   % ----- Bottom Values ----- %
centr = cat( 1, ...
            front_video.WHITE_Keys_centerCoord_INF, ...
            front_video.BLACK_Keys_centerCoord_INF );

% Sort on X Coordinate Value
centr = sortrows( centr, 1, 'ascend' );

front_video.ALLKeys_centerCoord_INF = centr;



   % ----- Plotting ----- %
% figure(202);
% imshow( front_video.BlackKeys_Mask | front_video.WhiteKeys_Mask );
% hold on;
% scatter( front_video.ALLKeys_centerCoord_SUP(:,1), ...
%          front_video.ALLKeys_centerCoord_SUP(:,2), ...
%          'ro' );
%       
% scatter( front_video.ALLKeys_centerCoord_INF(:,1), ...
%          front_video.ALLKeys_centerCoord_INF(:,2), ...
%          'g*' );



%% ----- Cleaning Workspace ----- %

clear BW BW_dilated 
clear BlackKeys_Mask NoiseElement_mask
clear props centr
clear bottom_extrema upper_extrema centroids