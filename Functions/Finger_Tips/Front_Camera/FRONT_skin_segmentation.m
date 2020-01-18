function out = FRONT_skin_segmentation(frame)
%FRONT_skin_segmentation removes useless details from frame returning an
%image where only skin is enlightened.
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

mask_rgb = frame(:,:,1) > 175 & frame(:,:,1) < 235 ...
            & frame(:,:,2) > 85 & frame(:,:,2) < 165 ...
            & frame(:,:,3) > 65 & frame(:,:,3) < 140;

maxMin = max(frame, [], 3) - min(frame, [], 3);
maxMin = maxMin > 80;

mask_rgb = mask_rgb & maxMin;

mask_rgb = imfill(mask_rgb, 'holes');
mask_rgb = imerode(mask_rgb, strel('diamond', 1));

% hsv improving

hsv_frame = rgb2hsv(frame);
% 
mask_hsv = hsv_frame(:,:,1) < 0.0565 ...
            & hsv_frame(:,:,2) > 0.375 & hsv_frame(:,:,2) < 0.65 ...
            & hsv_frame(:,:,3) > 0.675 & hsv_frame(:,:,3) < 0.9 ;

mask_hsv = imfill(mask_hsv, 'holes');
mask_hsv = imerode(mask_hsv, strel('diamond', 1));

% imshow(mask_hsv)
mask = mask_rgb & mask_hsv;

mask = bwareaopen(mask, 200);
mask = imfill(mask, 'holes');
% mask = imerode(mask, strel('diamond', 1));

out = im2double(frame) .* mask;

% figure(10); imshow(out);

end