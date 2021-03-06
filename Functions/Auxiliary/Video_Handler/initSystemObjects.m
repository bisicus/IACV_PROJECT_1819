function obj = initSystemObjects(...
         front_video_path, front_background_path, ...
         up_video_path, up_background_path )
   
   % ----- FRONT VIDEO OBJECT ----- %
   obj.Front_VideoReader = vision.VideoFileReader(...
         front_video_path, ...
         'ImageColorSpace','RGB',...
         'VideoOutputDataType','uint8'...
   );

   obj.Front_BackgroundReader = vision.VideoFileReader(...
         front_background_path, ...
         'ImageColorSpace','RGB',...
         'VideoOutputDataType','uint8'...
   );

   % ----- UPPER VIDEO OBJECT ----- %
   obj.Upper_VideoReader = vision.VideoFileReader(...
         up_video_path, ...
         'ImageColorSpace','RGB',...
         'VideoOutputDataType','uint8'...
   );

   obj.Upper_BackgroundReader = vision.VideoFileReader(...
         up_background_path, ...
         'ImageColorSpace','RGB',...
         'VideoOutputDataType','uint8'...
   );
   
   % ----- FRAME COUNTER ----- %
   obj.frame_counter = 0;
   
   % ----- VIDEO PLAYER ----- %
   % play Original Video
%    obj.videoPlayer = vision.VideoPlayer(...
%          'Name', 'Original Video'...
%    );
%    
%    % play Tracking Results
%    obj.trackPlayer = vision.VideoPlayer(...
%          'Name', 'Extracted Hands'...
%    );

   % ----- VIDEO WRITER ----- %
   obj.videoFileWriter = vision.VideoFileWriter(...
         'Filename', 'Results.mp4',...
         'FileFormat', 'MPEG4',...
         'FrameRate', 2 ...
   );

   % ----- RADIUS OF ADDED CIRCLES FOR 'PRESSED KEY' FRAMES ----- %
   obj.circleRadius = 17;
   
   
end