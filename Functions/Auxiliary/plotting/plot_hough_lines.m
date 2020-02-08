function plot_hough_lines(hough_lines)

for kk = 1:length(hough_lines)
   xy = [hough_lines(kk).point1; hough_lines(kk).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',3,'Color','green');

   % Plot beginnings and ends of lines
   scatter(xy(1,1),xy(1,2), 40,'o', 'cyan', 'filled');
   scatter(xy(2,1),xy(2,2), 40,'o', 'red', 'filled');
end

end

