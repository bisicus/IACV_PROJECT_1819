function background = backgroundDetection(videoReader, numFrames)
%BACKGROUNDDETECTION Extracts Background from the first 'static frames' of a video
%   Median filter of 'numFrames' frames representing the static
%   background. 
%   
%   Input 'videoSource' is a RGB video and each frame must be of
%   'uint8' type while numFrames is a non Negative integer.

framesToMed = videoReader.step();
ii = 2;

while ~isDone(videoReader) && ii <= numFrames
  
   frame = videoReader();
   framesToMed = cat(4, framesToMed, frame);
   
   ii = ii + 1;
end

background = median(framesToMed , 4);

end
