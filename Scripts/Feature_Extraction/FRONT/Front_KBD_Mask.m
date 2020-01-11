
KBD_Mask = front_video.BlackKeys_Mask | front_video.WhiteKeys_Mask;
KBD_Mask = bwareaopen(KBD_Mask, 150);

%%
s1 = strel('line', 15, -1.5);
s2 = strel('rectangle', [30, 1]);

front_video.Complete_KBD_Mask = imdilate( ...
        KBD_Mask, [s1, s2]...
);

%%
clear KBD_Mask s1 s2