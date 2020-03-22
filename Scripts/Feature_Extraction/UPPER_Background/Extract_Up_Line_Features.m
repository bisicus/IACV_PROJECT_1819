I = up_video.WhiteKeys_Mask;
BW = bwperim(I);

%% Horizontal Lines
% Note: theta is the angle between houghline and horizontal axis, so in
% order to catch bins belonging to horizontal lines there's need to set
% theta value near 90°
% 
[Hough_matrix,Theta,Rho] = hough(BW,'Theta',80:0.5:89, 'RhoResolution', 1);

Peaks  = houghpeaks(Hough_matrix,5, ...
               'threshold',ceil(0.3*max(Hough_matrix(:))) ...
   );

lines = houghlines( BW, Theta, Rho, Peaks, ...
                   'FillGap', 103 );


%% Lines Ordering
% Lines are Sorted by distance w.r.t. Coordinate System Origin that is on
% Top-Left Corner

lines = sort_HoughLine_data(lines, 'rho', 'sort_direction', 'ascend');


%% Saving for further computations

up_geometric_features.keys_start_line = ...
               HoughLine_to_homog(lines(1));
            
up_geometric_features.blackKey_end_line = ...
               HoughLine_to_homog(lines(2));
            
up_geometric_features.whiteKey_end_line = ...
               HoughLine_to_homog(lines(3));

 
            
      %% ===== Plotting ===== %
      
if plot_graphs == 1
   figure(1007)
   imshow( Hough_matrix, [], 'XData', Theta, ...
           'YData', Rho, 'InitialMagnification', 'fit' );
   xlabel('\theta'), ylabel('\rho');
   
   axis on, axis normal, hold on;
   
   x = Theta( Peaks(:,2) );
   y = Rho( Peaks(:,1) );
   plot(x,y,'s','color','white');
   
   hold off
   
end


if show_figures == 1
   figure(1008); imshow(up_video.background); hold on
   title( 'Horizontal Keyboard Lines' )
   plot_hough_lines(lines)
   hold off;
end

%% Clear Workspace

clear BW I
clear Hough_matrix Peaks Rho Theta
clear lines
            

