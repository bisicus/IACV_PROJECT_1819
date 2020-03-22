function avg_hough_lines = avg_near_lines(hough_lines)
%AVG_NEAR_LINES Summary of this function goes here
%   Detailed explanation goes here

% Constants for code readability
columns_dir = 1;

% ===== 1. Group points 

p1 = vertcat(hough_lines.point1);
x_p1 = p1(:,1);

[labels, n_labels] = bwlabel( abs( x_p1 - x_p1' ) < 5 , 4 );
labels = max(labels, [], 2);

for ii = 1:n_labels
   sub_data = hough_lines( labels == ii );
   
   %TODO: mean and create a new struct
   %Cannot use accumarray
   avg_hough_lines(ii).point1 = mean( vertcat(sub_data.point1), ...
                                      columns_dir );
   
   avg_hough_lines(ii).point2 = mean( vertcat(sub_data.point2), ...
                                      columns_dir );
   
   avg_hough_lines(ii).theta = mean( vertcat(sub_data.theta), ...
                                      columns_dir );
   
   avg_hough_lines(ii).rho = mean( vertcat(sub_data.rho), ...
                                      columns_dir );
   
end
end

