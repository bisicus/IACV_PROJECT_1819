
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
      
BW = imbinarize(up_video.background, 0.50);
BW = all(BW, 3);

   % ----- 'Control Board Plastic' removal ----- %
%{
   'Control Board Plastic' region will also be enlightened
   Since this region will be much wider than all the white keys -strictly
   contained within their borders- it could be easily identified and removed
%}
   
% 1) Grouping all the Plastic Region
BW = imfill(BW, 'holes');
% 2) Remotion of biggest area that is Plastic Region
BW = BW & ~bwareafilt(BW, 1);
% 3) Noise remotion
BW = bwareaopen(BW, 7000);
BW = imerode(BW, strel('diamond', 1));
BW = bwmorph(BW, 'majority', Inf );

up_video.WhiteKeys_Mask = BW;
   
            % ==================== %


      %% ===== BLACK KEYS Keyboard Mask Detection ====== %
      
   % ----- color filtering ----- %
Black_Mask = all(up_video.background <= 75, 3);
% black key pixels that were too bright are incorporated
Black_Mask = imfill(Black_Mask, 'holes');


   % ----- extract clean keyboard by using White Key Mask ----- %

props = regionprops(BW, 'MinFeretProperties');

% Since black keys are closed by white keys, by enlarging white mask those
% keys will surely be included.
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
Black_Mask = Black_Mask & ~bwareafilt(Black_Mask, 2, 'largest');

% Also a small square will survive mask treatment, and can be easily
% deleted.
up_video.BlackKeys_Mask = Black_Mask & ~bwareafilt(Black_Mask, 1, 'smallest');

            % ==================== %

            
      %% ===== WHITE KEYS Centroid Feature extraction ====== %

props = regionprops(BW, 'Centroid', 'Extrema');

   % ----- Coordinate Computation ----- %

   % ----- 'Lower Extrema' ----- %
% Store 'Lower Extrema' as a vertically stacked [x,y] coordinates matrix
% Extrema are represented by Keys' centroid
centroids = vertcat(props.Centroid);
up_video.WHITE_Keys_centerCoord_INF = centroids;



   % ----- 'Upper Extrema' ----- %
% Store 'Upper Extrema' as a vertically stacked [x,y] coordinates matrix
% Extrema are computed by averaging upper extrema Points and respective
% key's centroid
upper_extrema = Extrema_Coord_AVG(props, 'high');
upper_extrema = cat(3, upper_extrema, centroids);
upper_extrema = mean(upper_extrema, 3);

up_video.WHITE_Keys_centerCoord_SUP = upper_extrema;   



   % ----- Plotting ----- %
% figure(100);
% imshow( up_video.WhiteKeys_Mask );
% hold on;
% scatter( up_video.WHITE_Keys_centerCoord_SUP(:,1), ...
%          up_video.WHITE_Keys_centerCoord_SUP(:,2), ...
%          'ro' );
%       
% scatter( up_video.WHITE_Keys_centerCoord_INF(:,1), ...
%          up_video.WHITE_Keys_centerCoord_INF(:,2), ...
%          'go' );

            % ==================== %

                        
      %% ===== BLACK KEYS Centroid Feature extraction ====== %
   
props = regionprops(up_video.BlackKeys_Mask, 'Centroid', 'Extrema');

   % ----- 'Upper Extrema' ----- %
% Store 'Upper Extrema' as a vertically stacked [x,y] coordinates matrix
% Extrema are represented by Keys' centroid

centroids = vertcat(props.Centroid);
up_video.BLACK_Keys_centerCoord_SUP = centroids;



   % ----- 'Lower Extrema' ----- %
% Store 'Lower Extrema' as a vertically stacked [x,y] coordinates matrix
% Extrema are represented by Keys' central lowest Point

bottom_extrema = Extrema_Coord_AVG(props, 'low');
up_video.BLACK_Keys_centerCoord_INF = bottom_extrema;



   % ----- Plotting ----- %
% figure(101);
% imshow( up_video.BlackKeys_Mask );
% hold on;
% scatter( up_video.BLACK_Keys_centerCoord_SUP(:,1), ...
%          up_video.BLACK_Keys_centerCoord_SUP(:,2), ...
%          'ro' );
%       
% scatter( up_video.BLACK_Keys_centerCoord_INF(:,1), ...
%          up_video.BLACK_Keys_centerCoord_INF(:,2), ...
%          'go' );

            % ==================== %


      %% ===== Joining Centroids ===== %

   % ----- Top Values ----- %
centr = cat( 1, ...
            up_video.WHITE_Keys_centerCoord_SUP, ...
            up_video.BLACK_Keys_centerCoord_SUP );

% Sort on X Coordinate Value
centr = sortrows( centr, 1, 'ascend' );

up_video.ALLKeys_centerCoord_SUP = centr;



   % ----- Bottom Values ----- %
centr = cat( 1, ...
            up_video.WHITE_Keys_centerCoord_INF, ...
            up_video.BLACK_Keys_centerCoord_INF );

% Sort on X Coordinate Value
centr = sortrows( centr, 1, 'ascend' );

up_video.ALLKeys_centerCoord_INF = centr;



   % ----- Plotting ----- %
% figure(102);
% imshow( up_video.BlackKeys_Mask | up_video.WhiteKeys_Mask );
% hold on;
% scatter( up_video.ALLKeys_centerCoord_SUP(:,1), ...
%          up_video.ALLKeys_centerCoord_SUP(:,2), ...
%          'ro' );
%       
% scatter( up_video.ALLKeys_centerCoord_INF(:,1), ...
%          up_video.ALLKeys_centerCoord_INF(:,2), ...
%          'g*' );



%% ----- Cleaning Workspace ----- %

clear BW BW_dilated Black_Mask props angle
clear black_centroids black_feret_extrema
clear props centr
clear bottom_extrema upper_extrema centroids