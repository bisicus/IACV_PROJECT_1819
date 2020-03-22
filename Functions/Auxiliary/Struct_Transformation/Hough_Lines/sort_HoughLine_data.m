function hough_data = sort_HoughLine_data(hough_data, sort_key, varargin)
%SORT_HOUGHLINE_DATA Summary of this function goes here
%   Detailed explanation goes here

% ===== INPUT SANITATION ===== %
parser = inputParser();
addRequired(parser, 'hough_data'); %TODO: add check on structure
addRequired(parser, 'sort_key'); %TODO: add check on accepted values

addOptional(parser, 'sort_direction', 'ascend');


parse(parser, hough_data, sort_key, varargin{:});
hough_data = parser.Results.hough_data;
sort_key = parser.Results.sort_key;
sort_direction = parser.Results.sort_direction;


switch sort_key
   case 'theta'
      to_sort = vertcat(hough_data.theta);
   case 'rho'
      to_sort = vertcat(hough_data.rho);
   case 'point'
      
      % Make for each line, Bottom Point as 'point1'
      
      for ii = 1:length(hough_data)
         if hough_data(ii).point1(2) < hough_data(ii).point2(2) %SWAP
         
            buf = hough_data(ii).point1;
            hough_data(ii).point1 = hough_data(ii).point2;
            hough_data(ii).point2 = buf;
         end
      end
      to_sort = vertcat(hough_data.point1);
end

   [~, idx] = sortrows(to_sort, 1, sort_direction);
   
   hough_data = hough_data(idx);

end

