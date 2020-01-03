function contour = hand_perimeter(hand)
%hand_perimeter Extracts Contour of hand by mean of fudged Sobel Edge Operator
% OUTPUTS:
%    * contour - logical image representing hand perimeter
%
% INPUT:
%    * hand - greyscale image of each hand
%   
% References:
%    1) https://it.mathworks.com/help/images/detecting-a-cell-using-image-segmentation.html
%    2) https://en.wikipedia.org/wiki/Fudge_factor
      

% Double Sobel tresholding
[~,threshold] = edge(hand,'sobel');
fudgeFactor = 0.5;
sobel = edge(hand,'sobel',threshold * fudgeFactor);

perimeter = bwperim(sobel);
contour = imfill(perimeter, 'holes');

end

