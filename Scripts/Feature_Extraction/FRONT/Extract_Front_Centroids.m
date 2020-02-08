

%% ===== WHITE KEYS Centroid Feature extraction ====== %

props = regionprops( front_video.WhiteKeys_Mask, 'Centroid', ... 
                                                 'Extrema' );

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
 
                     % ==================== %
            
                     
      %% ===== BLACK KEYS Centroid Feature extraction ====== %
   
props = regionprops( front_video.BlackKeys_Mask, 'Centroid', ...
                                                  'Extrema' );


   % ----- Coordinate Computation ----- %
   
% Store 'Upper Extrema' as a vertically stacked [x,y] coordinates matrix
% centroids = vertcat(props.Centroid);
upper_extrema = Extrema_Coord_AVG(props, 'high');

% Store 'Low Extrema' as a vertically stacked [x,y] coordinates matrix
bottom_extrema = Extrema_Coord_AVG(props, 'low');

   
   % ----- Coordinate Storing ----- %

front_video.BLACK_Keys_centerCoord_SUP = upper_extrema;
front_video.BLACK_Keys_centerCoord_INF = bottom_extrema;
 
                     % ==================== %
            
                     
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


      %% ===== Plotting ===== %

if show_figures == 1
   
   % White Keys Mask %
   figure(200);
   imshow( front_video.WhiteKeys_Mask ); title("White-keys' centroids")
   hold on;
   scatter( front_video.WHITE_Keys_centerCoord_SUP(:,1), ...
            front_video.WHITE_Keys_centerCoord_SUP(:,2), ...
            50, 'o', 'r', 'filled' );

   scatter( front_video.WHITE_Keys_centerCoord_INF(:,1), ...
            front_video.WHITE_Keys_centerCoord_INF(:,2), ...
            50, 'o', 'g', 'filled' );
   hold off;

   
   % Black Keys Mask %
   figure(201);
   imshow( front_video.BlackKeys_Mask ); title("black-keys' centroids")
   hold on;
   scatter( front_video.BLACK_Keys_centerCoord_SUP(:,1), ...
            front_video.BLACK_Keys_centerCoord_SUP(:,2), ...
            50, 'o', 'red', 'filled' );

   scatter( front_video.BLACK_Keys_centerCoord_INF(:,1), ...
            front_video.BLACK_Keys_centerCoord_INF(:,2), ...
            50, 'o', 'greed', 'filled' );
   hold off;
   
         
   % ALL Keys Mask %
   figure(202);
   imshow( front_video.BlackKeys_Mask | front_video.WhiteKeys_Mask );
   title("Keyboard Centroids. green: lower, red: upper")
   hold on;
   scatter( front_video.ALLKeys_centerCoord_SUP(:,1), ...
            front_video.ALLKeys_centerCoord_SUP(:,2), ...
            50, 'o', 'red', 'filled' );

   scatter( front_video.ALLKeys_centerCoord_INF(:,1), ...
            front_video.ALLKeys_centerCoord_INF(:,2), ...
            50, 'o', 'green', 'filled' );
   hold off;
   
end

%% ----- Cleaning Workspace ----- %

clear props centroids centr
clear upper_extrema bottom_extrema

