
I = front_video.WhiteKeys_Mask;
BW = bwperim(I);

%%

[Hough_matrix,Theta,Rho] = hough(BW,'Theta',-90:0.5:-75, 'RhoResolution', 1);

Peaks  = houghpeaks(Hough_matrix,1,'threshold',ceil(0.3*max(Hough_matrix(:))));
lines = houghlines(BW, Theta, Rho, Peaks, 'MinLength', 40);

% x = theta(P(:,2)); y = rho(P(:,1));
% plot(x,y,'s','color','white');

%% HardCode Selection of 'White Key Ending' lines

% order lines by mean of rho value

lines = sort_HoughLine_data(lines, 'point', 'sort_direction', 'ascend');
point1 = [lines(1).point1, 1];
point2 = [lines(end).point2, 1];


front_geometric_features.horiz_whiteKey_line = ...
               homog_cross(point1, point2);


%% Plotting
if show_figures == 1
   
   figure(1005); imshow(BW); hold on
   title( 'White Keys finishing Line' )
   plot_homog_line(front_geometric_features.horiz_whiteKey_line, [1,1920])
   
   % Plot computed Hough lines
   plot_hough_lines(lines)
   
   % Scatter point used for Line Computation
   scatter(point1(1), point1(2), 80, 'white', 'o', 'filled')
   scatter(point2(1), point2(2), 80, 'white', 'o', 'filled')
   

end
%% Clear Workspace

clear BW I
clear Hough_matrix Peaks Rho Theta
clear lines point1 point2 l