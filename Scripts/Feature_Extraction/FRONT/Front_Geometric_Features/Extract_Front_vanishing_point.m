I = front_video.WhiteKeys_Mask;
BW = bwperim(I);

%% Hough Lines

[Hough_matrix, Theta, Rho] = hough(BW, 'Theta', -45:0.5:45, 'RhoResolution', 1);

Peaks  = houghpeaks(Hough_matrix,80,'threshold',ceil(0.3*max(Hough_matrix(:))));
lines = houghlines(BW, Theta, Rho, Peaks, 'MinLength', 40);


lines = sort_HoughLine_data(lines, 'point', 'sort_direction', 'ascend');
lines_filtered = avg_near_lines(lines);

%% Hardcode selection lines
%{
   Due to noise identified lines are unstable and will not match
   prefectly keys borders.
   Tilting effect will burst for vertical lines having their theta value
   swing near zero assuming both positive and negative values.

   Since vanishing point will be computed by mean of cross products
   vertical lines represents a prominent threat to future operations;
   therefore they have to be deleted.
%}

lines_filtered = lines_filtered( ...
         ( [lines_filtered.theta] > -40 & [lines_filtered.theta] < -15) | ...
         ( [lines_filtered.theta] > 15  & [lines_filtered.theta] < 30 )   ...
);


%% Divide Theta array w.r.t vertical simmetry axis on image

lines_left  = lines_filtered( [lines_filtered.theta] > 0 );

lines_right = lines_filtered( [lines_filtered.theta] < 0 );


%% Find Vanishing Point:
%{
    in order to mitigate distortion introduced by camera, beacuse of which
    "white keys" horizontal line appears 'curve' all left_lines are 
    intersect with all right lines in order to obtain candidates 'vanishing
    points'.
    All points will be averaged giving single vanishing point
%}

% pre-allocation for speed
vanish_points = zeros(...
      length(lines_left) * length(lines_right),...
      3 ...
);

ii = 1;
for kk = 1:length(lines_left)

   l1 = HoughLine_to_homog( lines_left(kk) );

   for jj = 1:length(lines_right)

      l2 = HoughLine_to_homog( lines_right(jj) );

      vp = homog_cross(l1,l2);

      % Comping storage index
%       storage_idx = (ii-1) * length(lines_right) + jj;

      vanish_points(ii, :) = vp;
      
      ii = ii + 1;

   end
end

%% Center of Mass

front_geometric_features.vanish_point = mean(vanish_points, 1);

      
      
      %% ===== Plotting ===== %
      
if plot_graphs == 1
   figure(1000)
   imshow(Hough_matrix, [] ,'XData', Theta, ...
           'YData', Rho, 'InitialMagnification','fit');
   title('Hough Peaks')
   xlabel('\theta'), ylabel('\rho');
   
   axis on, axis normal, hold on;
   x = Theta( Peaks(:,2) );
   y = Rho( Peaks(:,1) );
   plot(x,y,'s','color','white');
   
   hold off;
end


if show_figures == 1
   
   % 1. Plot ALL Hough Lines
   
   figure(1001); imshow(BW); hold on
   title( 'Computed Hough Lines')
   plot_hough_lines(lines)
   hold off;
   
   % ------------ %
   
   % 2. Plot Filtered Hough Lines
   
   figure(1002); imshow(BW); hold on
   title( 'Filtered Hough Lines')
   plot_hough_lines(lines_filtered)
   hold off;
   
   
   % ------------ %
   
   % 3. scatter Vanishing Points
   
   figure(1003); imshow(BW); hold on
   title( 'Computed Vanishing Point')
   
   ii = 1;
   for kk = 1:length(lines_left)
      xy_1 = [lines_left(kk).point1; lines_left(kk).point2];
      plot(xy_1(:,1), xy_1(:,2), 'LineWidth',2,'Color','green');
      
      for jj = 1:length(lines_right)
         xy_2 = [lines_right(jj).point1; lines_right(jj).point2];
         plot(xy_2(:,1), xy_2(:,2), 'LineWidth', 2, 'Color', 'green');

         vp = vanish_points(ii, [1,2]);
         plot([xy_1(1,1), vp(1)], [xy_1(1,2), vp(2)], 'LineWidth',2,'Color','cyan');
         scatter(xy_1(1,1), xy_1(1,2), 40, 'o', 'red', 'filled')
         
         plot([xy_2(1,1), vp(1)], [xy_2(1,2), vp(2)], 'LineWidth',2,'Color','cyan');
         scatter(xy_2(1,1), xy_2(1,2), 40, 'o', 'red', 'filled')
         
         scatter(vp(1), vp(2), 30, 'square', 'red', 'filled')
         
         ii = ii + 1;

         scatter( front_geometric_features.vanish_point(1), ...
                  front_geometric_features.vanish_point(2), ...
                  100, 'diamond', 'black', 'filled')
      end
      
   end
   hold off;
   
   
   % 4. Scatter Vanishing Point versus Original Background
   figure(1004); imshow(front_video.background); hold on
   title( 'Computed Vanishing Point')
   for kk = 1:length(lines_filtered)
      xy = [lines_filtered(kk).point1; front_geometric_features.vanish_point(1:2)];
      plot(xy(:,1),xy(:,2),'LineWidth',3,'Color','green');

      % Plot beginnings and ends of lines
      scatter(xy(1,1),xy(1,2), 60,'o', 'cyan', 'filled');
      scatter(xy(2,1),xy(2,2), 80,'diamond', 'black', 'filled');
      
   end
   hold off;
   
end


%% Cleaning Workspace

clear Hough_matrix Peaks Rho Theta x y
clear BW I
clear xy xy_1 xy_2
clear ii jj kk l1 l2 p1 p2 t1 t2
clear theta ind del_idx max_ind point1
clear lines lines_left lines_right lines_filtered
clear vp vanish_points