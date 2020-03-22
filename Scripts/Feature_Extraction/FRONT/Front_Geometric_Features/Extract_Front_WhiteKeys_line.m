
I = front_video.WhiteKeys_Mask;
BW = bwperim(I);

%%

[Hough_matrix,Theta,Rho] = hough(BW, 'Theta', -90:0.5:-75, 'RhoResolution', 1);

Peaks = houghpeaks(Hough_matrix, 1, 'threshold', ceil(0.3*max(Hough_matrix(:))) );
lines = houghlines(BW, Theta, Rho, Peaks, 'MinLength', 40);

% x = theta(P(:,2)); y = rho(P(:,1));
% plot(x,y,'s','color','white');

%% Lines Interpolation

% order lines by mean of rho value
lines = sort_HoughLine_data(lines, 'point', 'sort_direction', 'ascend');

to_combine = zeros(length(lines), 3);
for ii = 1:length(lines)
   to_combine(ii, :) = HoughLine_to_homog(lines(ii));
end

front_geometric_features.horiz_whiteKey_line = mean(to_combine, 1);


%% Plotting
if show_figures == 1
   
   figure(1005); imshow(front_video.background); hold on
   title( 'White Keys finishing Line' );
   
   plot_homog_line(front_geometric_features.horiz_whiteKey_line, [1,1920]);
   
   % Plot computed Hough lines
   plot_hough_lines(lines, 'color', 'green');

end
%% Clear Workspace

clear BW I
clear Hough_matrix Peaks Rho Theta
clear lines hom