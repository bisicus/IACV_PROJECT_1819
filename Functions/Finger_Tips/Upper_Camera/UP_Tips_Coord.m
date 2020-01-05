function finger_tips = UP_Tips_Coord(hands)
%UP_Tips_Coord Extracts Contour of hand by mean of fudged Sobel Edge Operator
% OUTPUTS:
%    * finger_tips - ...
%
% INPUT:
%    * hands - greyscale frame
%   
% PROCEDURE:
%    1) Compute Perimeter of visible hands, returning a logical image
%
%    2) Selection of top-most part of perimeter, deleting borders near
%       wrist
%
%    3) Tip Selection from Top-Border:
%       a) Transformation of Top-Border in a 1D Signal, obtaining two
%          distinct continuous curve lines
%       b) Selection of local maxima of each line in term of [col, row]
%          coordinates
%          NOTE: [col, row] = [x, y]
% 
% References:
%    1) https://www.mathworks.com/matlabcentral/answers/462320-filtering-column-data-with-the-same-value
%    2) https://it.mathworks.com/help/signal/ref/findpeaks.html#namevaluepairs

   % ===== 1. Perimeter ===== %
hands = imbinarize(hands);
perim = bwperim(hands);


   % ====== 2. Top-Most Perimeter Selection ===== %

   % a. Isolating Perimeter's [row, col] indices
[row, col] = find(perim == 1);
data = [row, col];


   % b. Selection of top-most index for each column
[unique_col_idx,~,ix] = unique(data(:,2));
%{
   since Images have Coordinate Origin on top-left corner of the image,
   @min function must be used in order to extract top-most border index.
   
%}
topMost_Row_idx = accumarray(ix, data(:,1), [], @min);


   % ===== 3a. Transformation in 1D Signal ===== %
% Obtaining a piecewise function limited frame size on [X, Y] axes


Y = zeros(size(hands, 2), 1);
% Since functions have their origin on bottom-left corner, there's need to
% reflect Y values 
img_topLeft_corner = size(hands, 1); % # Rows
Y(unique_col_idx) = img_topLeft_corner - topMost_Row_idx;


   % ===== 3b. Peaks Finding ===== %
[peaks,idxs] = findpeaks(Y, ...
                     'NPeaks', 10, ...
                     'MinPeakHeight', size(hands, 1) / 4.5, ...
                     'MinPeakProminence', 5, ...
                     'MinPeakDistance', 25);
               

% Plotting
% X = 1:1:size(hands, 2); % # Columns
% figure(2); plot(X,Y,idxs,peaks,'r*')

   % ===== Peaks Return ===== %
% Inverse reflection of Peaks on Y Axis returning to images coordinate
% system
finger_tips = [idxs, img_topLeft_corner - peaks]; %[col, row] = [x, y]

end