close all
clear
clc

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

FrontKey_Shape_Extraction


Front_KBD_Mask

%% ----- Routine -----
ii = 1;


%% %{
while ~isDone(sysObjs.Front_VideoReader)
   
   frame = sysObjs.Front_VideoReader.step();
   
   hands = FRONT_skin_segmentation(frame);
  
   
   % Enlightening only fingers [part] that are over the KeyBoard
   on_KBD_Hand = im2double(hands) .* front_video.Complete_KBD_Mask;
   
   fingers_extremities = fingersExtremities(rgb2gray(on_KBD_Hand));
   
   % Finger Tip is the lowest point of each "Blob"
   finger_tips = reshape( ...
      permute( fingers_extremities(2,:,:), [3,1,2] ), ...
      size(fingers_extremities,3), ...
      [] ...
   );
   
   marked_frame = add_Marker_to_frame(frame, finger_tips);
   sysObjs.videoFileWriter.step(marked_frame);

   ii = ii+1;
end


%%

releaseSystemObjects(sysObjs)