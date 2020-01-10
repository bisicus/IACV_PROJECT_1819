function finger_tips = FRONT_Tips_Coord(fingers)
%FRONT_Tips_Coord ...
% OUTPUTS:
%    * finger_tips - ...
%
% INPUT:
%    * hands - greyscale frame
%   
% PROCEDURE:
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


   % ====== 2. Top-Most Perimeter Selection ===== %

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


   % ===== 3a. Transformation in 1D Signal ===== %
% Obtaining a piecewise function limited frame size on [X, Y] axes


Y = zeros(size(fingers, 2), 1);
Y(unique_col_idx) = bottomMost_Row_idx;


   % ===== 3b. Peaks Finding ===== %
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
% Inverse reflection of Peaks on Y Axis returning to images coordinate
% system

finger_tips = [idxs, peaks]; %[col, row] = [x, y]

end