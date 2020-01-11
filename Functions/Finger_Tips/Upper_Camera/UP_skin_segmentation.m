function out = UP_skin_segmentation(frame)
%UP_skin_segmentation removes useless details from frame returning an image
%where only skin is enlightened.
%Computation is done by checking at RGB and HVS frame values.
%
%
% OUTPUTS:
%    * out - RGB containing only segmented hands. Useless details are make
%    BLACK ([0,0,0] RGB Value)
%
%
% INPUT:
%   * frame - RGB Frame


mask_rgb = frame(:,:,1) > 130 & frame(:,:,1) < 195 ...
            & frame(:,:,2) > 62 & frame(:,:,2) < 108 ...
            & frame(:,:,3) > 45 & frame(:,:,3) < 80;

maxMin = max(frame, [], 3) - min(frame, [], 3);
maxMin = maxMin > 65;
mask_rgb = mask_rgb & maxMin;

mask_rgb = imfill(mask_rgb, 'holes');


% --- hsv improving --- %

hsv_frame = rgb2hsv(frame);

sat = hsv_frame(:,:,2) > 0.56 & hsv_frame(:,:,2) < 0.75;
hue = hsv_frame(:,:,3) > 0.57 & hsv_frame(:,:,3) < 0.775;
mask_hsv = sat & hue;

mask = mask_rgb & mask_hsv;

mask = imfill(mask, 'holes');
mask = imerode(mask, strel('diamond', 1));
mask = bwareaopen(mask, 400);

out = im2double(frame) .* mask;

% imshow(out)

end