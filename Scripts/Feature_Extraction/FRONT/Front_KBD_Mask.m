
KBD_Mask = front_video.BlackKeys_Mask | front_video.WhiteKeys_Mask;
KBD_Mask = bwareaopen(KBD_Mask, 150);

%%
front_video.Complete_KBD_Mask = imdilate( ...
        KBD_Mask, strel('line', 15, -1.5)...
);

%%
clear KBD_Mask