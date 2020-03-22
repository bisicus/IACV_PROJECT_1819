function plot_homog_line(line, varargin)
% in Homogeneous Coordinates System a point X=[x,y,1] belongs to a 
% line L=[a, b, 1] if: 
%       X * L = [x,y,1] * [a, b, 1] = 0
% From this relation line can be plotted as well by mean fixin X
% coordinates in plot:

% NOTE: when calling this function, reference image is supposed to be
% called with 'hold on' feature

parser = inputParser();
addRequired(parser, 'line'); %TODO: add check on structure

addOptional(parser, 'X_limit', [1,1920]); %TODO: add check on accepted values
addOptional(parser, 'color', 'blue');


parse(parser, line, varargin{:});
line = parser.Results.line;
X_limit= parser.Results.X_limit;
color = parser.Results.color;


if line(3) ~= 1
  line = line / line(3);
end

a = line(1);
b = line(2);

Y_limit = -(a*X_limit + 1) / b;

plot(X_limit, Y_limit, 'LineWidth', 2, 'Color', color)
end