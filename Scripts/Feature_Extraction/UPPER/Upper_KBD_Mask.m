
KBD_Mask = up_video.BlackKeys_Mask | up_video.WhiteKeys_Mask;

KBD_Mask = bwareaopen(KBD_Mask, 1000);

%%
KBD_Mask = imdilate( ...
        KBD_Mask, strel('line', 10, 5)...
);

front_video.Complete_KBD_Mask = imfill(KBD_Mask, 'holes');

%%
clear KBD_Mask