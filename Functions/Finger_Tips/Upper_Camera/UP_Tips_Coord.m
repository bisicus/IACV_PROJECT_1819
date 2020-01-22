function finger_tips = UP_Tips_Coord(hands_perim)
%UP_Tips_Coord returns a set of [x,y] (= [col, row]) coordinates from a
%logical image of hands' perimeter.
%Coordinate are computed as the "spike" of each finger.
%
% OUTPUTS:
%    * finger_tips - vertically stacked [x,y] integer coordinates matrix
%
%
% INPUT:
%    * hands_perim - binary image
%
%
% PROCEDURE:
%    1) Compute Perimeter of visible hands, returning a logical image
%
%    2) Selection of top-most part of perimeter, deleting borders near
%       wrist
%
%    3) Tip Selection from Top-Perimeter:
%       a) Translation of Top-Perimeter in a 1D Signal, obtaining two
%          distinct continuous curve lines
%       b) Selection of local maxima of each line in term of [x, y]
%          coordinates
%          NOTE: [x, y] = [col, row]
%
% 
% References:
%    1) https://www.mathworks.com/matlabcentral/answers/462320-filtering-column-data-with-the-same-value
%    2) https://it.mathworks.com/help/signal/ref/findpeaks.html#namevaluepairs
%
%
% See also UP_Finger_tips, FRONT_Tips_Coord


   % ====== 1. Top-Most Perimeter Selection ===== %

   % a. Isolating Perimeter's [row, col] indices
[row, col] = find(hands_perim == 1);
data = [row, col];


   % b. Selection of top-most index for each column
[unique_col_idx,~,ix] = unique(data(:,2));
%{
   since Images have Coordinate Origin on top-left corner of the image,
   @min function must be used in order to extract top-most border index.
   
%}
topMost_Row_idx = accumarray(ix, data(:,1), [], @min);


   % ===== 2a. Transformation in 1D Signal ===== %
% Obtaining a piecewise function limited frame size on [X, Y] axes


Y = zeros(size(hands_perim, 2), 1);
% Since functions have their origin on bottom-left corner, there's need to
% reflect Y values 
img_topLeft_corner = size(hands_perim, 1); % # Rows
Y(unique_col_idx) = img_topLeft_corner - topMost_Row_idx;


   % ===== 2b. Peaks Finding ===== %
[peaks,idxs] = findpeaks(Y, ...
                     'NPeaks', 10, ...
                     'MinPeakHeight', size(hands_perim, 1) / 4.5, ...
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