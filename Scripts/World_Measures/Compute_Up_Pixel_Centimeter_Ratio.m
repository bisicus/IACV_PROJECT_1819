      
      %% ===== Upper Camera Pixel/Centimeter Relation ===== %%
%{
   In the assumption that  Upper Camera is perfectly parallel to Keyboard's
   Keys plane it's possible to relate centimeters to pixel lenght
      
%}
       
      %% ===== WHITE KEYS ===== %
      %  ---------------------- %
      
%% Finding Convex Hull of each key obtaining a clean polygon
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

white_ratio = real_diag / px_diag;


%% Plotting

if show_figures == 1
   figure(300);
   hold on;
   
   h = imshow(BW);
   axis = h.Parent;
   for ii = 1:36
       xmin = [props(ii).MaxFeretCoordinates(1,1) props(ii).MaxFeretCoordinates(2,1)];
       ymin = [props(ii).MaxFeretCoordinates(1,2) props(ii).MaxFeretCoordinates(2,2)];
       dst = imdistline(axis,xmin,ymin);
       text_lab = getLabelHandle(dst);
       text_lab.FontSize = 14;
       text_lab.FontWeight = 'bold';
       text_lab.Rotation = 180+dst.getAngleFromHorizontal;
       text_lab.HorizontalAlignment = 'center';
       text_lab.VerticalAlignment = 'middle';
       text_lab.Margin = 0.5;
       text_lab.EdgeColor = [0.65,0.65,0.65];
       text_lab.LineWidth = 1;
       text_lab.BackgroundColor = [0.94,0.94,0.94]; 
   end

   title( {'White Keys versus Convex Hull', ...
           'Measurements of each key diagonal'} );
        
   hold off;
end


      %% ===== BLACK KEYS ===== %
      %  ---------------------- %
      

%% Finding Convex Hull of each key to obtain a clean polygon
BW = up_video.BlackKeys_Mask;

convex_hull = bwconvhull(BW,'objects', 8);

%% Compute Mean of each key longest diagonal, in Pixels

props = regionprops(convex_hull, 'MaxFeretProperties');

diag = vertcat(props.MaxFeretDiameter);
px_diag = mean(diag);

%% Compute Real World Diagonal lenght
% NOTE: Measurements are in millimeters

real_len = WORLD_Measures.KBD_internals.BLACK_Key_LEN_avg;
real_width = WORLD_Measures.KBD_internals.BLACK_Key_WIDTH;

real_diag = ( real_len^2 + real_width^2 )^0.5;

%%  ----- Compute pixel/millimiter ratio ----- %

black_ratio = real_diag / px_diag;


%% Plotting

if show_figures == 1
   figure(301);
   h = imshow(BW);
   axis = h.Parent;
   for ii = 1:25
       xmin = [props(ii).MaxFeretCoordinates(1,1) props(ii).MaxFeretCoordinates(2,1)];
       ymin = [props(ii).MaxFeretCoordinates(1,2) props(ii).MaxFeretCoordinates(2,2)];
       dst = imdistline(axis,xmin,ymin);
       text_lab = getLabelHandle(dst);
       text_lab.FontSize = 14;
       text_lab.FontWeight = 'bold';
       text_lab.Rotation = 180+dst.getAngleFromHorizontal;
       text_lab.HorizontalAlignment = 'center';
       text_lab.VerticalAlignment = 'middle';
       text_lab.Margin = 0.5;
       text_lab.EdgeColor = [0.65,0.65,0.65];
       text_lab.LineWidth = 1;
       text_lab.BackgroundColor = [0.94,0.94,0.94];
   end

   title( {'Black Keys versus Convex Hull', ...
           'Measurements of each key diagonal'} );
end

      %% ===== COMBINE BLACK AND WHITE RATIO ===== %
      %  ----------------------------------------- %
      

WORLD_Measures.Up_Cam.metr_over_px_RATIO = mean( [black_ratio, white_ratio] ); % [m/px]


      %% ----- Clean Workspace ----- %
      
clear BW convex_hull
clear props diag px_diag
clear real_diag real_len real_width
clear black_ratio white_ratio
clear h axis xmin ymin ii
clear ans