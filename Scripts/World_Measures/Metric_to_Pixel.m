

%% Transform some measurements from metric system to pixel in order to compute distances during Computation

% Widths
Camera_Measures.WHITE_Key_WIDTH = ...
         WORLD_Measures.KBD_internals.WHITE_Key_WIDTH  / ...
         WORLD_Measures.Up_Cam.metr_over_px_RATIO;
      
      
Camera_Measures.BLACK_Key_WIDTH = ...
         WORLD_Measures.KBD_internals.BLACK_Key_WIDTH  / ...
         WORLD_Measures.Up_Cam.metr_over_px_RATIO;
      


% Lenghts

Camera_Measures.WHITE_Key_LEN = ...
         WORLD_Measures.KBD_internals.WHITE_Key_LEN  / ...
         WORLD_Measures.Up_Cam.metr_over_px_RATIO;
      
      
Camera_Measures.BLACK_Key_LEN = ...
         WORLD_Measures.KBD_internals.BLACK_Key_LEN_avg  / ...
         WORLD_Measures.Up_Cam.metr_over_px_RATIO;