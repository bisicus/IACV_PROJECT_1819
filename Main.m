                                                                                                                                                                                                                 
close all
clear
clc

%{ 
   IMPORTANT NOTES: 
   1) All Homogeneous Vectors that will be computed during
   this script will be in the form of a ROW Vector
         [x, y, 1]
   This is due the fact that MATLAB's plotting function requires that, in
   case of plotting more points, [x,y] coordinates can be stacked together
   
%}

%%                   ---- Folder Inclusion -----

addpath(genpath('Scripts'));
addpath(genpath('Functions'));
addpath(genpath('Videos'));


%%                   ---- Plotting Option -----

show_figures = 1;
plot_graphs = 1;

%%                   ---- Preparing Steps ----- 


            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % --------------------------- %
            % -----  SYSTEM OJBECTS ----- %
            % -----  INITIALIZATION ----- %
            % --------------------------- %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
front_video.videoPath = '/Videos/SweetDreams/Front/SweetDreams_Synchro_Front.mp4';
front_video.backgroudPath = '/Videos/SweetDreams/Front/Background_Front.mp4';

up_video.videoPath = '/Videos/SweetDreams/Up/SweetDreams_Synchro_Up.mp4';
up_video.backgroudPath = '/Videos/SweetDreams/Up/Background_UP.mp4';

sysObjs = initSystemObjects(...
         front_video.videoPath, front_video.backgroudPath, ...
         up_video.videoPath, up_video.backgroudPath ...
);

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % ----------------------------------- %
            % -----  BACKGROUNDS DETECTION  ----- %
            % ----------------------------------- %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


front_video.background = ...
      backgroundDetection(sysObjs.Front_BackgroundReader, 50);
      
up_video.background = ...
      backgroundDetection(sysObjs.Upper_BackgroundReader, 50);
   
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % ---------------------------------- %
            % -----  BACKGROUNDS FEATURES  ----- %
            % ----------- EXTRACTION ----------- %
            % ---------------------------------- %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               
               % ----- FRONT BACKGROUND ----- %

% Video Features
Extract_Front_Keys_Mask
Extract_Front_Centroids

% Geometric Features
Extract_Front_vanishing_point
Extract_Front_WhiteKeys_line
Extract_Front_blackKeys_line


               % ----- UPPER BACKGROUND ----- %

% Video Features
Extract_Up_Keys_Mask
Extract_Up_Centroids
Extract_Up_Line_Features



            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % ------------------------------- %
            % -----   HARDCODING KNOWN  ----- %
            % -----  WORLD MEASUREMENTS ----- %
            % ------------------------------- %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
Hardcode_Real_World_Measurements
Compute_Up_Pixel_Centimeter_Ratio
Metric_to_Pixel

%% ----- Routine -----
sysObjs.frame_counter = 0;

prev_BLK_coords = {[]; []; []; []}; % TODO: spostare sopra
prev_WHT_coords = {[]; []; []; []}; % TODO: spostare sopra

while ~isDone(sysObjs.Front_VideoReader) ...
      && ~isDone(sysObjs.Upper_VideoReader)
   
   % ----- FRONT VIDEO PROCESSING ----- %
   FRONT_frame = sysObjs.Front_VideoReader.step();
   FRONT_tips = FRONT_Finger_tips(FRONT_frame, front_video.HandsOnKBD_Mask);
   
   
   % ----- UPPER VIDEO PROCESSING ----- %
   UP_frame = sysObjs.Upper_VideoReader.step();
   UP_tips = UP_Finger_tips(UP_frame, up_video.HandsOnKBD_Mask);
   
   
   % ----- TIPS MATCHING ----- %
   matched_tips = match_UpFront_tips(FRONT_tips, UP_tips, ....
                                    front_video, up_video, ...
                                    front_geometric_features);
                                 
   
   % ----- TIPS TO WORLD CONVERSION ----- %
   % separate matched tips
   FRONT_tips = permute( matched_tips(1, :,:), [3,2,1] );
   UP_tips = permute( matched_tips(2, :,:), [3,2,1] );

   Z_Front = FRONT_Tips2World( FRONT_tips, front_geometric_features, WORLD_Measures );
   Z_Up    = UP_Tips2World( UP_tips, up_geometric_features, WORLD_Measures );
   
   [ WHT_pressed_idxs_CANDIDATE, ...
     BLK_pressed_idxs_CANDIDATE ] = Check_Pressed( Z_Front, ...
                                                   Z_Up, ...
                                                   WORLD_Measures.Front_Cam.ANGLE_avg, ...
                                                   WORLD_Measures.KBD_internals.Only_BLACK_Portion_HEIGHT, ...
                                                   UP_tips, ...
                                                   up_video, ...
                                                   Camera_Measures);
   
                                                
   % ----- Comparison With Previous Frames ----- %
   % BLACK
   [ ~, BLK_pressed_data ] = compare_on_prev_frames( FRONT_tips(BLK_pressed_idxs_CANDIDATE, :), ...
                                                     prev_BLK_coords, ...
                                                     Camera_Measures.BLACK_Key_WIDTH/3, ...
                                                     2, ...
                                                     Camera_Measures.BLACK_Key_LEN/3);
   
   if ~isempty(BLK_pressed_data)
      [~, BLK_pressed_idxs] = ismember(BLK_pressed_data, FRONT_tips, 'rows');
   else
      BLK_pressed_idxs = [];
   end
   
   
   % WHITE
   [ ~, WHT_pressed_data ] = compare_on_prev_frames( FRONT_tips(WHT_pressed_idxs_CANDIDATE, :), ...
                                                     prev_WHT_coords, ...
                                                     Camera_Measures.WHITE_Key_WIDTH/3, ...
                                                     2 );
   
   if ~isempty(WHT_pressed_data)
      [~, WHT_pressed_idxs] = ismember(WHT_pressed_data, FRONT_tips, 'rows');
   else
      WHT_pressed_idxs = [];
   end
   
   
   % ----- Update Frame History Structure ----- %
   prev_BLK_coords = queue_circular_shift(prev_BLK_coords, FRONT_tips(BLK_pressed_idxs_CANDIDATE,:));
   
   prev_WHT_coords = queue_circular_shift(prev_WHT_coords, FRONT_tips(WHT_pressed_idxs_CANDIDATE,:));
   
   
   % ----- Plotting ------ %
   if ~isempty(WHT_pressed_idxs)
      disp([ 'frame: ' num2str(sysObjs.frame_counter) ...
             ' WHITE pressed: [' num2str(WHT_pressed_idxs(:).') ']' ]);
      FRONT_frame = add_Marker_to_frame(FRONT_frame, FRONT_tips(WHT_pressed_idxs, :), 'blue');
      UP_frame = add_Marker_to_frame(UP_frame, UP_tips(WHT_pressed_idxs, :), 'blue');
      
      prev_WHT_coords = remove_from_queue( prev_WHT_coords, ...
                                           FRONT_tips(WHT_pressed_idxs,:), ...
                                           Camera_Measures.WHITE_Key_WIDTH/3 );
   end
   
   if ~isempty(BLK_pressed_idxs)
      disp([ 'frame: ' num2str(sysObjs.frame_counter) ...
             ' BLACK pressed: [' num2str(BLK_pressed_idxs(:).') ']' ]);
      FRONT_frame = add_Marker_to_frame(FRONT_frame, FRONT_tips(BLK_pressed_idxs, :), 'green');
      UP_frame = add_Marker_to_frame(UP_frame, UP_tips(BLK_pressed_idxs, :), 'green');
      
      prev_BLK_coords = remove_from_queue( prev_BLK_coords, ...
                                           FRONT_tips(BLK_pressed_idxs,:), ...
                                           Camera_Measures.BLACK_Key_WIDTH/3 );
   end
%   
   img = montage( {FRONT_frame, UP_frame} , 'Size', [2,1],...
                  'BorderSize', [140,180], 'BackgroundColor', 'white',...
                  'ThumbnailSize', [1080, 1920] );
   
   sysObjs.videoFileWriter.step( img.CData );

   
   sysObjs.frame_counter = sysObjs.frame_counter + 1;
end


%%

releaseSystemObjects(sysObjs)

%% Cleaning Workspace

clear UP_frame FRONT_frame
clear prev_BLK_coords prev_WHT_coords
clear UP_Finger_tips U_Tips UP_tips FRONT_tips F_Tips
clear WHT_pressed_data WHT_pressed_idxs WHT_pressed_idxs_CANDIDATE
clear BLK_pressed_data BLK_pressed_idxs BLK_pressed_idxs_CANDIDATE
clear matched_tips
clear Z_Front Z_Up
clear img