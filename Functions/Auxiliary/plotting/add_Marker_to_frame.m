function frame = add_Marker_to_frame(frame, enlight_coords, color)
%ADDCIRCLETOKEYS adds opaque circles on coordinates 
% pressed key coordinate
% 


% in case of Homogenous Coordinates inputs
if size(enlight_coords, 2) > 2
   enlight_coords = enlight_coords(:,1:2);
end


radius = 13; %px

% InserShape requires a [:,3] matrix defined as:
%     [col, row, rad]
circle_coord = radius .* ones( size(enlight_coords, 1), 3 );
circle_coord(:,1:2) = enlight_coords;


frame = insertShape(...
   frame, 'FilledCircle', circle_coord, ...
   'LineWidth', 3, 'Color', color, ...
   'Opacity', 0.6 ...
);


end

