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
   
   
   marked_frame = add_Marker_to_frame(frame, Front_finger_tips);
   sysObjs.videoFileWriter.step(marked_frame);

   ii = ii+1;
end


%%

releaseSystemObjects(sysObjs)