function coords = Extrema_Coord_AVG(props, values)
%Extrema_Coord_AVG Handles regionprops returned data-structure when called
%with Extrema argument.
%Depending on 'values' returns high or low coordinates.
%Resulting Coordinates are mean of Bottom[Top] Left & Right Extrema of the
%bwregion
%
% FUNCTION CALL SKETCH
%    coords = Extrema_Coord_AVG(props, 'high')
%
%
% OUTPUTS:
%    * coords - matrix of stacked row vectors in the form [x, y]
% 
%    
% INPUTS:
%    * props - regiorprops function result
%
%    * values - string defining which data have to be returned
%       Admitted Values are: 'high', 'low'
%
%
% NOTE: regionprops.Extrema are ALWAYS assumed to be ordered as:
%     [top-left;     - 1
%      top-right;    - 2
%      right-top;    - 3
%      right-bottom; - 4
%      bottom-right; - 5
%      bottom-left;  - 6
%      left-bottom;  - 7
%      left-top]     - 8
%
%
% See also regionprops


%{
obtain a 3D matrix so that at each level contains all 8 extremities of BW
region, stacked as a 2D matrix in the form:

   [col,row] of one extremity  =  [x,y]
%}
extrema = cat(3, props.Extrema);


% Choosing top or bottom extremity
switch values
   case 'high' 
      idxs = [1, 2];
   case 'high-extended' 
      idxs = [1, 2, 3, 8];
   case 'low'
      idxs = [5, 6];
   case 'low-extended'
      idxs = [4, 5, 6, 7];
   otherwise
      error('invalid "values" argument: must be "high" or "low" with accessory "-extent" tag');
end

extrema = extrema(idxs, :,:);


% Averaging extremas' coordinates
extrema = mean( extrema, 1 );


% data is still a 3D Matrix with dimension 1*2*len(data)
% width and row dimension are swapped.
coords = permute(extrema, [3,2,1]);
