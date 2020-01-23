function [WHT_pressed_idxs, BLK_pressed_idxs] = ...
                  Check_Pressed( Z_Front, Z_Up, ...
                                 angle, BLK_height, ...
                                 Up_Tips, ...
                                 up_video_struct, ...
                                 camera_struct)
%CHECK_PRESSED Summary of this function goes here
%   Detailed explanation goes here

   % ===== Check White Pressed ===== %
   WHT_pressed_idxs = find( Z_Up > Z_Front);
   
   
   
   % ===== Check Black Pressed ===== %
   
   % 1. Real World Finger Height
   base = abs( Z_Front - Z_Up );
   height = base / tan(angle);
   
   
   % 2. Fingers that are really over Black Keys
   [~ , dists] = find_nearest_idxs( up_video_struct.BLACK_Keys_centerCoord, ...
                                    Up_Tips, ...
                                    1, ...
                                    'method', 'only_x' );
   
   BLK_pressed_idxs = find( dists < camera_struct.BLACK_Key_WIDTH *(2/3) & ...
                            height < BLK_height );
   
   
   % 3. Remove 'Pressed White Keys' from input Coordinates, if any
   BLK_pressed_idxs = setdiff(BLK_pressed_idxs, WHT_pressed_idxs);
  
   
end

