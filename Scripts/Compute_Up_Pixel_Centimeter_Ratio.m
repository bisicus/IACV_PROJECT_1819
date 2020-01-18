      %% ----- Upper Camera Pixel/Centimeter Relation ----- %
%{
   In the assumption that  Upper Camera is perfectly parallel to Keyboard's
   Keys plane it's possible to relate centimeters to pixel lenght
      
%}
       
%% Finding Convex Hull of each key to obtain a clean polygon
BW = up_video.WhiteKeys_Mask;

convex_hull = bwconvhull(BW,'objects', 8);

%% Compute Mean of each key longest diagonal, in Pixels

props = regionprops(convex_hull, 'MaxFeretProperties');

diag = vertcat(props.MaxFeretDiameter);
px_diag = mean(diag);

%% Compute Real World Diagonal lenght
% NOTE: Measurements are in millimeters

real_len = WORLD_Measures.KBD_internals.WHITE_Key_LEN;
real_width = WORLD_Measures.KBD_internals.WHITE_Key_WIDTH;

real_diag = ( real_len^2 + real_width^2 )^0.5;

%% Compute pixel/millimiter ratio:

WORLD_Measures.Up_Cam.px_to_mm_RATIO = real_diag / px_diag;


%% Plotting

% figure(300); 
% h = imshowpair(BW, convex_hull);
% axis = h.Parent;
% for ii = 1:36
%     xmin = [props(ii).MaxFeretCoordinates(1,1) props(ii).MaxFeretCoordinates(2,1)];
%     ymin = [props(ii).MaxFeretCoordinates(1,2) props(ii).MaxFeretCoordinates(2,2)];
%     imdistline(axis,xmin,ymin);
% end
% 
% title( {'Keys versus Convex Hull', ...
%        'Measurements of each key diagonal'} );

      %% ----- Clean Workspace ----- %
      
clear BW convex_hull
clear props diag px_diag
clear real_diag real_len real_width
clear h axis xmin ymin ii
