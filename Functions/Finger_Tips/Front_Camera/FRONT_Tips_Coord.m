function finger_tips = FRONT_Tips_Coord(fingers)
%FRONT_Tips_Coord returns a set of [x,y] (= [col, row]) coordinates from a
%binary image where each ROI corresponds to a finger.
%Coordinate are computed as the "spike" of each finger.
%
% OUTPUTS:
%    * finger_tips - vertically stacked [x,y] integer coordinates matrix
%
%
% INPUT:
%    * hands - binary frame
%
%
% PROCEDURE:
%    
%    1) Selection of bottom-most part of perimeter, deleting borders near
%       hand wrist
%
%    2) Tip Selection from Bottom-Perimeter:
%       a) Translation of Bottom-Perimeter in a 1D Signal, obtaining two
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
% See also FRONT_Finger_tips, UP_Tips_Coord


   % ====== 1. Bottom-Most Perimeter Selection ===== %

   % a. Isolating Perimeter's [row, col] indices
[row, col] = find(fingers == 1);
data = [row, col];


   % b. Selection of bottom-most index for each column
[unique_col_idx,~,ix] = unique(data(:,2));
%{
   since Images have Coordinate Origin on top-left corner of the image,
   @min function must be used in order to extract top-most border index.
   
%}
bottomMost_Row_idx = accumarray(ix, data(:,1), [], @max);


   % ===== 2a. Transformation in 1D Signal ===== %
   % Obtaining a piecewise function on [X, Y] axes

Y = zeros(size(fingers, 2), 1);
Y(unique_col_idx) = bottomMost_Row_idx;


   % ===== 2b. Peaks Finding ===== %
[peaks,idxs] = findpeaks(Y, ...
                     'NPeaks', 10, ...
                     'MinPeakProminence', 8, ...
                     'MinPeakDistance', 25, ...
                     'MinPeakWidth', 5 ...
                     );

               

% Plotting
% X = 1:1:size(fingers, 2); % # Columns
% figure(2); plot(X,Y,idxs,peaks,'r*')


   % ===== Peaks Return ===== %

finger_tips = [idxs, peaks]; %[col, row] = [x, y]

end