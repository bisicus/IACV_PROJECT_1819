function [ WHT_pressed_idxs, ...
           BLK_pressed_idxs ] = Check_Pressed( Z_Front, ...
                                               Z_Up, ...
                                               angle, BLK_height, ...
                                               Up_Tips, ...
                                               up_video_struct, ...
                                               camera_struct )
%CHECK_PRESSED Summary of this function goes here
%   Detailed explanation goes here

   % Define Fuzzy thresholds;
   WHT_Thresh = -2.5;
   
   BLK_Thresh = BLK_height*0.975;
   dist_from_centroid_thresh = [ ...
         camera_struct.BLACK_Key_WIDTH / 2.5; ...
         camera_struct.BLACK_Key_LEN / 3
   ];
   
   
   % ===== Check White Pressed ===== %
   WHT_pressed_idxs = find( Z_Up - Z_Front > WHT_Thresh);
   
   
   
   % ===== Check Black Pressed ===== %
   
   % 1. Real World Finger Height
   base = abs( Z_Front - Z_Up );
   height = base * tan(angle);
   
   
   % 2. Fingers that are really over Black Keys
   [~ , dists_x] = find_nearest_idxs( up_video_struct.BLACK_Keys_centerCoord, ...
                                      Up_Tips, ...
                                      1, ...
                                      'method', 'only_x' );
                                 
   [~ , dists_y] = find_nearest_idxs( up_video_struct.BLACK_Keys_centerCoord, ...
                                      Up_Tips, ...
                                      1, ...
                                      'method', 'only_y' );
         
   
   BLK_pressed_idxs = find( height  < BLK_Thresh & ... % Basic condition
                            dists_x < dist_from_centroid_thresh(1) & ...
                            dists_y < dist_from_centroid_thresh(2) );
   
   
   % 3. Remove 'Pressed White Keys' from input Coordinates, if any
   BLK_pressed_idxs = setdiff(BLK_pressed_idxs, WHT_pressed_idxs);
  
   
end

