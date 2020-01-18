

%% ===== WHITE KEYS Centroid Feature extraction ====== %

props = regionprops( up_video.WhiteKeys_Mask, 'Centroid', ...
                                              'Extrema' );


% ----- 'Lower Extrema' ----- %
% Store as a vertically stacked [x,y] coordinates matrix
% Extrema are represented by Keys' centroid
centroids = vertcat(props.Centroid);



% ----- 'Upper Extrema' ----- %
% Store as a vertically stacked [x,y] coordinates matrix
% Extrema are computed by averaging upper extrema Points and respective
% key's centroid
upper_extrema = Extrema_Coord_AVG(props, 'high');
upper_extrema = cat(3, upper_extrema, centroids);
upper_extrema = mean(upper_extrema, 3);


% ----- Combining Extrema ----- %
% in order to create a more centered estimator of the key. 

centr = cat(3, centroids, upper_extrema); 
centr = mean(centr, 3);

up_video.WHITE_Keys_centerCoord = centr;


   % ----- Plotting ----- %
% figure(100);
% imshow( up_video.WhiteKeys_Mask );
% hold on;
% scatter( up_video.WHITE_Keys_centerCoord(:,1), ...
%          up_video.WHITE_Keys_centerCoord(:,2), ...
%          40, 'o', 'r', 'filled' );

            % ==================== %

                        
      %% ===== BLACK KEYS Centroid Feature extraction ====== %
   
props = regionprops( up_video.BlackKeys_Mask, 'Centroid', ...
                                              'Extrema' );

% ----- 'Upper Extrema' ----- %
% Store as a vertically stacked [x,y] coordinates matrix
% Extrema are represented by Keys' centroid

centroids = vertcat(props.Centroid);

% ----- 'Lower Extrema' ----- %
% Store as a vertically stacked [x,y] coordinates matrix
% Extrema are represented by Keys' central lowest Point

bottom_extrema = Extrema_Coord_AVG(props, 'low');


% ----- Combining Extrema ----- %
% in order to create a more centered estimator of the key. 

centr = cat(3, centroids, bottom_extrema); 
centr = mean(centr, 3);

up_video.BLACK_Keys_centerCoord = centr;



   % ----- Plotting ----- %
% figure(101);
% imshow( up_video.BlackKeys_Mask );
% hold on;
% scatter( up_video.BLACK_Keys_centerCoord(:,1), ...
%          up_video.BLACK_Keys_centerCoord(:,2), ...
%          40, 'o', 'r', 'filled' );

            % ==================== %


      %% ===== Joining Centroids ===== %

centr = cat( 1, ...
            up_video.WHITE_Keys_centerCoord, ...
            up_video.BLACK_Keys_centerCoord );

% Sort on X Coordinate Value
centr = sortrows( centr, 1, 'ascend' );

up_video.ALLKeys_centerCoord = centr;



   % ----- Plotting ----- %
% figure(102);
% imshow( up_video.BlackKeys_Mask | up_video.WhiteKeys_Mask );
% hold on;
% scatter( up_video.ALLKeys_centerCoord(:,1), ...
%          up_video.ALLKeys_centerCoord(:,2), ...
%          40, 'o', 'r', 'filled' );

%% ----- Cleaning Workspace ----- %

clear props centroids centr
clear upper_extrema bottom_extrema

