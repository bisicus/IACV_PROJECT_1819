
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
%% Folder Inclusion

addpath(genpath('Scripts'));
addpath(genpath('Functions'));
addpath(genpath('Videos'));

%%                   ---- Preparing Steps ----- 

front_video.videoPath = '/Videos/SweetDreams/Front/SweetDreams_Synchro_Front.mp4';
front_video.backgroudPath = '/Videos/SweetDreams/Front/Background_Front.mp4';

up_video.videoPath = '/Videos/SweetDreams/Up/SweetDreams_Synchro_Up.mp4';
up_video.backgroudPath = '/Videos/SweetDreams/Up/Background_UP.mp4';

sysObjs = initSystemObjects(...
         front_video.videoPath, front_video.backgroudPath, ...
         up_video.videoPath, up_video.backgroudPath ...
);

         % ----- Background Detection ----- %

front_video.background = backgroundDetection(sysObjs.Front_BackgroundReader, 50);

         % ----- Background Features Extraction ----- %

% Video Features
FrontKey_Shape_Extraction
Front_KBD_Mask

% Geometric Features
Front_vanishing_point
Front_WhiteKeys_line
Front_blackKeys_line


%% ----- Routine -----
ii = 1;


%% %{
while ~isDone(sysObjs.Front_VideoReader)
   
   frame = sysObjs.Front_VideoReader.step();
   
   hands = FRONT_skin_segmentation(frame);
  
   
   Front_finger_tips = Finger_Tips(hands, front_video.Complete_KBD_Mask);
   % just for plotting
   marked_frame = add_Marker_to_frame(frame, Front_finger_tips);
   
   %{
      Computation of Real World Coordinates of Finger Tips
      PROCEDURE for each Finger Tip:
      1) CrossRatio Elements Computation
         - Computation of 'line to the horizon' passing through Tip and 
           Vanishing Point
         - B Point, intersection of 'horizon line' and 'Black Keys
           Termination' line
         - W Point, intersection of 'horizon line' and 'White Keys
           Termination' line
      2) Computing CrossRatio for T, B, W, Vp
      3) Using Cr quantity to Compute World Coordinates
         - TODO:
   
   %}
   
   for kk = 1:size(Front_finger_tips, 1)
      T = [ Front_finger_tips(kk, :), 1 ];
      
      horizon_line = homog_cross(T, front_geometric_features.vanish_point);
      B = homog_cross(horizon_line, front_geometric_features.horiz_BlackKey_line);
      W = homog_cross(horizon_line, front_geometric_features.horiz_whiteKey_line);
      
      %{
         Point order is fixed so that hardcoded 'real-world known properies'
         can be used.
         Points are loaded in the same order in which they could be
         encountered by going from camera to Vanishing Point:
         T, B, W, 
      %}
      
      C_r = cross_ratio(T, B, W, front_geometric_features.vanish_point);
   end
   sysObjs.videoFileWriter.step(marked_frame);

   ii = ii+1;
end


%%

releaseSystemObjects(sysObjs)