
I = front_video.WhiteKeys_Mask;
BW = bwperim(I);

%%

[H,theta,rho] = hough(BW,'Theta',-90:0.5:-75, 'RhoResolution', 1);

P  = houghpeaks(H,1,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(BW,theta,rho,P,'MinLength', 40);

% x = theta(P(:,2)); y = rho(P(:,1));
% plot(x,y,'s','color','white');

%% HardCode Selection of 'White Key Ending' lines

% order lines by mean of rho value

rho = [lines.rho]';
[~, ind] = sortrows(rho, 'ascend');
lines = lines(ind);

point1 = [lines(1).point1, 1];
point2 = [lines(end).point2, 1];


front_geometric_features.horiz_whiteKey_line = ...
               homog_cross(point1, point2);


%% Plotting
% figure(1); imshow(front_video.WhiteKeys_Mask); hold on
% plot_homog_line(horiz_whiteKey_line, [1,1920])

%% Clear Workspace

clear BW I
clear H P rho theta
clear a b coeff x y xy
clear k max_len
clear lines point1 point2 l
clear ind