function plot_hough_lines(hough_lines, varargin)

parser = inputParser();
addRequired(parser, 'hough_lines'); %TODO: add check on structure

addOptional(parser, 'color', 'blue');


parse(parser, hough_lines, varargin{:});
hough_lines = parser.Results.hough_lines;
color = parser.Results.color;


for kk = 1:length(hough_lines)
   xy = [hough_lines(kk).point1; hough_lines(kk).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',3,'Color', color);

   % Plot beginnings and ends of lines
   scatter(xy(1,1),xy(1,2), 55,'o', 'cyan', 'filled');
   scatter(xy(2,1),xy(2,2), 55,'o', 'red', 'filled');
end

end

