
%%          %%%%%%%%%%%%%%%%%%%%%%%%%
            %%% KEYBOARD INTERNAL %%%
            %%%   MEASUREMENTS    %%%
            %%%%%%%%%%%%%%%%%%%%%%%%%


%{
   World Coordinate System Origin (O) is fixed where keyboard's keys are
   connected to the plastic command board.
   Z-axis grows through keys LENght.
            
%}
            
% NOTE: All Measuments are taken in millimeters

      %% ----- Lenghts ----- %
WORLD_Measures.KBD_internals.WHITE_Key_LEN= 135;


WORLD_Measures.KBD_internals.BLACK_Key_LEN_max = 85;

WORLD_Measures.KBD_internals.BLACK_Key_LEN_min = 80;

WORLD_Measures.KBD_internals.BLACK_Key_LEN_avg = ...
               mean( [ WORLD_Measures.KBD_internals.BLACK_Key_LEN_max, ...
                       WORLD_Measures.KBD_internals.BLACK_Key_LEN_min ] );

                                      
WORLD_Measures.KBD_internals.Only_WHITE_Portion_LEN = ...
               abs( WORLD_Measures.KBD_internals.WHITE_Key_LEN -  ...
                     WORLD_Measures.KBD_internals.BLACK_Key_LEN_min );
   
                  
      %% ----- Heights ----- %
% ALL HEIGHTS ARE TAKEN STARTING FROM DESK PLATE %

WORLD_Measures.KBD_internals.WHITE_Key_HEIGHT = 56;

WORLD_Measures.KBD_internals.BLACK_Key_HEIGHT = 68;

WORLD_Measures.KBD_internals.Only_BLACK_Portion_HEIGHT = ...
               abs( WORLD_Measures.KBD_internals.BLACK_Key_HEIGHT - ...
                     WORLD_Measures.KBD_internals.WHITE_Key_HEIGHT );


      %% ----- Widths ----- %
      
WORLD_Measures.KBD_internals.WHITE_Key_WIDTH = 21.6;


%%          %%%%%%%%%%%%%%%%%%%%%%%%%
            %%% KEYBOARD EXTERNAL %%%
            %%%   MEASUREMENTS    %%%
            %%%%%%%%%%%%%%%%%%%%%%%%%


% NOTE: All Measuments are taken in centimeters  

      %% ----- Heights ----- %
% NOTE: Height Measurements are take starting from Deask plane
      
% Keyboard Maximum Height, corresponding to Plastic Control board
WORLD_Measures.KBD_externals.HEIGHT_max = 12.76;

% Keyboard Minimum Height, corresponding to Distance in between table and
% white Keys
WORLD_Measures.KBD_externals.HEIGHT_min = 5.6;


      %% ----- Depths ----- %
% Keyboard Depth, measured from control board to White Keys ending
WORLD_Measures.KBD_externals.DEPTH = 33;

% Control Board Depth
WORLD_Measures.KBD_externals.controlBoard_DEPTH = ...
            abs( WORLD_Measures.KBD_externals.DEPTH - ...
                 WORLD_Measures.KBD_internals.WHITE_Key_LEN / 10 );
               

% Keyboard-Desk distance, measured from Desk border to Control Board
% measurement have been averaged on a "by-hand" preprocessing step
WORLD_Measures.KBD_externals.kbd_desk_DIST = 7.35;
   
      
      
%%          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% CAMERA SYSTEM RELATED %%%
            %%%      MEASUREMENTS     %%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
% NOTE: Measurements are took in Centimeters
            

      %% ----- Desk ----- %
      
% Desk Height
WORLD_Measures.Desk.HEIGHT = 75;

% Desk Depth
WORLD_Measures.Desk.DEPTH = 60;



      %% ----- Camera Reference System ----- %

% Height of FRONT Camera from ground
WORLD_Measures.Front_Cam.HEIGHT_from_ground = 130;

% Horizonal Distance between FRONT Camera and Keyboard
WORLD_Measures.Front_Cam.cam_desk_DIST = 80;


      %% ----- Viewing Rays inclination Angle ----- %

%{
   Since there is a significant discrepancy in between lenght of
   "Camera - Keyboard" and "Hands on Keyboard" reference systems all the
   viewing rays starting from FRONT Camera going to Hands can be summarized
   by an angle included in the range:
      - MAX: Camera to 'starting keys line'
      - MIN: Camera to 'ending keys line'
      
   NOTE: Angles are measured in RADIANTS
%}
      
% For computation purpose only
Height = WORLD_Measures.Front_Cam.HEIGHT_from_ground - ...
         WORLD_Measures.Desk.HEIGHT - ...
         WORLD_Measures.KBD_externals.HEIGHT_min;

          
          
L_min = WORLD_Measures.Front_Cam.cam_desk_DIST + ...
        WORLD_Measures.KBD_externals.kbd_desk_DIST + ...
        WORLD_Measures.KBD_externals.controlBoard_DEPTH;


WORLD_Measures.Front_Cam.ANGLE_min = atan( L_min / Height );
     
L_max = WORLD_Measures.Front_Cam.cam_desk_DIST + ...
        WORLD_Measures.KBD_externals.kbd_desk_DIST + ...
        WORLD_Measures.KBD_externals.DEPTH;
     
WORLD_Measures.Front_Cam.ANGLE_max = atan( L_max / Height );


WORLD_Measures.Front_Cam.ANGLE_avg = ...
               mean( [ WORLD_Measures.Front_Cam.ANGLE_max, ...
                       WORLD_Measures.Front_Cam.ANGLE_min ] );

                    
%% ----- Workspace Cleaning ----- %

clear L_max L_min Height