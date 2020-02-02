function Z_Coordinate = tip_2_world_depth( WORLD_Measures, cross_ratio )
%tip_2_world_depth computes depth of Finger-Tip in 'World Coordinates
% System' by mean of relation between Image Cross-Ratio and real world
% known measurements.
%
% OUTPUTS:
%    * Z_Coordinate - float number defining depth of Finger-Tip w.r.t.
%    World origin system (See PROCEDURE for further details)
%
% INPUT:
%    * WORLD_Measures - struct of hardcoded measurements of world distances
%
%    * cross_ratio - float number defining cross ratio between 4 points
%
% 
% PROCEDURE:
% 0) Explenation: 
%    * Since Cross-Ratio (Cr) is an invariant in projective transformations
%    frame's computed value can be used a fixed parameter for real world
%    coordinate system.
%
%    * input Cr is computed from, in strict order: 
%       - Black-Keys finishing border (B),
%       - Finger-Tip (T),
%       - White-Keys finishing border (W),
%       - Vanishing point (Vp).
%
%
% 1) Cross_ratios are matched together:
%       
%                          TW      BVp
%       Cr_img = Cr_Wld = ----- * -----
%                          TVp     BW
%     
%    Since Infinite Distances can be ignored relation is simplied in:
%       
%       Cr_img = BW / TW   -->   TW = BW / Cr
% 
%     
% 2) Since all four points are colinear in both Systems distances are
%    computed using 1D formulas, resulting in depth (Z) of point
%    In this framework distances can be translated in coordinates values
%    w.l.o.g
% 
%       TW = | Z_t - Z_w |  -->  Z_t = Z_w - TW
%
%
%
% NOTES:
%    * WORLD Coordinate System Origin (O) is fixed where keyboard's keys
%      are connected to the plastic command board. Z-axis grows through 
%      keys lenght.
%
%    * OB and OW measurements are written in WORLD Coordinates resulting
%      in Known Distance BW.
%
%    * Depending on cross-ratio values there are 3 possible points
%      ordering:
%
%        - Cr > 1: B - T - W - Vp
%
%        - 0 < Cr < 1: T - B - W - Vp 
%
%        - Cr < 0: B - W - T - Vp
%
%
% See also FRONT_Tips2World


K = WORLD_Measures.KBD_internals.Only_WHITE_Portion_LEN / cross_ratio;
Z_Coordinate = WORLD_Measures.KBD_internals.WHITE_Key_LEN - K;

end

