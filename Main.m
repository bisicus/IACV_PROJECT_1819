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

%% ----- Routine -----
ii = 1;
KBD_Mask = imdilate( ...
        front_video.BlackKeys_Mask | front_video.WhiteKeys_Mask,...
        strel('line', 15, -1.5)...
);

%% %{
while ~isDone(sysObjs.Front_VideoReader)
   
   frame = sysObjs.Front_VideoReader.step();
   
   hands = FRONT_skin_segmentation(frame);
  
   
   masked = im2double(hands) .* KBD_Mask;
   sysObjs.videoFileWriter.step(masked);
   
   ii = ii+1;
end


%%

releaseSystemObjects(sysObjs)