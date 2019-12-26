function releaseSystemObjects(obj)
   release(obj.Front_VideoReader);
   release(obj.Front_BackgroundReader);
   
   release(obj.Upper_VideoReader);
   release(obj.Upper_BackgroundReader);
   
   release(obj.videoFileWriter);
end