function [out] = FRONT_skin_segmentation(frame)

mask_rgb = frame(:,:,1) > 120 & frame(:,:,2) > 70 & frame(:,:,3) > 55;

% figure(1); imshow(mask_rgb)
maxMin = max(frame, [], 3) - min(frame, [], 3);
maxMin = maxMin > 80;
% figure(2); imshow(maxMin)

mask_rgb = mask_rgb & maxMin;
% figure(3); imshow(mask_rgb)

mask_rgb = imfill(mask_rgb, 'holes');
mask_rgb = imerode(mask_rgb, strel('diamond', 1));

% hsv improving

hsv_frame = rgb2hsv(frame);
% 
mask_hsv = hsv_frame(:,:,2) < 0.65 ...
            & hsv_frame(:,:,3)>0.62 ...
            & hsv_frame(:,:,1)<0.055;

% imshow(mask_hsv)
mask = mask_rgb & mask_hsv;

mask = bwareaopen(mask, 200);
mask = imfill(mask, 'holes');
% mask = imerode(mask, strel('diamond', 1));

out = im2double(frame) .* mask;

out = im2uint8(out);

end