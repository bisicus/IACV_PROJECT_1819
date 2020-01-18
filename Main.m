
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
FrontKey_Shape_Extraction
Front_KBD_Mask

% Geometric Features
Front_vanishing_point
Front_WhiteKeys_line
Front_blackKeys_line

               % ----- UPPER BACKGROUND ----- %

% Video Features
UpperKey_Shape_Extraction
Upper_KBD_Mask
Upper_Line_Features



            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % ------------------------------- %
            % -----   HARDCODING KNOWN  ----- %
            % -----  WORLD MEASUREMENTS ----- %
            % ------------------------------- %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
Real_World_Measurements
Up_Pixel_Centimeter_Relation

%% ----- Routine -----
ii = 1;
plot = 1;

while ~isDone(sysObjs.Front_VideoReader) ...
      && ~isDone(sysObjs.Upper_VideoReader)
   
   % ----- FRONT VIDEO PROCESSING ----- %
   FRONT_frame = sysObjs.Front_VideoReader.step();
   FRONT_tips = FRONT_Finger_tips(FRONT_frame, front_video.Complete_KBD_Mask);
   
   
   % ----- UPPER VIDEO PROCESSING ----- %
   UP_frame = sysObjs.Upper_VideoReader.step();
   UP_tips = UP_Finger_tips(UP_frame);
   
   
   % ----- TIPS MATCHING ----- %
   matched_tips = match_UpFront_tips(FRONT_tips, UP_tips, ....
                                    front_video, up_video, ...
                                    front_geometric_features);
                                 
%   f_matched = permute( matched_tips(1, :,:), [3,2,1] );
%   figure(1); imshow(FRONT_frame); hold on
%   scatter( f_matched(:,1), f_matched(:,2), 80, [1:1:length(f_matched(:,1))], 'filled' )
%   
%   u_matched = permute( matched_tips(2, :,:), [3,2,1] );
%   figure(2); imshow(UP_frame); hold on
%   scatter( u_matched(:,1), u_matched(:,2), 80, [1:1:length(u_matched(:,1))], 'filled' )
   
   
   % ----- TIPS TO WORLD CONVERSION ----- %
%    [X_Coord, Z_Coord] = FRONT_Tips2World( FRONT_tips, front_geometric_features );
   
   if plot
      FRONT_frame = add_Marker_to_frame(FRONT_frame, FRONT_tips);
      UP_frame = add_Marker_to_frame(UP_frame, UP_tips);
%       sysObjs.videoFileWriter.step( ... );
   end
   
   ii = ii+1;
end


%%

releaseSystemObjects(sysObjs)