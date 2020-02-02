function perim = hand_perimeter(hand)
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
      

% 1) Fudge Sobel tresholding
[~,threshold] = edge(hand,'sobel');
fudgeFactor = 0.5;
sobel = edge(hand,'sobel',threshold * fudgeFactor);


% 2) Enhancing Canny Edge Detection
edg = edge(hand, 'Canny', 0.1, 1);
bw = imbinarize(hand, 0.6);
canny = edg & bw;


% 3) Combining Edges with Perimeter in order to obtain more detailed image
perim = canny | sobel;
perim = bwperim(perim);


% 4) Connecting sparse lines to perimeter holes
perim = bwmorph(perim, 'diag'); 
perim = bwmorph(perim, 'bridge', Inf);

% 5) Thinning Lines to only 1 pixel
perim = bwmorph(perim, 'thin', Inf);
perim = bwmorph(perim, 'clean', Inf);
perim = bwmorph(perim, 'remove', Inf);

% 6) Cleaning
perim = bwmorph(perim, 'close', 1);
perim = bwmorph(perim, 'shrink', 1);

end

