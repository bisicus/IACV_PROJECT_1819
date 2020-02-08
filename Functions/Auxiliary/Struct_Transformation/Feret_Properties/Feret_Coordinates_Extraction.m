function coords = Feret_Coordinates_Extraction(Feret_data, values)
%Feret_Coordinates_Extraction Handles regionprops returned data-structure
%when called with Max[Min] Feret Properties argument.
%Depending on 'values' returns high or low coordinates.
%   
% FUNCTION CALL SKETCH
%    coords = Feret_Coordinates_Extraction([props.MaxFeretCoordinates], 'high')
%
%
% OUTPUTS:
%    * coords - matrix of stacked row vectors in the form [x, y]
% 
%    
% INPUTS:
%    * Feret_data - matrix containing stacked regionprops Max[Min] Feret
%    Coordinates
%
%    * values - string defining which data have to be returned
%       Admitted Values are: 'high', 'low'
%
% See also regionprops

%{
obtain a 3D matrix so that at each level contains:
   [col,row] of one extremity  =  [x,y]
   [col,row] of other extremity   =  [x,y]
%}

Feret_data = reshape(Feret_data, 2,2,[]);

%{
Since in some cases extremities are put at random, there's need to sort so 
that at the end  matrix will contain:
   [col,row] of higher extremity    =  [x,y]
   [col,row] of lower extremity   =  [x,y]
   for each finger
%}

for ii = 1:size(Feret_data,3)
   if Feret_data(1,2,ii) < Feret_data(2,2,ii)
      Feret_data(:,:,ii) = flip(Feret_data(:,:,ii), 1);
   end
end

if strcmp(values, 'high')
   idx = 1;
elseif strcmp(values, 'low')
   idx = 2;
else
   error('invalid "values" argument: must be "high" or "low"');
end

Feret_data = Feret_data(idx,:,:);

% data is still a 3D Matrix with dimension 1*2*len(data)
% width and row dimension are swapped.


coords = permute(Feret_data, [3,2,1]);
